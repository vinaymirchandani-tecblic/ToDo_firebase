import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/auth/authscreen.dart';
import 'package:todo_list/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),

    //       By passing this Stream object to the StreamBuilder widget, the widget subscribes to the stream
    //       and rebuilds its child widget whenever a new event is emitted by the stream. In this case, the
    //       child widget is either a Home widget (if the user is signed in) or an AuthScreen widget
    // (if the user is signed out).


    builder: (context, usersnapshot){
        if(usersnapshot.hasData){
          return Home();
        } else{
          return AuthScreen();

        }
      },),
      theme: ThemeData(
        brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple
          ),),
    );
  }
}
