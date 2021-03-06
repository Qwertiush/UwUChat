import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwuchat/constants/app_colors.dart';
import 'package:uwuchat/helper/authenticate.dart';
import 'package:uwuchat/helper/constants.dart';
import 'package:uwuchat/helper/helperfunctions.dart';
import 'package:uwuchat/notifications/notification_api.dart';
import 'package:uwuchat/services/auth.dart';
import 'package:uwuchat/services/database.dart';
import 'package:uwuchat/views/char_room_screen.dart';
import 'package:uwuchat/views/conversation_screen.dart';
import 'package:uwuchat/views/search.dart';
import 'package:uwuchat/views/settings.dart';
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
    String myChatroomId =  Constants.myEmail+"_"+Constants.myEmail;
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

              List<dynamic> usersNames = data['userNames'];
              String chatRoomName = usersNames[0];

              for(int i=0; i < usersNames.length; i++){
                if(usersNames[i] != Constants.myName){
                  chatRoomName = usersNames[i];
                }
              }

              if(data['chatroomid'].toString() == myChatroomId) {
                return ChatRoomTile(
                    "Just You",
                    data['chatroomid'],
                    data['lastMessage'].toString().length > Constants.maxLengthOfMessageInChatroomView ? data['lastMessage'].toString().substring(0,Constants.maxLengthOfMessageInChatroomView)+"..." : data['lastMessage']
                );
              }
              else{
                return ChatRoomTile(
                    chatRoomName,
                    data['chatroomid'],
                    data['lastMessage'].toString().length > Constants.maxLengthOfMessageInChatroomView ? data['lastMessage'].toString().substring(0,Constants.maxLengthOfMessageInChatroomView)+"..." : data['lastMessage']
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
    Constants.myEmail = (await HelperFunctions.getUserEmailSharedPreference())!;
    dataBaseMethods.getChatRooms(Constants.myEmail).then((value){
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
    //          authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => SettingsView()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.settings),
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
  final String lastMessage;
  ChatRoomTile(this.userName,this.chatRoomId,this.lastMessage);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId,userName)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xffffcc80),
                  const Color(0xffe65100)
              ]
            ),
            borderRadius: BorderRadius.circular(25)
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
              Row(
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
                Text(userName,style: simpleTextStyle()),
              ],
            ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(lastMessage,style: simpleTextStyle()),
              )
            ]
          ),
        ),
      ),
    );
  }
}

