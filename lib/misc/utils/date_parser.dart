import 'package:intl/intl.dart';

extension CaboDateParser on DateFormat {
  DateTime? parseCaboDateString(String date) {
    try {
      return DateFormat('dd-MM-yyyy').parse(date);
    } on FormatException catch (_) {
      try {
        return DateFormat('MM/dd/yyyy').parse(date);
      } on FormatException catch (_) {
        return DateTime.tryParse(date);
      }
    }
  }
}
