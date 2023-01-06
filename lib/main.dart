import 'package:chatapp/Modals/modal.dart';
import 'package:chatapp/screens/Login_scr.dart';
import 'package:chatapp/screens/chatscreen.dart';
import 'package:chatapp/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( Login());
}

