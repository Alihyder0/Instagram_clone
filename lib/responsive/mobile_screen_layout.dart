import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/model/user_model.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {


  @override
  Widget build(BuildContext context) {
   model.User? user = Provider.of<UserProvider>(context).getUser;
    return user == null ? Center(child: CircularProgressIndicator(),) : Scaffold(
      body: Center(child: Text(user.username)),
    );
  }
}
