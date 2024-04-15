import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profiel_screen.dart';
import 'package:instagram_clone/util/pallete.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool toShowUsers = false;
  TextEditingController _searchcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    _searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            controller: _searchcontroller,
            decoration: InputDecoration(
              labelText: 'Search for User',
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                toShowUsers = true;
              });
            },
          ),
        ),
        body: toShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchcontroller.text)
                    .get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchcontroller.text).snapshots(),
                    builder: (context, snap) {
                      if(snap.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }


                      return ListView.builder(
                          itemCount: (snap.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: snap.data!.docs[index]['uid'])));
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: snap.data!.docs[index].data()
                                              .containsKey('photoUrl')
                                      ? NetworkImage(
                                          snap.data!.docs[index]['photoUrl'])
                                      : NetworkImage(
                                          'https://plus.unsplash.com/premium_photo-1711508489210-80940a5bf60a?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                                ),
                                title: Text(snap.data!.docs[index]['username']),
                              ),
                            );
                          });
                    }
                  );
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 3,
                    itemCount: snapshot.data!.docs.length,
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                    itemBuilder: (context, index) {
                      return Image.network(
                          snapshot.data!.docs[index]['postUrl']);
                    },
                  );
                }));
  }
}
