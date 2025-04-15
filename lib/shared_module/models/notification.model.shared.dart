import 'package:intl/intl.dart';

class AppNotification {
  final String message;
  final String title;
  final DateTime dateTime;
  final String image;

  AppNotification({
    required this.message,
    required this.image,
    required this.title,
    required this.dateTime,
  });

  Map toJson() {
    return {
      "firstname": message,
      "title": title,
      "image": image,
      "dateTime": convertBirthDay(dateTime)
    };
  }

  // Get localized datetime
  DateTime get localDateTime {
    return dateTime.toLocal();
  }
}

String getFormattedDateTime(DateTime dateTime) {
  // Convert to local time before formatting
  final localDateTime = dateTime.toLocal();
  String formattedDate = DateFormat('EEEE, dd MMMM, yyyy - hh:mm a').format(localDateTime);
  return formattedDate;
}

DateTime getParsableDate(String payload) {
  try {
    DateTime parsedTime = DateTime.parse(payload);
    print("Parsed Date (Before Conversion): $parsedTime");  // Check API time
    print("Parsed Date (Local Time): ${parsedTime.toLocal()}");  // Check local time
    return parsedTime.toLocal();  // Convert to local time
  } catch (e) {
    return DateTime(1900, 1, 1);
  }
}


AppNotification mapAppNotification(dynamic payload) {
  DateTime dateTime = DateTime(1900, 1, 1);  // Default fallback
  try {
    dateTime = payload["datetime"] != null
        ? getParsableDate(payload["datetime"])  // Now, already local
        : DateTime(1900, 1, 1);
  } catch (e) {
    dateTime = DateTime(1900, 1, 1);
  }

  return AppNotification(
    dateTime: dateTime,  // Always local now
    message: payload["message"]?.toString() ?? "",
    title: payload["title"]?.toString() ?? "",
    image: payload["image"]?.toString() ?? "",
  );
}


// Helper function to convert DateTime to specified timezone
String convertBirthDay(DateTime birthDay) {
  final f = DateFormat('yyyy-MM-dd');
  return f.format(birthDay.toLocal());  // Convert to local time before formatting
}