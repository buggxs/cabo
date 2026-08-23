import 'package:app_links/app_links.dart';

/// Thin wrapper around [AppLinks] so link handling stays testable and the
/// verification URL lives in one place.
class DeepLinkService {
  DeepLinkService({AppLinks? appLinks}) : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  static const String host = 'www.buggxs.com';
  static const String verifiedPath = '/cabo/verified';

  /// The link that launched the app, for the cold start case.
  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  /// Links arriving while the app is already running.
  Stream<Uri> get linkStream => _appLinks.uriLinkStream;

  bool isEmailVerifiedLink(Uri uri) =>
      uri.host == host && uri.path.startsWith(verifiedPath);
}
