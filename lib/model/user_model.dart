import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String username;
  final String photoUrl;
  final String uid;
  final String bio;
  final List follower;
  final List following;

  User(
      {required this.username,
      required this.email,
      required this.bio,
      required this.follower,
      required this.following,
      required this.photoUrl,
      required this.uid});

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "bio": bio,
        "follower": follower,
        "following": following,
        "photoUrl": photoUrl,
        "uid": uid
      };

  static User fromSnap(DocumentSnapshot snap) {


    var snapshot = snap.data() as Map<String, dynamic>;

    print("Fetched User Data:");
  print('This data i am getting $snapshot');

    return User(
        username: snapshot["username"],
        email: snapshot["email"],
        bio: snapshot["bio"],
        follower: snapshot["follower"],
        following: snapshot["following"],
        photoUrl: snapshot["photoUrl"],
        uid: snapshot["uid"]
        );
  }
}
