import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Allows doc comments only on type declarations, static methods and
/// top-level functions.
///
/// Instance members, constructors, fields, enum values and top-level
/// variables should be self-explanatory through their naming instead.
class RestrictedDocComments extends DartLintRule {
  const RestrictedDocComments() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'restricted_doc_comments',
    problemMessage:
        'Doc comments are only allowed on types, static methods and '
        'top-level functions.',
    correctionMessage:
        'Remove the doc comment and express the intent through naming.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((MethodDeclaration node) {
      if (!node.isStatic) {
        _check(node, reporter);
      }
    });
    context.registry.addFieldDeclaration(
      (FieldDeclaration node) => _check(node, reporter),
    );
    context.registry.addConstructorDeclaration(
      (ConstructorDeclaration node) => _check(node, reporter),
    );
    context.registry.addEnumConstantDeclaration(
      (EnumConstantDeclaration node) => _check(node, reporter),
    );
    context.registry.addTopLevelVariableDeclaration(
      (TopLevelVariableDeclaration node) => _check(node, reporter),
    );
  }

  void _check(AnnotatedNode node, ErrorReporter reporter) {
    final Comment? docComment = node.documentationComment;
    if (docComment != null) {
      reporter.atNode(docComment, _code);
    }
  }
}
