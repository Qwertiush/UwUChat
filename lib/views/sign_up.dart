import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwuchat/helper/authenticate.dart';
import 'package:uwuchat/helper/helperfunctions.dart';
import 'package:uwuchat/services/auth.dart';
import 'package:uwuchat/services/database.dart';
import 'package:uwuchat/views/char_room_screen.dart';

import '../widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEdditingController = TextEditingController();
  TextEditingController emailTextEdditingController =TextEditingController();
  TextEditingController passwordTextEdditingController = TextEditingController();

  signMeUp() async{

    if(formKey.currentState!.validate()){

      Map<String, String> userInfoMap = {
        "name" : userNameTextEdditingController.text,
        "email" : emailTextEdditingController.text
      };

      HelperFunctions.saveUserNameSharedPreference(userNameTextEdditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEdditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEdditingController.text, passwordTextEdditingController.text)
      .then((value){
        print("${value.hashCode}");
        if(value != null) {
          dataBaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => Authenticate()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading ? loadingWidget(context) : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            validator: (val) {
return val!.isEmpty ? "be more imaginative" : null;
                            },
                            controller: userNameTextEdditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("username")
                        ),
                        TextFormField(
                            validator: (val) {
return RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
).hasMatch(val!) ? null : "Bad e-mail";
                            },
                            controller: emailTextEdditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email")
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
return val!.length > 6 ? null : "your password is WEAK (6 + characters)";
                          },
                            controller: passwordTextEdditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password")
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      child: Text("Forgot Password?",style: simpleTextStyle(),),
                    ),
                  ),
                  SizedBox(height: 8,),
                  GestureDetector(
                    onTap: () {
                      signMeUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xffe65100),
                                const Color(0xffffcc80)
                              ]
                          ),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign Up",style: clickableTextStyle(),),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xffffcc80),
                              const Color(0xffe65100)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign Up with Google",style: clickableTextStyle(),),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account?", style: clickableTextStyle(),),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Text("Sign in now", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            decoration: TextDecoration.underline
                        ),),
                      )
                    ],
                  ),
                  SizedBox(height: 100,),
                ],
              ),
            ),
          ),
        )
    );
  }
}
