import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sahayak/models/user_model.dart';
import 'package:sahayak/screens/verify_screen.dart';
import 'package:sahayak/screens/login_screen.dart';
import 'package:sahayak/widgets/textfield.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool selected = false;

  // editing Controller
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  // CALLING FIREBASE
  final _auth = FirebaseAuth.instance;

  void signup(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      final credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetails()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        print(e!.message);
      });
    }
  }

  postDetails() async {
    print('Inside post details');

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(
            builder: (context) => VerifyScreen(
                  username: usernameController.text,
                )),
        (route) => false);

    // Fluttertoast.showToast(
    //     msg:
    //         'Verification mail has been sent to the mail. Click to verify Your mail. The link is valid for 10 minutes only .');
    // // calling firestore
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // User? user = _auth.currentUser;

    // try {
    //   await user?.sendEmailVerification();
    //   return user?.uid;
    // } catch (e) {
    //   Fluttertoast.showToast(
    //       msg: "An error occured while trying to send email verification");
    // }
    // print('email verified');

    // // calling user model
    // UserModel userModel = UserModel();

    // // writing all the values
    // userModel.email = user!.email;
    // userModel.uid = user.uid;
    // userModel.username = usernameController.text;

    // // waiting for mail verification
    // await user.emailVerified;
    // // sending these values
    // await _auth.currentUser?.reload();

    // print(user.emailVerified);
    // if (user.emailVerified) {
    //   await firebaseFirestore
    //       .collection('userDetails')
    //       .doc(user.uid)
    //       .set(userModel.toMap());
    //   Fluttertoast.showToast(msg: "Account Created Successfully");

    //   context.watch<UserAuthentication>().userEmailVerified();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: width - (width / 8),
              height: height - (height / 6),
              decoration: BoxDecoration(
                  color: Color(0xff171717),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      // spreadRadius: 2.0,
                      blurRadius: 4.0,
                      blurStyle: BlurStyle.outer,
                    )
                  ]),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ---------------------------Username Text Field-------------------------
                    TextFieldWidget(
                      length: 100,
                      child: TextFormField(
                        autofocus: false,
                        controller: usernameController,
                        onSaved: (value) {
                          usernameController.text = value.toString();
                        },
                        style: TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hoverColor: Color(0xffb916d8),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),

                    // ---------------------------Email Text Field-------------------------
                    TextFieldWidget(
                      length: 100,
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
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),

                    // ---------------------------Password Text Field-------------------------
                    TextFieldWidget(
                      length: 100,
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
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        signup(emailController.text, passwordController.text);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 20.0),
                        decoration: BoxDecoration(
                          // color: Color(0xFF181F29),
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
                        // padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                ),
                                textAlign: TextAlign.center),
                            Icon(
                              Icons.arrow_right_alt_outlined,
                              color: Colors.white,
                              size: 30.0,
                            )
                          ],
                        ),
                      ),
                    ),
                    // --------------------------Links----------------------------------------
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Already Have An Account?',
                        style: TextStyle(
                          color: Colors.grey,
                          // color: Color(0xffa664f7),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
