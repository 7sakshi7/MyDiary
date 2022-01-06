import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sahayak/models/task.dart';

class ProjectIdeas extends StatefulWidget {
  @override
  State<ProjectIdeas> createState() => _ProjectIdeasState();
}

class _ProjectIdeasState extends State<ProjectIdeas> {
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
                .collection('projectIdeas')
                .snapshots(),
            builder: (context, snapshot) {
              List<Task> mylist = [];
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final list = snapshot.data?.docs;
              for (var listData in list!) {
                String text = listData["text"];
                String desc = listData["date"];
                bool check = listData["checked"];
                mylist.add(Task(text: text, checked: check, date: desc));
              }

              return ListView.builder(
                itemBuilder: (context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Color(0xff2b2d32),
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListTile(
                              // tileColor: Colors.grey.shade800,
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
                                          .collection('projectIdeas')
                                          .doc(task.id)
                                          .delete();

                                      _firestore
                                          .collection(doc[0])
                                          .doc(doc[1])
                                          .collection('projectIdeas')
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
                                    for (var task in list)
                                      {
                                        if (task["text"] == mylist[index].text)
                                          {
                                            _firestore
                                                .collection('projectIdeas')
                                                .doc(task.id)
                                                .delete()
                                          }
                                      }
                                  }),
                        )),
                  );
                },
                itemCount: mylist.length,
              );
            },
          );
  }
}
