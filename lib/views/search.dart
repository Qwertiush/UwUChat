import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwuchat/helper/constants.dart';
import 'package:uwuchat/services/database.dart';
import 'package:uwuchat/views/conversation_screen.dart';
import 'package:uwuchat/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();

  QuerySnapshot? searchSnapshot;

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot?.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
              userName: searchSnapshot?.docs[index].get("name"),
              userEmail: searchSnapshot?.docs[index].get("email")
          );
        }
    ) : Container();
  }

  initiateSearch(){
    dataBaseMethods.getUserByUserName(searchTextEditingController.text)
        .then((val) {
          setState(() {
            searchSnapshot = val;
          });
      });
  }

  createChatroomAndStartConversation({required String userName}){

    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users" : users,
      "chatroomid" : chatRoomId
    };

    DataBaseMethods().createChatRoom(chatRoomId,chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId)
    ));
  }

  Widget SearchTile({required String userName, required String userEmail}){
    return Container(
      color: Colors.orange,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTextStyle(),),
              Text(userEmail, style: simpleTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(15)
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
              child: Text("Message", style: clickableTextStyle(),),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLoggedIn(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: textFieldInputDecoration("Search for people..."),
                        style: clickableTextStyle(),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                        initiateSearch();
                      },
                      child: Icon(Icons.search, color: Colors.white,)
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}
