import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Requires every instance field of an `Equatable` class to be part of its
/// `props`.
///
/// A field missing from `props` is ignored by equality, so a state change
/// that only touches this field never reaches the UI.
class EquatablePropsComplete extends DartLintRule {
  const EquatablePropsComplete() : super(code: _code);

  static const Set<String> equatableTypes = <String>{
    'Equatable',
    'EquatableMixin',
  };

  static const LintCode _code = LintCode(
    name: 'equatable_props_complete',
    problemMessage: "The field '{0}' is missing from 'props'.",
    correctionMessage: "Add it to the list returned by 'props'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((ClassDeclaration node) {
      if (!_isEquatable(node)) {
        return;
      }
      final Set<String> propsNames = _namesUsedInProps(node);
      for (final Token field in _instanceFields(node)) {
        if (!propsNames.contains(field.lexeme)) {
          reporter.atToken(field, _code, arguments: <Object>[field.lexeme]);
        }
      }
    });
  }

  bool _isEquatable(ClassDeclaration node) {
    final List<InterfaceType> supertypes =
        node.declaredFragment?.element.allSupertypes ?? <InterfaceType>[];
    return supertypes.any(
      (InterfaceType type) => equatableTypes.contains(type.getDisplayString()),
    );
  }

  Iterable<Token> _instanceFields(ClassDeclaration node) {
    return node.members
        .whereType<FieldDeclaration>()
        .where((FieldDeclaration field) => !field.isStatic)
        .expand((FieldDeclaration field) => field.fields.variables)
        .map((VariableDeclaration variable) => variable.name);
  }

  Set<String> _namesUsedInProps(ClassDeclaration node) {
    final _IdentifierCollector collector = _IdentifierCollector();
    final Iterable<MethodDeclaration> propsGetters = node.members
        .whereType<MethodDeclaration>()
        .where(
          (MethodDeclaration member) =>
              member.isGetter && member.name.lexeme == 'props',
        );
    for (final MethodDeclaration getter in propsGetters) {
      getter.body.accept(collector);
    }
    return collector.names;
  }
}

class _IdentifierCollector extends RecursiveAstVisitor<void> {
  final Set<String> names = <String>{};

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    names.add(node.name);
    super.visitSimpleIdentifier(node);
  }
}
