import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uwuchat/helper/helperfunctions.dart';
import 'package:uwuchat/modul/customUser.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomUser? _userFromFirebaseUser(User user){
    return user != null ? CustomUser(userId: user.uid): null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser!);

    }catch(e){
      print("Sum Ting Wong with a SingingIn");
      return null;
    }
    return 0;
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = result.user;

      return _userFromFirebaseUser(firebaseUser!);

    }catch(e,stacktrace){
      print(e);
      print(stacktrace);
    }
  }

  Future resetPass(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      return await _auth.signOut();
    }catch(e){
      print(e);
    }
  }
}