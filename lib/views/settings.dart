import 'package:flutter/material.dart';
import 'package:uwuchat/helper/authenticate.dart';
import 'package:uwuchat/services/auth.dart';
import 'package:uwuchat/views/char_room_screen.dart';
import 'package:uwuchat/widgets/widget.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  AuthMethods authMethods = AuthMethods();

  Widget LogOut(){
    return Container(
      child: GestureDetector(
        onTap: () {
          authMethods.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Authenticate()
          ));
        },
        child: Container(
          color: Colors.orange,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Text("log out", style: simpleTextStyle(),),
            ],
          ),
        ),
      ),
    );
  }

  Widget GoBack(){
    return Container(
      child: GestureDetector(
        onTap: () {
          authMethods.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        },
        child: Container(
          color: Colors.orange,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Icon(Icons.arrow_back,color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarInConversation(context, "Settings"),
      body: Container(
        child: Column(
            children: [
              SizedBox(height: 10,),
              GoBack(),
              SizedBox(height: 10,),
              LogOut(),
            ]
        ),
      ),
    );
  }
}
