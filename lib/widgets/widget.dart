import 'package:flutter/material.dart';
import 'package:uwuchat/constants/app_colors.dart';
import 'package:uwuchat/helper/constants.dart';

PreferredSizeWidget appBarMain(BuildContext context){
  return AppBar(
    title: Text("UwU chat"),
    backgroundColor: appBarColor,
  );
}

PreferredSizeWidget appBarLoggedIn(BuildContext context){
  return AppBar(
    title: Text(Constants.myName),
    backgroundColor: appBarColor,
  );
}

PreferredSizeWidget appBarInConversation(BuildContext context,String whoYouTalkingWith){
  return AppBar(
    title: Text(whoYouTalkingWith),
    backgroundColor: appBarColor,
  );
}

Widget loadingWidget(BuildContext context){
  return Container(
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.deepOrangeAccent,
        ),
      )
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 16
  );
}

TextStyle clickableTextStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 20
  );
}