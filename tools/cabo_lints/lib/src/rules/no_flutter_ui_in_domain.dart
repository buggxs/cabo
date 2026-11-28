import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids Flutter UI libraries in the domain layer.
///
/// Cubits are covered by the `avoid_flutter_imports` rule of `bloc_lint`.
class NoFlutterUiInDomain extends DartLintRule {
  const NoFlutterUiInDomain() : super(code: _code);

  static const String domainLayer = '/lib/domain/';

  static const List<String> uiLibraries = <String>[
    'package:flutter/material.dart',
    'package:flutter/widgets.dart',
    'package:flutter/cupertino.dart',
  ];

  static const LintCode _code = LintCode(
    name: 'no_flutter_ui_in_domain',
    problemMessage: 'The domain layer must not depend on Flutter UI libraries.',
    correctionMessage:
        "Use 'package:flutter/foundation.dart' or move the UI code into a "
        'component.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (!isInside(resolver.path, domainLayer)) {
      return;
    }
    context.registry.addImportDirective((ImportDirective node) {
      if (uiLibraries.contains(node.uri.stringValue)) {
        reporter.atNode(node.uri, _code);
      }
    });
  }
}
