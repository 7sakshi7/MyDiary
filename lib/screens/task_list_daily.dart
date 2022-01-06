import 'package:flutter/material.dart';
import 'package:sahayak/models/firebase_stream_data.dart';

class TaskListDaily extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamData('dailyTask');
  }
}
