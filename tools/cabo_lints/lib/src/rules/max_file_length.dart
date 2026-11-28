import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:cabo_lints/src/project_paths.dart';
import 'package:cabo_lints/src/rule_options.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Limits the number of lines of files in `lib/`.
///
/// Test files are exempt. Configurable via `max_lines` and an `exclude` list
/// of path fragments.
class MaxFileLength extends DartLintRule {
  const MaxFileLength({
    this.maxLines = defaultMaxLines,
    this.excludedPaths = const <String>[],
  }) : super(code: _code);

  factory MaxFileLength.fromConfigs(CustomLintConfigs configs) {
    return MaxFileLength(
      maxLines: readIntOption(
        configs,
        rule: _code.name,
        option: 'max_lines',
        fallback: defaultMaxLines,
      ),
      excludedPaths: readListOption(configs, _code.name, 'exclude'),
    );
  }

  static const int defaultMaxLines = 400;
  static const String sourceRoot = '/lib/';

  static const LintCode _code = LintCode(
    name: 'max_file_length',
    problemMessage: 'This file is {0} lines long, the maximum is {1}.',
    correctionMessage: 'Split it into smaller, focused files.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  final int maxLines;
  final List<String> excludedPaths;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    final bool isChecked =
        isInside(resolver.path, sourceRoot) &&
        !isInsideAny(resolver.path, excludedPaths);
    if (!isChecked) {
      return;
    }
    context.registry.addCompilationUnit((CompilationUnit unit) {
      final int lineCount = resolver.lineInfo.lineCount;
      if (lineCount > maxLines) {
        reporter.atToken(
          unit.beginToken,
          _code,
          arguments: <Object>[lineCount, maxLines],
        );
      }
    });
  }
}
