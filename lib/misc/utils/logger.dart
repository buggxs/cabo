import 'package:logging/logging.dart';

mixin LoggerMixin {
  Logger get logger => Logger('$runtimeType');
}
