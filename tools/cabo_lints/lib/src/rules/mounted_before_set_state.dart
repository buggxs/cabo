import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Requires a `mounted` check between an `await` and a following `setState`.
///
/// The widget may have been disposed while the future was pending, and
/// calling `setState` then throws.
class MountedBeforeSetState extends DartLintRule {
  const MountedBeforeSetState() : super(code: _code);

  static const LintCode _code = LintCode(
    name: 'mounted_before_set_state',
    problemMessage:
        "'setState' is called after an 'await' without checking "
        "'mounted'.",
    correctionMessage: "Add 'if (!mounted) return;' after the await.",
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((MethodInvocation node) {
      final bool isSetState =
          node.target == null && node.methodName.name == 'setState';
      final FunctionBody? body = node.thisOrAncestorOfType<FunctionBody>();
      if (!isSetState || body == null || !body.isAsynchronous) {
        return;
      }
      final _BodyScanner scanner = _BodyScanner();
      body.visitChildren(scanner);
      if (_isUnguarded(node, scanner)) {
        reporter.atNode(node.methodName, _code);
      }
    });
  }

  bool _isUnguarded(MethodInvocation setState, _BodyScanner scanner) {
    final Iterable<int> earlierAwaits = scanner.awaits
        .where(
          (AwaitExpression awaited) =>
              awaited.end <= setState.offset &&
              !_isInOtherBranch(awaited, setState),
        )
        .map((AwaitExpression awaited) => awaited.end);
    if (earlierAwaits.isEmpty) {
      return false;
    }
    final int lastAwaitEnd = earlierAwaits.reduce(
      (int a, int b) => a > b ? a : b,
    );
    final bool hasMountedCheck = scanner.mountedOffsets.any(
      (int offset) => offset > lastAwaitEnd && offset < setState.offset,
    );
    return !hasMountedCheck;
  }

  bool _isInOtherBranch(AstNode awaited, AstNode setState) {
    AstNode? ancestor = awaited.parent;
    while (ancestor != null) {
      if (ancestor is IfStatement) {
        final Statement? elseBranch = ancestor.elseStatement;
        final bool isAwaitInThen = _contains(ancestor.thenStatement, awaited);
        final bool isSetStateInElse =
            elseBranch != null && _contains(elseBranch, setState);
        final bool isAwaitInElse =
            elseBranch != null && _contains(elseBranch, awaited);
        final bool isSetStateInThen = _contains(
          ancestor.thenStatement,
          setState,
        );
        if ((isAwaitInThen && isSetStateInElse) ||
            (isAwaitInElse && isSetStateInThen)) {
          return true;
        }
      }
      ancestor = ancestor.parent;
    }
    return false;
  }

  bool _contains(AstNode outer, AstNode inner) {
    return inner.offset >= outer.offset && inner.end <= outer.end;
  }
}

/// Collects awaits and `mounted` reads of one function body, without
/// descending into nested closures.
class _BodyScanner extends RecursiveAstVisitor<void> {
  final List<AwaitExpression> awaits = <AwaitExpression>[];
  final List<int> mountedOffsets = <int>[];

  @override
  void visitAwaitExpression(AwaitExpression node) {
    awaits.add(node);
    super.visitAwaitExpression(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.name == 'mounted') {
      mountedOffsets.add(node.offset);
    }
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {}
}
