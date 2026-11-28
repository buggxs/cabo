import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Forbids unnamed numbers in the business logic (`lib/domain` and cubits).
///
/// 0, 1 and 2 are allowed. A number counts as named when it initialises a
/// constant, is the default value of a parameter, or is passed as a named
/// argument. Widgets are not checked, sizes and paddings are normal there.
class NoMagicNumbers extends DartLintRule {
  const NoMagicNumbers() : super(code: _code);

  static const List<String> checkedPaths = <String>['/lib/domain/', '/cubit/'];
  static const Set<num> allowedNumbers = <num>{0, 1, 2};

  static const LintCode _code = LintCode(
    name: 'no_magic_numbers',
    problemMessage: 'The number {0} has no name.',
    correctionMessage: 'Extract it into a well-named constant.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final bool isChecked =
        isInside(resolver.path, '/lib/') &&
        isInsideAny(resolver.path, checkedPaths);
    if (!isChecked) {
      return;
    }
    context.registry.addIntegerLiteral(
      (IntegerLiteral node) => _check(node, node.value, reporter),
    );
    context.registry.addDoubleLiteral(
      (DoubleLiteral node) => _check(node, node.value, reporter),
    );
  }

  void _check(Literal node, num? value, ErrorReporter reporter) {
    final bool isAllowed = value == null || allowedNumbers.contains(value);
    if (isAllowed || _isNamed(node)) {
      return;
    }
    reporter.atNode(node, _code, arguments: <Object>[node.toSource()]);
  }

  bool _isNamed(AstNode node) {
    return node.thisOrAncestorMatching<AstNode>(_givesName) != null;
  }

  bool _givesName(AstNode node) {
    if (node is VariableDeclarationList) {
      return node.isConst;
    }
    return node is NamedExpression ||
        node is DefaultFormalParameter ||
        node is EnumConstantDeclaration ||
        node is Annotation;
  }
}
