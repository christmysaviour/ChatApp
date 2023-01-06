
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String email;
  String name;
  String image;
  String uid;

  UserModel({
    required this.email,
    required this.name,
    required this.image,
    required this.uid
  });
  factory UserModel.fromJson(snapshot){
    return UserModel(
      email: snapshot['email'],
      image: snapshot['image'],
      name: snapshot['name'],
      uid: snapshot['uid'],
    );
  }


}