import 'package:intl/intl.dart';

extension CaboDateParser on DateFormat {
  DateTime? parseCaboDateString(String date) {
    try {
      return DateFormat('dd-MM-yyyy').parse(date);
    } on FormatException catch (e) {
      try {
        return DateFormat('MM/dd/yyyy').parse(date);
      } on FormatException catch (e) {
        return DateTime.tryParse(date);
      }
    }
  }
}
