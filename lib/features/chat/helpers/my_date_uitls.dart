import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return TimeOfDay.fromDateTime(date).format(context);
  }

  // get time send and read
  static String getMessgaeTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    String fomatTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return fomatTime;
    }
    return now.year == sent.year
        ? '$fomatTime-${sent.day}-${_getMoth(sent)}'
        : '$fomatTime-${sent.day}-${_getMoth(sent)} ${sent.year}';
  }

  //get last meeage time in user card
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return showYear
        ? '${sent.day} ${_getMoth(sent)} ${sent.year}'
        : '${sent.day} ${_getMoth(sent)}';
  }

// get month name from month no. or index
  static String _getMoth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Fed';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  // get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    // if time is not avilable then return below statament
    if (i == -1) return 'Last seen not avalable';
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    final DateTime now = DateTime.now();

    String fomatTime = TimeOfDay.fromDateTime(time).format(context);
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return 'Last seen today at $fomatTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $fomatTime';
    }

    String month = _getMoth(time);
    return 'last seen on ${time.day} $month on $fomatTime';
  }
}
