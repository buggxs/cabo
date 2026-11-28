import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Reads an integer option of [rule] from `analysis_options.yaml`, falling
/// back to [fallback] when it is missing or not a number.
int readIntOption(
  CustomLintConfigs configs, {
  required String rule,
  required String option,
  required int fallback,
}) {
  final Object? value = configs.rules[rule]?.json[option];
  return value is int ? value : fallback;
}

/// Reads a list option of [rule] from `analysis_options.yaml`. A missing or
/// malformed option yields an empty list.
List<String> readListOption(
  CustomLintConfigs configs,
  String rule,
  String option,
) {
  final Object? value = configs.rules[rule]?.json[option];
  if (value is! List) {
    return <String>[];
  }
  return value.map((Object? entry) => entry.toString()).toList();
}
