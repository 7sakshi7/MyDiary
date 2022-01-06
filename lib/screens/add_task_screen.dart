import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  int index = 0;
  AddTaskScreen(this.index);
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _nameController = new TextEditingController();
  final _dateController = new TextEditingController();
  String _task = '';
  String _date = '';

  Future<List<String>> getCurrentUserEmail() async {
    String email = '', uid = '';
    if (_auth.currentUser != null) {
      var currEmail = _auth.currentUser?.email.toString();
      var currUid = _auth.currentUser?.uid.toString();
      email = currEmail.toString();
      uid = currUid.toString();
    }

    return [email, uid];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color(0xff757575),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.grey.shade800,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Color(0xff212121),
        ),
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ADD TEXT',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.lightBlueAccent),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              autofocus: true,
              controller: _nameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(),
              onChanged: (value) {
                // print('$value');
                _task = value;
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              autofocus: true,
              controller: _dateController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter any Description or Add time to do it.',
                hintStyle: TextStyle(color: Colors.white),
              ),
              onChanged: (value) {
                // print('$value');
                _date = value;
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            FlatButton(
              onPressed: () async {
                print('$_task');
                List<String> doc = await getCurrentUserEmail();
                if (widget.index == 0) {
                  _firestore
                      .collection(doc[0])
                      .doc(doc[1])
                      .collection('dailyTask')
                      .add({'text': _task, 'date': _date, 'checked': false});

                  Navigator.pop(context);
                } else if (widget.index == 1) {
                  _firestore
                      .collection(doc[0])
                      .doc(doc[1])
                      .collection('weeklyTask')
                      .add({'text': _task, 'date': _date, 'checked': false});

                  Navigator.pop(context);
                } else if (widget.index == 2) {
                  _firestore
                      .collection(doc[0])
                      .doc(doc[1])
                      .collection('dateTask')
                      .add({'text': _task, 'date': _date, 'checked': false});
                  Navigator.pop(context);
                } else {
                  _firestore
                      .collection(doc[0])
                      .doc(doc[1])
                      .collection('projectIdeas')
                      .add({'text': _task, 'date': _date, 'checked': false});
                  Navigator.pop(context);
                }
                // _nameController.clear();
              },
              color: Colors.lightBlueAccent,
              child: Text(
                'ADD',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
