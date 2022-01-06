import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahayak/models/task.dart';

class StreamData extends StatefulWidget {
  String collectionName = 'dailyTask';
  StreamData(this.collectionName);

  @override
  State<StreamData> createState() => _StreamDataState();
}

class _StreamDataState extends State<StreamData> {
  final _auth = FirebaseAuth.instance;
  bool called = false;

  List<String> doc = [];

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

  void userState() async {
    doc = await getCurrentUserEmail();
    called = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    if (!called) userState();

    return called == false
        ? Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection(doc[0])
                .doc(doc[1])
                .collection(widget.collectionName)
                .snapshots(),
            builder: (context, snapshot) {
              List<Task> mylist = [];
              print(snapshot.hasData);
              if (snapshot.hasData == false) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final tasks = snapshot.data?.docs;

              for (var task in tasks!) {
                final text = task["text"];
                final date = task["date"];
                final check = task["checked"];
                // print(
                // '******************** for $text ${check.runtimeType}*******************');
                final done = Task(text: text, checked: check, date: date);
                mylist.add(done);
              }
              return mylist.length == 0
                  ? Center(
                      child: Text(
                        'Nothing to show',
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, int index) {
                        return ListTile(
                            trailing: Checkbox(
                              onChanged: (value) {
                                final tasks = snapshot.data?.docs;
                                for (var task in tasks!) {
                                  if (task["text"] == mylist[index].text) {
                                    var isChecked = mylist[index].checked;
                                    var text = mylist[index].text;
                                    var date = mylist[index].date;
                                    // print(
                                    //     'value is $value and ischecked is $isChecked');
                                    _firestore
                                        .collection(doc[0])
                                        .doc(doc[1])
                                        .collection(widget.collectionName)
                                        .doc(task.id)
                                        .delete();

                                    _firestore
                                        .collection(doc[0])
                                        .doc(doc[1])
                                        .collection(widget.collectionName)
                                        .add({
                                      'text': text,
                                      'checked': !isChecked,
                                      'date': date
                                    });
                                    print('heloo ${task.id}');
                                  }
                                }
                              },
                              value: mylist[index].checked,
                            ),
                            title: Text(
                              mylist[index].text,
                              style: TextStyle(
                                  decoration: mylist[index].checked
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              '${mylist[index].date}',
                              style: TextStyle(color: Colors.grey.shade100),
                            ),
                            onLongPress: () => {
                                  for (var task in tasks)
                                    {
                                      if (task["text"] == mylist[index].text)
                                        {
                                          _firestore
                                              .collection(doc[0])
                                              .doc(doc[1])
                                              .collection(widget.collectionName)
                                              .doc(task.id)
                                              .delete()
                                        }
                                    }
                                });
                      },
                      itemCount: mylist.length);
            });
  }
}
