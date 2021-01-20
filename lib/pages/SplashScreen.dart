import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/auth.dart';
import 'package:myshop/helpers/user.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
      checkUserAuth();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void checkUserAuth() async {
    final auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User user) {
      if (user != null) {
        // Navigator.pushReplacementNamed(context, "/home");
        getUserData().then((u) {
          final bool isAdmin = u.data()["isAdmin"];

          if (isAdmin == true) {
            Navigator.pushReplacementNamed(context, "/admin");
          } else {
            Navigator.pushReplacementNamed(context, "/home");
          }
        }).catchError((e) {
          print(e);
        });
      } else {
        // user is signed out
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Scaffold(
        body: Center(
          child: Text("Please try again later..."),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(64),
              child: Image(
                image: AssetImage("assets/icon_alt.png"),
                width: 256,
                height: 256,
              ),
            ),
            if (_initialized) ...[
              FutureBuilder(
                future: Future.delayed(
                  Duration(
                    seconds: 2,
                  ),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        try {
                          final u = await signInWithGoogle();
                          // print(u);

                          final FirebaseFirestore firestore =
                              FirebaseFirestore.instance;

                          User user = u.user;

                          firestore.collection("users").doc(user.uid).set({
                            "displayName": user.displayName,
                            "email": user.email,
                            "photoURL": user.photoURL,
                            "uid": user.uid,
                          }, SetOptions(merge: true));
                        } catch (e) {
                          print(e);
                        }
                      },
                    );
                  }
                  return SpinKitChasingDots(
                    color: primaryColor,
                    size: 50,
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
