import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:konsul/main.dart';
import 'package:konsul/user.dart';

class RootPage extends StatelessWidget {
  RootPage({Key key, this.email}) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();

          var users = snapshot.data.documents.toList();

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: users.map((userSnapshot) {
              var user = User.fromDocumentSnapshot(userSnapshot);

              return user.type == 'dosen'
                  ? HomePage(
                      title: 'Dosen',
                    )
                  : HomePage(
                      title: 'Mahasiswa',
                    );
            }).toList(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Ini halaman $title'),
          RaisedButton(
            onPressed: () => signOut().then((_) {
                  var route =
                      MaterialPageRoute(builder: (context) => LoginPage());
                  Navigator.of(context).push(route);
                }),
            child: Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }

  Future signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
