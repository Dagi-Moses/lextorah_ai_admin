import 'package:intl/intl.dart';

String formatTimestamp(int timestamp) {
  final now = DateTime.now();
  final fileDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final difference = fileDate.difference(now);

  if (difference.inDays == 0) {
    return "Today";
  } else if (difference.inDays == 1) {
    return "Tomorrow";
  } else if (difference.inDays < 7) {
    return DateFormat('EEEE').format(fileDate); // Day of the week
  } else {
    return DateFormat('dd/MM/yyyy').format(fileDate); // Full date
  }
}
