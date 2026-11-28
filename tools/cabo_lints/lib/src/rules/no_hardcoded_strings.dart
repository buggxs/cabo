import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:cabo_lints/src/rule_options.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids user facing string literals in widgets, so that every text goes
/// through the localizations.
///
/// Checks the first argument of `Text(...)` and common text parameters such
/// as `hintText` or `tooltip`. Literals without words (symbols, pure
/// interpolations) are allowed. Configurable via an `exclude` list of path
/// fragments, e.g. for debug-only screens.
class NoHardcodedStrings extends DartLintRule {
  const NoHardcodedStrings({this.excludedPaths = const <String>[]})
    : super(code: _code);

  factory NoHardcodedStrings.fromConfigs(CustomLintConfigs configs) {
    return NoHardcodedStrings(
      excludedPaths: readListOption(configs, _code.name, 'exclude'),
    );
  }

  static const String sourceRoot = '/lib/';

  static const Set<String> textParameters = <String>{
    'hintText',
    'labelText',
    'helperText',
    'errorText',
    'tooltip',
    'semanticLabel',
    'semanticsLabel',
  };

  static const LintCode _code = LintCode(
    name: 'no_hardcoded_strings',
    problemMessage: 'User facing texts must not be hardcoded.',
    correctionMessage:
        'Add the text to the ARB files and use AppLocalizations.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  static final RegExp _word = RegExp('[A-Za-zÄÖÜäöüß]{2,}');

  final List<String> excludedPaths;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final bool isChecked =
        isInside(resolver.path, sourceRoot) &&
        !isInsideAny(resolver.path, excludedPaths);
    if (!isChecked) {
      return;
    }
    context.registry.addInstanceCreationExpression((
      InstanceCreationExpression node,
    ) {
      final NodeList<Expression> arguments = node.argumentList.arguments;
      final bool isText = node.constructorName.type.toSource() == 'Text';
      if (isText && arguments.isNotEmpty) {
        _check(arguments.first, reporter);
      }
    });
    context.registry.addNamedExpression((NamedExpression node) {
      if (textParameters.contains(node.name.label.name)) {
        _check(node.expression, reporter);
      }
    });
  }

  void _check(Expression expression, ErrorReporter reporter) {
    if (_hasWords(expression)) {
      reporter.atNode(expression, _code);
    }
  }

  bool _hasWords(Expression expression) {
    if (expression is SimpleStringLiteral) {
      return _word.hasMatch(expression.value);
    }
    if (expression is AdjacentStrings) {
      return expression.strings.any(_hasWords);
    }
    if (expression is StringInterpolation) {
      return expression.elements.whereType<InterpolationString>().any(
        (InterpolationString part) => _word.hasMatch(part.value),
      );
    }
    return false;
  }
}
