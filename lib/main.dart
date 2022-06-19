import 'package:flutter/material.dart';
import 'package:uwuchat/helper/authenticate.dart';
import 'package:uwuchat/helper/helperfunctions.dart';
import 'package:uwuchat/views/char_room_screen.dart';
import 'package:uwuchat/views/sign_up.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool? userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.orangeAccent,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home:  userIsLoggedIn! ? ChatRoom() : Authenticate(),
    );
  }
}

