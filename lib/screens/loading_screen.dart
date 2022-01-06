import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahayak/constants.dart';
import 'package:sahayak/screens/add_task_screen.dart';
import 'package:sahayak/screens/login_screen.dart';
import 'package:sahayak/widgets/bottom_container.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      print(_selectedIndex);
      _selectedIndex = index;
      AddTaskScreen(_selectedIndex);
    });
  }

  void signOut() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    _firestore.collection('userDetails').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var data = result.data();
        if (data["uid"].toString() == uid.toString()) {
          _firestore
              .collection('userDetails')
              .doc(result.id)
              .update({"login": false});
        }
      });
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          showModalBottomSheet(
            
            backgroundColor: Color(0xff212121),
            context: context,
            builder: (context) => AddTaskScreen(_selectedIndex),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    // mainAxisAlignment: MainA,
                    children: [
                      Column(
                        children:[
                          GestureDetector(
                            onTap: signOut,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20.0,
                              child: Icon(
                                Icons.list,
                                color: Colors.lightBlueAccent,
                                size: 30.0,
                              ),
                            ),
                          ),
                          const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                      const Center(
                        child: Text(
                          'To Do\'s List',
                          style: kTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          widgetTask(_selectedIndex),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color(0xff30a3f4),
            primaryColorDark: Color(0xffa943dc)),
        child: BottomNavigationBar(
          // backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Daily',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.business,
                color: Colors.white,
              ),
              label: 'Weekly',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.school,
                color: Colors.white,
              ),
              label: 'Dates',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xe0ef, fontFamily: 'MaterialIcons'),
                color: Colors.white,
              ),
              label: 'Ideas',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.lightGreenAccent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
