import 'package:cabo_lints/src/rules/bool_prefix.dart';
import 'package:cabo_lints/src/rules/equatable_props_complete.dart';
import 'package:cabo_lints/src/rules/layer_boundaries.dart';
import 'package:cabo_lints/src/rules/max_file_length.dart';
import 'package:cabo_lints/src/rules/max_method_length.dart';
import 'package:cabo_lints/src/rules/max_parameters.dart';
import 'package:cabo_lints/src/rules/max_widgets_per_file.dart';
import 'package:cabo_lints/src/rules/mounted_before_set_state.dart';
import 'package:cabo_lints/src/rules/no_context_parameter_in_state.dart';
import 'package:cabo_lints/src/rules/no_flutter_ui_in_domain.dart';
import 'package:cabo_lints/src/rules/no_global_context.dart';
import 'package:cabo_lints/src/rules/no_hardcoded_colors.dart';
import 'package:cabo_lints/src/rules/no_hardcoded_strings.dart';
import 'package:cabo_lints/src/rules/no_magic_numbers.dart';
import 'package:cabo_lints/src/rules/no_stored_build_context.dart';
import 'package:cabo_lints/src/rules/prefer_l10n_extension.dart';
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
    MaxParameters.fromConfigs(configs),
    MaxFileLength.fromConfigs(configs),
    NoHardcodedStrings.fromConfigs(configs),
    NoHardcodedColors.fromConfigs(configs),
    const NoGlobalContext(),
    const NoStoredBuildContext(),
    const NoContextParameterInState(),
    const EquatablePropsComplete(),
    const MountedBeforeSetState(),
    const NoMagicNumbers(),
    const PreferL10nExtension(),
  ];
}
