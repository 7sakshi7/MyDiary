import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final Widget child;
  final int length;
  TextFieldWidget({required this.child,required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - length,
      height: 50,
      margin: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color(0xff22252c),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1d1f23),
            offset: Offset.fromDirection(30.0),
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
