import 'package:flutter/material.dart';

class Task {
  String text = '';
  bool checked = false;
  String date = '';

  Task({required this.text, required this.checked, required this.date});

  void toggle() {
    checked = !checked;
  }
}
