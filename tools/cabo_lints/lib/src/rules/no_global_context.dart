import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids reading the global navigator context outside of the navigation
/// layer.
///
/// Code that needs a `BuildContext` should receive one from its widget, and
/// code without a widget should not depend on UI state at all.
class NoGlobalContext extends DartLintRule {
  const NoGlobalContext() : super(code: _code);

  static const String sourceRoot = '/lib/';
  static const String navigationLayer = '/lib/core/app_navigator/';

  static const LintCode _code = LintCode(
    name: 'no_global_context',
    problemMessage:
        "Don't read the global navigator context outside of the navigation "
        'layer.',
    correctionMessage:
        'Pass a BuildContext from the widget or use the NavigationService.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final bool isChecked =
        isInside(resolver.path, sourceRoot) &&
        !isInside(resolver.path, navigationLayer);
    if (!isChecked) {
      return;
    }
    context.registry.addSimpleIdentifier((SimpleIdentifier node) {
      if (node.name == 'currentContext') {
        reporter.atNode(node, _code);
      }
    });
  }
}
