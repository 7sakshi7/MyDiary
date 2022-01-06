import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sahayak/models/firebase_stream_data.dart';
import 'package:sahayak/screens/project_ideas.dart';
import 'package:sahayak/screens/task_list_daily.dart';
// import 'package:to_do_list/widgets/task_list.dart';

List<Expanded> _widgetOptions = [
  Expanded(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Color(0xff212121),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: StreamData('dailyTask'),
    ),
  ),
  Expanded(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Color(0xff212121),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: StreamData('weeklyTask'),
    ),
  ),
  Expanded(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Color(0xff212121),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: StreamData('dateTask'),
    ),
  ),
  Expanded(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Color(0xff212121),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: ProjectIdeas(),
    ),
  ),
];

Expanded widgetTask(selectedIndex) {
  // future:
  // Firebase.initializeApp();
  return _widgetOptions[selectedIndex];
}
