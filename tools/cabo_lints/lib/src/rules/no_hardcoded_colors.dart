import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:cabo_lints/src/rule_options.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids `Colors.x` and `Color(...)` outside of the theme, because the app
/// ships several designs and a fixed color only fits one of them.
///
/// `Colors.transparent` is allowed. The theme files are listed in the
/// `exclude` option.
class NoHardcodedColors extends DartLintRule {
  const NoHardcodedColors({this.excludedPaths = const <String>[]})
    : super(code: _code);

  factory NoHardcodedColors.fromConfigs(CustomLintConfigs configs) {
    return NoHardcodedColors(
      excludedPaths: readListOption(configs, _code.name, 'exclude'),
    );
  }

  static const String sourceRoot = '/lib/';

  static const LintCode _code = LintCode(
    name: 'no_hardcoded_colors',
    problemMessage: 'Colors must come from the theme.',
    correctionMessage: 'Use a color of CaboTheme or add one there.',
    errorSeverity: ErrorSeverity.WARNING,
  );

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
    context.registry.addPrefixedIdentifier((PrefixedIdentifier node) {
      final bool isMaterialColor =
          node.prefix.name == 'Colors' && node.identifier.name != 'transparent';
      if (isMaterialColor) {
        reporter.atNode(node, _code);
      }
    });
    context.registry.addInstanceCreationExpression((
      InstanceCreationExpression node,
    ) {
      if (node.constructorName.type.toSource() == 'Color') {
        reporter.atNode(node, _code);
      }
    });
  }
}
