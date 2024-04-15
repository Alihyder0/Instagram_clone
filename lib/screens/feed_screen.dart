import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/util/pallete.dart';
import 'package:instagram_clone/widget/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: Colors.white,
            height: 32,
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.messenger_outline))
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child:  CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                return PostCard(snap: snapshot.data!.docs[index].data(),);
              });
            }));
  }
}
