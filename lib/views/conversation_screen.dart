import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwuchat/helper/constants.dart';
import 'package:uwuchat/services/database.dart';
import 'package:uwuchat/views/conversation_screen.dart';
import 'package:uwuchat/views/search.dart';
import 'package:uwuchat/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController messageTextEditingController = TextEditingController();

  late final Stream<QuerySnapshot> chatMessageStream;

  Widget ChatMessageList(){
    try {
      return StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrangeAccent,
                  ),
                )
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrangeAccent,
                  ),
                )
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<
                  String,
                  dynamic>;
              return SingleChildScrollView(
                child: MessageTile(
                    data['message'], data['sendBy'] == Constants.myName),
              );
            }).toList(),
          );
        },
      );
    }catch(e){return loadingWidget(context);}
  }

  sendMessage(){

    if(messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message" : messageTextEditingController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };

      dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState(){
    dataBaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String whoYouTalkingWith = "";
    String myChatroomId =  Constants.myName+"_"+Constants.myName;
    if(widget.chatRoomId == myChatroomId){
      whoYouTalkingWith = "Just You";
    }else{
      whoYouTalkingWith = widget.chatRoomId.replaceAll("_", "").replaceAll(Constants.myName, "");
    }
    return Scaffold(
      appBar: appBarInConversation(context, whoYouTalkingWith),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageTextEditingController,
                          decoration: textFieldInputDecoration("Message..."),
                          style: clickableTextStyle(),
                        )
                    ),
                    GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Icon(Icons.send, color: Colors.white,)
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message,this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe ?[
                const Color(0xffe65100),
                const Color(0xffffcc80)
              ]
                : [
                const Color(0xffffcc80),
                const Color(0xffe65100)
              ]
          ),
          borderRadius: isSendByMe ? 
            BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)
            ) : BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25)
          )
        ),
        child: Text(message,style: simpleTextStyle()),
      ),
    );
  }
}

