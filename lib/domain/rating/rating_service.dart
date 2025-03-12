import 'package:cabo/components/widgets/rating_dialog.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingService with LoggerMixin {
  static const String _gameCountKey = 'rating_game_count';
  static const String _hasRatedKey = 'has_rated_app';
  static const String _lastPromptDateKey = 'last_rating_prompt_date';
  static const int _gamesUntilRating = 3;
  static const int _minDaysBetweenPrompts = 7;

  final InAppReview _inAppReview = InAppReview.instance;

  // Check if we should show rating dialog and increment game count
  Future<void> trackGameCompletion() async {
    if (await hasUserRated()) {
      // User has already rated, don't prompt again
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    int gameCount = prefs.getInt(_gameCountKey) ?? 0;
    gameCount++;

    await prefs.setInt(_gameCountKey, gameCount);
    log.info('Game count increased to: $gameCount');

    if (gameCount < _gamesUntilRating) {
      return;
    }

    if (await _shouldShowPrompt()) {
      // Check if we can use the native in-app review flow
      if (await _inAppReview.isAvailable()) {
        log.info('Using native in-app review flow');

        // Try the native review flow first
        try {
          await _inAppReview.requestReview();
          await setHasRated(true);
        } catch (e) {
          log.warning(
              'Native review flow failed: $e - Falling back to custom dialog');
          await RatingDialog.show();
        }
      } else {
        // If the native review flow is not available, show our custom dialog
        log.info('Native review not available, showing custom dialog');
        await RatingDialog.show();
      }

      await prefs.setInt(_gameCountKey, 0); // Reset count after showing dialog
      await _updateLastPromptDate();
    }
  }

  Future<void> setHasRated(bool hasRated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasRatedKey, hasRated);

    if (hasRated) {
      // Reset game count when user has rated
      await prefs.setInt(_gameCountKey, 0);
    }
  }

  Future<bool> hasUserRated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasRatedKey) ?? false;
  }

  Future<bool> _shouldShowPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPromptDateStr = prefs.getString(_lastPromptDateKey);

    if (lastPromptDateStr == null) {
      return true; // First time showing prompt
    }

    try {
      final lastPromptDate = DateTime.parse(lastPromptDateStr);
      final daysElapsed = DateTime.now().difference(lastPromptDate).inDays;

      return daysElapsed >= _minDaysBetweenPrompts;
    } catch (e) {
      log.warning('Error parsing last prompt date: $e');
      return true;
    }
  }

  Future<void> _updateLastPromptDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPromptDateKey, DateTime.now().toIso8601String());
  }

  // Open the store listing directly (can be called from about screen or settings)
  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing();
    } catch (e) {
      log.warning('Error opening store listing: $e');
    }
  }

  // Handle rating submission
  Future<void> submitRating(int rating, String? feedback) async {
    log.info('User submitted rating: $rating, feedback: $feedback');

    try {
      await _requestStoreReview();
    } catch (e) {
      log.warning('Error handling rating submission: $e');
    }

    // Mark that the user has rated the app
    await setHasRated(true);
  }

  // Request a review from the app store
  Future<void> _requestStoreReview() async {
    try {
      // Check if the app store review flow is available
      final available = await _inAppReview.isAvailable();

      if (available) {
        log.info('Requesting app store review');
        await _inAppReview.requestReview();
      } else {
        log.info(
            'App store review not available, opening store listing instead');
        // If in-app review is not available, open the store listing
        await _inAppReview.openStoreListing();
      }
    } catch (e) {
      log.warning('Error requesting app store review: $e');
    }
  }
}
