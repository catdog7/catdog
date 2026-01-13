import 'package:intl/intl.dart';

class TimeFormatter {
  TimeFormatter._();

  static String formatRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return "방금 전";
    final now = DateTime.now();
    //final localDateTime = dateTime.isUtc ? dateTime.toLocal() : dateTime;
    final localDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
    final difference = now.difference(localDateTime);

    // print("defference : ${difference}");
    // print("dateTime : $dateTime (isUtc: ${dateTime?.isUtc})");
    // print("now : ${DateTime.now()} (isUtc: ${DateTime.now().isUtc})");
    // 미래의 시간이 들어올 경우를 대비한 처리
    if (difference.isNegative) return '방금 전';

    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;

    if (seconds < 60) {
      return '방금 전';
    } else if (minutes < 60) {
      return '$minutes분 전';
    } else if (hours < 24) {
      return '$hours시간 전';
    } else if (days < 7) {
      return '$days일 전';
    } else if (days < 30) {
      return '${(days / 7).floor()}주 전';
    } else if (days < 365) {
      return '${(days / 30).floor()}개월 전';
    } else {
      return '${(days / 365).floor()}년 전';
    }
  }

  static String formatDate(DateTime? dateTime, {String pattern = 'MM월 dd일'}) {
    if (dateTime == null) return '';
    return DateFormat(pattern).format(dateTime);
  }
}
