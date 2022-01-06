import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sahayak/screens/home_screen.dart';
import 'package:sahayak/screens/loading_screen.dart';
import 'package:sahayak/screens/verify_screen.dart';
import 'package:sahayak/screens/signup_screen.dart';
import 'package:sahayak/widgets/textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  bool selected = false;
  // editing Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // CALLING FIREBASE
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // checking login
    void checkLogin(uid) {
      // _firestore
      //     .collection('userDetails')
      //     .doc(email)
      //     .update({"login": true});
      _firestore.collection('userDetails').get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.id);
          var data = result.data();
          if (data["uid"].toString() == uid.toString()) {
            print('entered');
            _firestore
                .collection('userDetails')
                .doc(result.id)
                .update({"login": true});
            print(data["login"]);
            return;
          }
        });
      });
    }

    // login function
    void login(String email, String password) async {
      if (_formKey.currentState!.validate()) {
        print('inside login function');
        if (!_auth.currentUser!.emailVerified) {
          if (_auth.currentUser != null) {
            _auth.currentUser?.delete();
          }
          print('email is not verified');
          Fluttertoast.showToast(
              msg:
                  "Email is not verfied.. Check your mail and verify email first");
          emailController.text = "";
          passwordController.text = "";
          return;
        }

        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
              (uid) => {
                print(uid),
                print(uid.user?.uid),
                Fluttertoast.showToast(msg: "Login Successful"),
                checkLogin(uid.user?.uid),
                Navigator.pushReplacement((context),
                    MaterialPageRoute(builder: (context) => LoadingScreen()))
              },
            )
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
          print(e!.message);
          emailController.text = "";
          passwordController.text = "";
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Column(
                children: [
                  // =========================Title Of our Project =========================
                  Stack(
                    children: [
                      Container(
                        child: ClipPath(
                          clipper: MyWaveClipper(),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF171717),
                            ),
                            width: 900,
                            height: 300,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.list_alt,
                                color: Colors.white,
                                size: 100.0,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "My Diary",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  //============================ textFields ================================

                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ---------------------------Email Text Field-------------------------
                        TextFieldWidget(
                          length: 50,
                          child: TextFormField(
                            autofocus: false,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == "") {
                                return ("Please Enter Your Email");
                              }
                              var pattern =
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?)*$";
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(value.toString())) {
                                return ("Enter Valid Email");
                              } else
                                return null;
                            },
                            onSaved: (value) {
                              emailController.text = value.toString();
                            },
                            style: TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.grey,
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),

                        // ---------------------------Password Text Field-------------------------
                        TextFieldWidget(
                          length: 50,
                          child: TextFormField(
                            autofocus: false,
                            obscureText: true,
                            controller: passwordController,
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == "") {
                                return ("password is required");
                              }

                              if (!RegExp('(?=.*?[#?!@\$%^&*-])')
                                  .hasMatch(value.toString())) {
                                return ("passwords must have at least one special character");
                              } else
                                return null;
                            },
                            onSaved: (value) {
                              passwordController.text = value.toString();
                            },
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.grey,
                              ),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 15, 20, 15),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 130.0,
                            ),
                            GestureDetector(
                              child: const Text(
                                'Forgot Password ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  // color: Color(0xff4facfe),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ---------------------------Login Button---------------------------------
                        GestureDetector(
                          onTap: () {
                            print('caleed');
                            login(
                                emailController.text, passwordController.text);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF181F29),
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xffb816dc),
                                  Color(0xffce23b1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            width: 200,
                            height: 50,
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text('Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                ),
                                textAlign: TextAlign.center),
                          ),
                        ),

                        // --------------------------Links----------------------------------------
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
                            );
                          },
                          child: const Text(
                            'Don\'t have account?',
                            style: TextStyle(
                              color: Colors.grey,
                              // color: Color(0xffa664f7),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width - 10, size.height - 170);
    path.quadraticBezierTo(
        size.width, size.height - 175, size.width, size.height - 180);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
