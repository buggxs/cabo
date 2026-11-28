import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Limits a file to one public widget plus at most two private widgets.
class MaxWidgetsPerFile extends DartLintRule {
  const MaxWidgetsPerFile() : super(code: _code);

  static const int maxPublicWidgets = 1;
  static const int maxPrivateWidgets = 2;

  static const LintCode _code = LintCode(
    name: 'max_widgets_per_file',
    problemMessage:
        "The widget '{0}' exceeds the limit of 1 public and 2 private "
        'widgets per file.',
    correctionMessage: 'Move the widget into its own file.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit(
      (CompilationUnit unit) => _checkUnit(unit, reporter),
    );
  }

  void _checkUnit(CompilationUnit unit, ErrorReporter reporter) {
    final List<ClassDeclaration> widgets = unit.declarations
        .whereType<ClassDeclaration>()
        .where(_isWidget)
        .toList();
    final Iterable<ClassDeclaration> publicWidgets = widgets.where(
      (ClassDeclaration widget) => !_isPrivate(widget),
    );
    final Iterable<ClassDeclaration> privateWidgets = widgets.where(_isPrivate);
    final List<ClassDeclaration> surplusWidgets = <ClassDeclaration>[
      ...publicWidgets.skip(maxPublicWidgets),
      ...privateWidgets.skip(maxPrivateWidgets),
    ];
    for (final ClassDeclaration widget in surplusWidgets) {
      reporter.atToken(
        widget.name,
        _code,
        arguments: <Object>[widget.name.lexeme],
      );
    }
  }

  bool _isPrivate(ClassDeclaration node) => node.name.lexeme.startsWith('_');

  bool _isWidget(ClassDeclaration node) {
    final List<InterfaceType> supertypes =
        node.declaredFragment?.element.allSupertypes ?? <InterfaceType>[];
    return supertypes.any(
      (InterfaceType type) => type.getDisplayString() == 'Widget',
    );
  }
}
