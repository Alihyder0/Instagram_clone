import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/user_model.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<model.User> getUserDetails() async{
     User currentUser = _auth.currentUser!;

     DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();
     //this snapshot get uid

      //assigning to that this is an uid or etc;
      //called the Key of that value
     return model.User.fromSnap(snapshot);
     //and give it to this to get the value
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register user
        UserCredential usercredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(usercredential.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePics', file, false);

        model.User user = model.User(
                username: username,
                email: email,
                bio: bio,
                follower: [],
                following: [],
                password: password,
                photoUrl: photoUrl,
                uid: usercredential.user!.uid);

        //add user to our database

        _firestore.collection('users').doc(usercredential.user!.uid).set(
          user.toJson()
        );
        res = 'Success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
