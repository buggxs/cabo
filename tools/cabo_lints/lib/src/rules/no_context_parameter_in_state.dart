import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids `BuildContext` parameters on methods of `State` classes.
///
/// A `State` already exposes `context`, so passing it around only adds
/// noise. Overridden methods such as `build` are exempt.
class NoContextParameterInState extends DartLintRule {
  const NoContextParameterInState() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'no_context_parameter_in_state',
    problemMessage:
        "'{0}' takes a BuildContext although the State already provides one.",
    correctionMessage: "Remove the parameter and use the State's 'context'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((ClassDeclaration node) {
      if (!_isState(node)) {
        return;
      }
      for (final MethodDeclaration method
          in node.members.whereType<MethodDeclaration>()) {
        _checkMethod(method, reporter);
      }
    });
  }

  bool _isState(ClassDeclaration node) {
    final String superclass = node.extendsClause?.superclass.toSource() ?? '';
    return superclass.split('<').first == 'State';
  }

  void _checkMethod(MethodDeclaration method, ErrorReporter reporter) {
    final bool isOverride = method.metadata.any(
      (Annotation annotation) => annotation.name.name == 'override',
    );
    final NodeList<FormalParameter>? parameters = method.parameters?.parameters;
    if (isOverride || parameters == null) {
      return;
    }
    final bool hasContextParameter = parameters.any(_isContextParameter);
    if (hasContextParameter) {
      reporter.atToken(
        method.name,
        _code,
        arguments: <Object>[method.name.lexeme],
      );
    }
  }

  bool _isContextParameter(FormalParameter parameter) {
    final FormalParameter declared = parameter is DefaultFormalParameter
        ? parameter.parameter
        : parameter;
    return declared is SimpleFormalParameter &&
        declared.type?.toSource() == 'BuildContext';
  }
}
