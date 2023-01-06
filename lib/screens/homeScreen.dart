import 'package:chatapp/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Modals/modal.dart';
import 'chatscreen.dart';

class MyApp extends StatelessWidget {
  final UserModel user;
  const MyApp({super.key, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(

      appBar: AppBar(
      title: Text("WhatsCord"),
        centerTitle: true,

      ),
      body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('messages').snapshots(),
      builder: (context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
      if(snapshot.data.docs.length < 1){
      return Center(
      child: Text("No Chats Available !"),
      );
      }
      return ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder: (context,index){
      var friendId = snapshot.data.docs[index].id;
      var lastMsg = snapshot.data.docs[index]['last_msg'];
      return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
      builder: (context,AsyncSnapshot asyncSnapshot){
      if(asyncSnapshot.hasData){
      var friend = asyncSnapshot.data;
      return ListTile(
      leading: ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: (
      Image.network(friend['image'])
      ),
      ),
      title: Text(friend['name']),
      subtitle: Container(
      child: Text("$lastMsg",style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,),
      ),
      onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
      currentUser: user,
      friendId: friend['uid'],
      friendName: friend['name'],
      friendImage: friend['image'])));
      },
      );
      }
      return LinearProgressIndicator();
      },

      );
      });
      }
      return Center(child: CircularProgressIndicator(),);
      }),

      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.search),
      onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(user:user,)));
      },
      ),

      ),
    );
  }
}

