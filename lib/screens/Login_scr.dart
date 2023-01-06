import 'package:chatapp/Modals/modal.dart';
import 'package:chatapp/screens/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late UserModel user;
  TextEditingController _controller = TextEditingController();
  List _name=[];


  Future onClick () async {

    await FirebaseFirestore.instance.collection('users').where("name",isEqualTo:_controller.text).get().then((value) =>{
      for (var user in value.docs) {
        _name.add(user.data())
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text('WhatsCord'),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    TextField(
                      controller:  _controller,
                      decoration: InputDecoration(
                        hintText: "Username",
                        fillColor: Colors.grey[100],
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0),
                          gapPadding: 10,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                   SizedBox(height: 20,),
                   Container(
                     height: 50,
                     width: double.maxFinite,
                     child: ElevatedButton(onPressed: () async {
                      await onClick();
                      // print(_name.last['name']);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp(user: UserModel(email: _name.last['email'], name: _name.last['name'], image: _name.last['image'], uid: _name.last['uid']),)));
                     }, child: Text("Enter")),
                   ),
              ],
              ),
            );
          }
        
      ),
    );
  }
}
