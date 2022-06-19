import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwuchat/constants/app_colors.dart';
import 'package:uwuchat/helper/authenticate.dart';
import 'package:uwuchat/helper/constants.dart';
import 'package:uwuchat/helper/helperfunctions.dart';
import 'package:uwuchat/services/auth.dart';
import 'package:uwuchat/services/database.dart';
import 'package:uwuchat/views/char_room_screen.dart';
import 'package:uwuchat/views/conversation_screen.dart';
import 'package:uwuchat/views/search.dart';
import 'package:uwuchat/views/sign_in.dart';
import 'package:uwuchat/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  late final Stream<QuerySnapshot> chatRoomsStream;

  Widget chatRoomList(){
    String myChatroomId =  Constants.myName+"_"+Constants.myName;
    try {
      return StreamBuilder<QuerySnapshot>(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return loadingWidget(context);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget(context);
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<
                  String,
                  dynamic>;
              if(data['chatroomid'].toString() == myChatroomId) {
                return ChatRoomTile(
                    "Just You",
                    data['chatroomid'],
                );
              }
              else{
                return ChatRoomTile(
                    data['chatroomid'].toString()
                        .replaceAll("_", "")
                        .replaceAll(
                        Constants.myName, ""),
                    data['chatroomid'],
                );
              }
            }).toList(),
          );
        },
      );
    }catch(e){return loadingWidget(context);}
  }

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    dataBaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.myName),
        backgroundColor: appBarColor,
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        splashColor: Colors.deepOrangeAccent,
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text(userName.substring(0,1),style: simpleTextStyle(),),
            ),
            SizedBox(width: 10,),
            Text(userName,style: simpleTextStyle())
          ],
        ),
      ),
    );
  }
}

