import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids keeping a `BuildContext` in a field or variable.
///
/// A stored context can outlive its widget. Use the `context` at hand, or
/// capture what is actually needed (a navigator, a messenger, a text).
class NoStoredBuildContext extends DartLintRule {
  const NoStoredBuildContext() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'no_stored_build_context',
    problemMessage: "Don't store a BuildContext in '{0}'.",
    correctionMessage:
        'Use the context directly or capture the object you need from it.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclarationList((VariableDeclarationList node) {
      final String? type = node.type?.toSource();
      if (type != 'BuildContext' && type != 'BuildContext?') {
        return;
      }
      for (final VariableDeclaration variable in node.variables) {
        reporter.atToken(
          variable.name,
          _code,
          arguments: <Object>[variable.name.lexeme],
        );
      }
    });
  }
}
