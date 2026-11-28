import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Requires boolean variables, fields, parameters, getters and record fields
/// to start with a descriptive prefix such as `is`, `has` or `can`.
///
/// Members annotated with `@override` are skipped, because their names are
/// dictated by the overridden declaration.
class BoolPrefix extends DartLintRule {
  const BoolPrefix() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'bool_prefix',
    problemMessage:
        "The boolean '{0}' should start with one of: "
        'is, has, can, should, was, did, will.',
    correctionMessage: "Rename it, e.g. to 'is{1}'.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  static final RegExp _validName = RegExp(
    r'^_*(is|has|can|should|was|did|will)[A-Z0-9]',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclarationList(
      (VariableDeclarationList node) => _checkVariables(node, reporter),
    );
    context.registry.addSimpleFormalParameter(
      (SimpleFormalParameter node) => _checkParameter(node, reporter),
    );
    context.registry.addMethodDeclaration(
      (MethodDeclaration node) => _checkGetter(node, reporter),
    );
    context.registry.addRecordTypeAnnotation(
      (RecordTypeAnnotation node) => _checkRecordFields(node, reporter),
    );
  }

  void _checkRecordFields(RecordTypeAnnotation node, ErrorReporter reporter) {
    final List<RecordTypeAnnotationField> fields = <RecordTypeAnnotationField>[
      ...node.positionalFields,
      ...?node.namedFields?.fields,
    ];
    for (final RecordTypeAnnotationField field in fields) {
      final Token? name = field.name;
      if (name != null && _isBool(field.type)) {
        _checkName(name, reporter);
      }
    }
  }

  void _checkVariables(VariableDeclarationList node, ErrorReporter reporter) {
    final AstNode? parent = node.parent;
    final bool isOverriddenField =
        parent is FieldDeclaration && _hasOverride(parent.metadata);
    if (!_isBool(node.type) || isOverriddenField) {
      return;
    }
    for (final VariableDeclaration variable in node.variables) {
      _checkName(variable.name, reporter);
    }
  }

  void _checkParameter(SimpleFormalParameter node, ErrorReporter reporter) {
    final Token? name = node.name;
    if (name == null || !_isBool(node.type) || !_isRenamable(node)) {
      return;
    }
    _checkName(name, reporter);
  }

  void _checkGetter(MethodDeclaration node, ErrorReporter reporter) {
    final bool isBoolGetter = node.isGetter && _isBool(node.returnType);
    if (!isBoolGetter || _hasOverride(node.metadata)) {
      return;
    }
    _checkName(node.name, reporter);
  }

  bool _isRenamable(SimpleFormalParameter node) {
    final FormalParameterList? parameters = node
        .thisOrAncestorOfType<FormalParameterList>();
    final AstNode? owner = parameters?.parent;
    if (owner is MethodDeclaration) {
      return !_hasOverride(owner.metadata);
    }
    return owner is! GenericFunctionType &&
        owner is! FunctionTypedFormalParameter;
  }

  bool _isBool(TypeAnnotation? type) {
    final String? source = type?.toSource();
    return source == 'bool' || source == 'bool?';
  }

  bool _hasOverride(NodeList<Annotation> metadata) {
    return metadata.any(
      (Annotation annotation) => annotation.name.name == 'override',
    );
  }

  void _checkName(Token name, ErrorReporter reporter) {
    final String lexeme = name.lexeme;
    if (_validName.hasMatch(lexeme)) {
      return;
    }
    reporter.atToken(
      name,
      _code,
      arguments: <Object>[lexeme, _capitalize(lexeme)],
    );
  }

  String _capitalize(String name) {
    final String publicName = name.replaceFirst(RegExp('^_+'), '');
    if (publicName.isEmpty) {
      return name;
    }
    return publicName[0].toUpperCase() + publicName.substring(1);
  }
}
