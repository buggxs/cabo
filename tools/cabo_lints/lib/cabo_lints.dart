import 'package:cabo_lints/src/rules/bool_prefix.dart';
import 'package:cabo_lints/src/rules/layer_boundaries.dart';
import 'package:cabo_lints/src/rules/max_method_length.dart';
import 'package:cabo_lints/src/rules/max_widgets_per_file.dart';
import 'package:cabo_lints/src/rules/no_flutter_ui_in_domain.dart';
import 'package:cabo_lints/src/rules/restricted_doc_comments.dart';
import 'package:cabo_lints/src/rules/use_navigation_service.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Entry point picked up by the custom_lint analyzer plugin.
PluginBase createPlugin() => _CaboLintsPlugin();

class _CaboLintsPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => <LintRule>[
    const BoolPrefix(),
    const MaxWidgetsPerFile(),
    MaxMethodLength.fromConfigs(configs),
    const RestrictedDocComments(),
    const UseNavigationService(),
    const LayerBoundaries(),
    const NoFlutterUiInDomain(),
  ];
}
