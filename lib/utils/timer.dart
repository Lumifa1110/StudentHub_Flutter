String f_timeSinceCreated(String createdAt) {
  DateTime timeParse = DateTime.parse(createdAt);
  DateTime now = DateTime.now();
  Duration difference = now.difference(timeParse);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}mn ago';
  } else if (difference.inDays == 0) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inDays} days ago';
  }
}
