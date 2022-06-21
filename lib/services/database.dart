import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uwuchat/helper/constants.dart';

class DataBaseMethods{

  getUserByUserName(String username) async{
    return await FirebaseFirestore.instance.collection("users")
        .where("name", isEqualTo: username ).get();
  }

  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: userEmail ).get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users")
        .add(userMap).catchError((e){
      print(e);
    });
  }

  createChatRoom(String chatroomId, charRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatroomId).set(charRoomMap).catchError((e) {print(e);});
  }

  updateChatRoom(String chatroomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatroomId).update(chatRoomMap).catchError((e) {print(e);});
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .add(messageMap).catchError((e){print(e);});
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .orderBy("time", descending: true)
        .limit(Constants.numberOfMessagesToShow)
        .snapshots();
  }

  getChatRooms(String userEmail) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users", arrayContains: userEmail).snapshots();
  }
}