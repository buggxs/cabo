import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/rule_options.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Limits the number of parameters of methods and functions.
///
/// Constructors and `copyWith` are exempt, because widgets and models
/// naturally take many named parameters. Overridden methods are exempt,
/// because their signature is dictated by the overridden declaration.
/// Configurable via `max_positional` and `max_total`.
class MaxParameters extends DartLintRule {
  const MaxParameters({
    this.maxPositional = defaultMaxPositional,
    this.maxTotal = defaultMaxTotal,
  }) : super(code: _code);

  factory MaxParameters.fromConfigs(CustomLintConfigs configs) {
    return MaxParameters(
      maxPositional: readIntOption(
        configs,
        rule: _code.name,
        option: 'max_positional',
        fallback: defaultMaxPositional,
      ),
      maxTotal: readIntOption(
        configs,
        rule: _code.name,
        option: 'max_total',
        fallback: defaultMaxTotal,
      ),
    );
  }

  static const int defaultMaxPositional = 3;
  static const int defaultMaxTotal = 6;

  static const LintCode _code = LintCode(
    name: 'max_parameters',
    problemMessage:
        "'{0}' takes {1} positional and {2} parameters in total, the maximum "
        'is {3} positional and {4} in total.',
    correctionMessage:
        'Group related parameters into an object or use named parameters.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  final int maxPositional;
  final int maxTotal;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((MethodDeclaration node) {
      final bool isExempt =
          node.name.lexeme == 'copyWith' || _hasOverride(node.metadata);
      if (!isExempt) {
        _check(node.name, node.parameters, reporter);
      }
    });
    context.registry.addFunctionDeclaration((FunctionDeclaration node) {
      _check(node.name, node.functionExpression.parameters, reporter);
    });
  }

  bool _hasOverride(NodeList<Annotation> metadata) {
    return metadata.any(
      (Annotation annotation) => annotation.name.name == 'override',
    );
  }

  void _check(
    Token name,
    FormalParameterList? parameters,
    ErrorReporter reporter,
  ) {
    if (parameters == null) {
      return;
    }
    final int total = parameters.parameters.length;
    final int positional = parameters.parameters
        .where((FormalParameter parameter) => parameter.isPositional)
        .length;
    if (positional <= maxPositional && total <= maxTotal) {
      return;
    }
    reporter.atToken(
      name,
      _code,
      arguments: <Object>[
        name.lexeme,
        positional,
        total,
        maxPositional,
        maxTotal,
      ],
    );
  }
}
