import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Limits the number of lines of method and function bodies.
///
/// `build` methods get a separate, higher limit, because widget trees are
/// naturally longer than plain logic. Both limits can be configured in
/// `analysis_options.yaml` via `max_lines` and `max_build_lines`.
class MaxMethodLength extends DartLintRule {
  const MaxMethodLength({
    this.maxLines = defaultMaxLines,
    this.maxBuildLines = defaultMaxBuildLines,
  }) : super(code: _code);

  factory MaxMethodLength.fromConfigs(CustomLintConfigs configs) {
    final Map<String, Object?> options =
        configs.rules[_code.name]?.json ?? <String, Object?>{};
    return MaxMethodLength(
      maxLines: _readLimit(options['max_lines'], defaultMaxLines),
      maxBuildLines: _readLimit(
        options['max_build_lines'],
        defaultMaxBuildLines,
      ),
    );
  }

  static const int defaultMaxLines = 50;
  static const int defaultMaxBuildLines = 80;

  static const LintCode _code = LintCode(
    name: 'max_method_length',
    problemMessage: "'{0}' is {1} lines long, the maximum is {2}.",
    correctionMessage: 'Split it into smaller methods or widgets.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  final int maxLines;
  final int maxBuildLines;

  static int _readLimit(Object? value, int fallback) {
    return value is int ? value : fallback;
  }

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final LineInfo lineInfo = resolver.lineInfo;
    final bool isTestFile = resolver.path.endsWith('_test.dart');
    context.registry.addMethodDeclaration((MethodDeclaration node) {
      _check(node.name, node.body, lineInfo, reporter);
    });
    context.registry.addFunctionDeclaration((FunctionDeclaration node) {
      final bool isTestEntryPoint = isTestFile && node.name.lexeme == 'main';
      if (!isTestEntryPoint) {
        _check(node.name, node.functionExpression.body, lineInfo, reporter);
      }
    });
  }

  void _check(
    Token name,
    FunctionBody body,
    LineInfo lineInfo,
    ErrorReporter reporter,
  ) {
    final int firstLine = lineInfo.getLocation(body.offset).lineNumber;
    final int lastLine = lineInfo.getLocation(body.end).lineNumber;
    final int lineCount = lastLine - firstLine + 1;
    final int limit = name.lexeme == 'build' ? maxBuildLines : maxLines;
    if (lineCount <= limit) {
      return;
    }
    reporter.atToken(
      name,
      _code,
      arguments: <Object>[name.lexeme, lineCount, limit],
    );
  }
}
