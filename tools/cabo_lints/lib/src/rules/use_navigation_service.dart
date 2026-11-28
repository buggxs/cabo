import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids calling `Navigator` directly outside of the navigation layer.
class UseNavigationService extends DartLintRule {
  const UseNavigationService() : super(code: _code);

  static const String navigationLayer = '/lib/core/app_navigator/';

  static const LintCode _code = LintCode(
    name: 'use_navigation_service',
    problemMessage: "Don't call Navigator directly.",
    correctionMessage: 'Use the NavigationService registered in GetIt.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isInside(resolver.path, navigationLayer)) {
      return;
    }
    context.registry.addMethodInvocation((MethodInvocation node) {
      final Expression? target = node.target;
      if (target is SimpleIdentifier && target.name == 'Navigator') {
        reporter.atNode(node, _code);
      }
    });
  }
}
