import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahayak/screens/home_screen.dart';
import 'package:sahayak/screens/loading_screen.dart';
import 'package:sahayak/screens/login_screen.dart';
import 'package:sahayak/screens/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isloggedIn = false;
  int notFound = 0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    _firestore.collection('userDetails').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var data = result.data();
        if (data["uid"].toString() == uid.toString() && data["login"] == true) {
          setState(() {
            isloggedIn = true;
          });
        }
      });
    });

    setState(() {
      notFound = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff07080d)),
      // theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color.fromARGB(61, 0, 0, 0),),
      home: notFound == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isloggedIn
              ? LoadingScreen()
              : LoginScreen(),
      // ),
    );
  }
}
