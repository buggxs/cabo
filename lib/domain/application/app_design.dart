/// Selectable visual design of the app.
///
/// [modern] is the current Material 3 light design. [classic] restores the
/// original dark-green look with the background image. Only colors and the
/// background image differ between them; typography and layout stay identical.
enum AppDesign {
  modern,
  classic;

  static AppDesign fromName(String? name) {
    return AppDesign.values.firstWhere(
      (AppDesign design) => design.name == name,
      orElse: () => AppDesign.modern,
    );
  }
}
