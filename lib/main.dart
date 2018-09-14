import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:konsul/root_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            _testSignInWithGoogle().then((email) {
              var route = MaterialPageRoute(
                  builder: (context) => RootPage(email: email));
              Navigator.of(context).push(route);
            });
          },
          child: Text('LOGIN'),
        ),
      ),
    );
  }

  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user.email;
  }
}
