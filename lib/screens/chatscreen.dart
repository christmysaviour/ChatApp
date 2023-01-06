import 'package:chatapp/Modals/modal.dart';
import 'package:chatapp/Widgets/message_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Widgets/single_message.dart';
class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key, required this.currentUser, required this.friendId, required this.friendName, required this.friendImage}) : super(key: key);
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
           height: 100,
           width: 45,
           decoration: BoxDecoration(
           shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(friendImage),
          ),
            ),
            ),
            const SizedBox(width: 10),
            Text(friendName,style:const TextStyle(fontSize: 20) ,)
          ],
        ),
      ),
      body: Column(

        children: [
          Expanded(child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)
              )
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(currentUser.uid).collection('messages').doc(friendId).collection('chats').orderBy("date",descending: true).snapshots(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data.docs.length < 1){
                      return Center(
                        child: Text("Say Hi"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          bool isMe = snapshot.data.docs[index]['senderId'] == currentUser.uid;
                          return SingleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe);
                        });
                  }
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }),
          )),
          MessageText(currentId: currentUser.uid, friendId: friendId)
        ],
      ),
    );
  }
}
