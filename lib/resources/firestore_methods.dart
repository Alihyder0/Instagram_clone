import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/post_model.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String desc, Uint8List file, String uid,
      String username, String profImage) async {
    String res = 'Error Occured from uploadPost';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = Uuid().v1();

      Post post = Post(
          desc: desc,
          uid: uid,
          postId: postId,
          username: username,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid,List likes) async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else{
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> commentToPost(String postId,String uid, String text,String name,String profilePic )async{
    try{
      if(text.isNotEmpty){
        String commentId = Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'name':name,
          'uid':uid,
          'commentId':commentId,
          'text' : text,
          'datePublished': DateTime.now(),
        });
      }
      else{
        print('Text is empty');
      }
    } catch (e) {
      print(toString());
    }

  }

  //delete Post
  Future<void> deletePost(String postId)async{
    
    try{
      await _firestore.collection('posts').doc(postId).delete();
    } catch(e){
      print(e.toString());
    }

  }

  Future<void> followUser(
    String uid,
    String followId
  ) async{

    try{  
      DocumentSnapshot<Map<String,dynamic>> snapshot = await _firestore.collection('users').doc(uid).get();
      List following = snapshot.data()!['following'];

      if(following.contains(followId)){
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
        
      } else {
        await _firestore.collection('users').doc(followId).update({
          'follower': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }


    } catch (e){

    }
  }
}
