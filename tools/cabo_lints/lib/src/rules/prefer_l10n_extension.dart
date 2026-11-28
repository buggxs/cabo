import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Requires `context.l10n` instead of `AppLocalizations.of(context)!`, so
/// there is one way to read localized texts.
class PreferL10nExtension extends DartLintRule {
  const PreferL10nExtension() : super(code: _code);

  static const String sourceRoot = '/lib/';
  static const String extensionFile = 'context_extensions.dart';

  static const LintCode _code = LintCode(
    name: 'prefer_l10n_extension',
    problemMessage: "Use 'context.l10n' instead of 'AppLocalizations.of'.",
    correctionMessage:
        "Import 'context_extensions.dart' and read 'context.l10n'.",
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
        !resolver.path.endsWith(extensionFile);
    if (!isChecked) {
      return;
    }
    context.registry.addMethodInvocation((MethodInvocation node) {
      final Expression? target = node.target;
      final bool isLookup =
          target is SimpleIdentifier &&
          target.name == 'AppLocalizations' &&
          node.methodName.name == 'of';
      if (isLookup) {
        reporter.atNode(node, _code);
      }
    });
  }
}
