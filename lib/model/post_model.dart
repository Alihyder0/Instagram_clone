import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String desc;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post(
      {required this.datePublished,
      required this.desc,
      required this.likes,
      required this.postId,
      required this.postUrl,
      required this.profImage,
      required this.uid,
      required this.username});

  Map<String, dynamic> toJson() => {
        'desc': desc,
        'datePublished': datePublished,
        'likes': likes,
        'postId': postId,
        'postUrl': postUrl,
        'profImage': profImage,
        'uid': uid,
        'username': username
      };

  static Post snapOfPost(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Post(
        datePublished: snap['datePublished'],
        desc: snap['desc'],
        likes: snap['likes'],
        postId: snap['postId'],
        postUrl: snap['postUrl'],
        profImage: snap['profImage'],
        uid: snap['uid'],
        username: snap['username']);
  }
}
