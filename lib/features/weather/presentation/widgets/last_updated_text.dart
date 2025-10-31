import 'package:flutter/material.dart';
import 'package:weather/shared/utils/time_ago_helper.dart';

class LastUpdatedText extends StatelessWidget {
  const LastUpdatedText({super.key, required this.timestamp});

  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final timeAgo = TimeAgoHelper.format(timestamp);

    return Text(
      'Last updated: $timeAgo',
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
      textAlign: TextAlign.center,
    );
  }
}
