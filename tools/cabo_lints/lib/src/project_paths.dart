/// Returns whether [filePath] contains the given project relative [segment],
/// independent of the platform specific path separator.
bool isInside(String filePath, String segment) {
  final String normalizedPath = filePath.replaceAll(r'\', '/');
  return normalizedPath.contains(segment);
}

/// Returns whether [filePath] is inside one of the given [segments].
bool isInsideAny(String filePath, List<String> segments) {
  return segments.any((String segment) => isInside(filePath, segment));
}
