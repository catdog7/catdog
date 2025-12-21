DateTime convertToDateTime(String timeString) {
  return DateTime.parse(timeString);
}

String convertToTimeString(DateTime timeString) {
  return timeString.toIso8601String();
}

DateTime? convertToDateTimeWithNull(String? timeString) {
  return timeString == null ? null : DateTime.parse(timeString);
}

String? convertToTimeStringWithNull(DateTime? time) {
  return time?.toIso8601String();
}
