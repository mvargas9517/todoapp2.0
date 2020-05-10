import 'package:flutter/material.dart';
import 'todoui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'Todo',
     debugShowCheckedModeBanner: false,
     theme: ThemeData.dark().copyWith(
       accentColor: Colors.purple
     ),
     home: Todoui(),
    );
  }
}


