import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Keeps the inner layers (`domain`, `core`, `common`) independent of the
/// feature modules in `components`.
///
/// The navigation layer and the service locator are composition roots and
/// therefore allowed to reference features.
class LayerBoundaries extends DartLintRule {
  const LayerBoundaries() : super(code: _code);

  static const String featureImportPrefix = 'package:cabo/components/';

  static const List<String> innerLayers = <String>[
    '/lib/domain/',
    '/lib/core/',
    '/lib/common/',
  ];

  static const List<String> compositionRoots = <String>[
    '/lib/core/app_navigator/',
    '/lib/core/app_service_locator.dart',
  ];

  static const LintCode _code = LintCode(
    name: 'layer_boundaries',
    problemMessage:
        "Files in 'domain', 'core' and 'common' must not import feature "
        "modules from 'components'.",
    correctionMessage:
        'Move the shared code into an inner layer or invert the dependency.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final bool isInnerLayer = isInsideAny(resolver.path, innerLayers);
    final bool isCompositionRoot = isInsideAny(resolver.path, compositionRoots);
    if (!isInnerLayer || isCompositionRoot) {
      return;
    }
    context.registry.addImportDirective((ImportDirective node) {
      final String importedUri = node.uri.stringValue ?? '';
      if (importedUri.startsWith(featureImportPrefix)) {
        reporter.atNode(node.uri, _code);
      }
    });
  }
}
