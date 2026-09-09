import 'package:cabo/misc/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the external donation links (PayPal, Buy Me a Coffee).
class DonationService with LoggerMixin {
  static const String paypalUrl = 'https://paypal.me/devsalzzy';

  static const String buyMeACoffeeUrl = 'https://buymeacoffee.com/buggxs';

  Future<bool> openPaypal() => _openExternally(paypalUrl);

  Future<bool> openBuyMeACoffee() => _openExternally(buyMeACoffeeUrl);

  Future<bool> _openExternally(String url) async {
    try {
      return await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      logger.warning('Error opening donation link $url: $e');
      return false;
    }
  }
}
