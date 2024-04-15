import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/util/pallete.dart';
import 'package:instagram_clone/util/utils.dart';
import 'package:instagram_clone/widget/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userdata = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isloading = true;
    });
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      userdata = userSnapshot.data()!;
      postLen = postSnap.docs.length;
      followers = userSnapshot.data()!['follower'].length;
      following = userSnapshot.data()!['following'].length;
      isFollowing = userSnapshot
          .data()!['follower']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userdata['username']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userdata['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, 'Post'),
                                    buildStatColumn(followers, 'follower'),
                                    buildStatColumn(following, 'following')
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        backgroundColor: mobileBackgroundColor,
                                        borderColor: Colors.grey,
                                        text: 'Sign Out',
                                        textcolor: primaryColor,
                                        function: () async{
                                          await AuthMethods().signOut();
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const LoginScreen()));
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            backgroundColor: Colors.white,
                                            borderColor: Colors.grey,
                                            text: 'Unfollow',
                                            textcolor: Colors.black,
                                            function: ()async {
                                             await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userdata['uid']);
                                             setState(() {
                                              isFollowing = false;
                                               following--;
                                             });
                                            },
                                          )
                                        : FollowButton(
                                            backgroundColor: Colors.blue,
                                            borderColor: Colors.blue,
                                            text: 'follow',
                                            textcolor: Colors.white,
                                            function: () async{
                                              await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userdata['uid']);
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          )
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userdata['username'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userdata['bio'],
                          style: TextStyle(),
                        ),
                      ),
                      Divider(),
                      FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('posts')
                              .where('uid', isEqualTo: widget.uid)
                              .get(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 1.5,childAspectRatio: 1),

                              
                               itemBuilder: (context,index){
                                DocumentSnapshot snap = snapshot.data!.docs[index];

                                return Container(
                                  child: Image.network(snap['postUrl'] ),
                                );
                               });
                          })
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
