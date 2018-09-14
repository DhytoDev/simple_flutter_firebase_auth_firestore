import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email, name, type;

  User({this.email, this.name, this.type});

  User.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    email = snapshot['email'];
    name = snapshot['name'];
    type = snapshot['type'];
  }
}
