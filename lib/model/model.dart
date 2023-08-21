import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  final String uid;
  final String firstName;
  final String email;
  final String password;

  Users(
      {required this.password,
      required this.uid,
      required this.firstName,
      required this.email});
}

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<Users?> registerWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;

      if (user != null) {
        await _userCollection.doc(user.uid).set({
          'firstName': firstName,
          'password': password,
          'email': email,
        });

        return Users(
            uid: user.uid,
            firstName: firstName,
            email: email,
            password: password);
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future<Users?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;

      if (user != null) {
        DocumentSnapshot userSnapshot =
            await _userCollection.doc(user.uid).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          return Users(
            password: password,
            uid: user.uid,
            firstName: userData['firstName'],
            email: userData['email'],
          );
        }
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}
