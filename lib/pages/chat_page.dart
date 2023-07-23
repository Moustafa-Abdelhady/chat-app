import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/cubit/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/message.dart';
import '../widgets/chat_buble.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  static String id = 'ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
// make instance from firestore
  // FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List<Message> messagesList = [];

//  make reference from collection in my firebase
  // CollectionReference messages =
  //     FirebaseFirestore.instance.collection('messages');

  TextEditingController searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ///way to recieve arguments(email) from navigator..
    /////if i know the reciever value is String use as String
    //example >> String email =ModalRoute.of(context)!.settings.arguments as String;

    //if u don't knew the reciever value use var
    var email = ModalRoute.of(context)!.settings.arguments;
    String username =
        email.toString().substring(0, email.toString().indexOf('@'));
    print(username);

    ///streamBuilder<querysnapshot> used it with realTime
    // return StreamBuilder<QuerySnapshot>(
    // stream: messages.orderBy('createdAt', descending: true).snapshots(),
    // builder: (context, snapshot) {
    //   if (snapshot.hasData) {
    //     List<Message> messagesList = [];
    //     for (int i = 0; i < snapshot.data!.docs.length; i++) {
    //       messagesList.add(Message.fromJsson(snapshot.data!.docs[i]));
    //     }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              // width: 100,
              height: 50,
            ),
            SizedBox(height: 10),
            Text('Helper Chat'),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messagesList =
                    BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                              id: messagesList[index].id,
                            )
                          : otherChatBuble(
                              message: messagesList[index],
                              id: messagesList[index].id,
                            );
                    });
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: kPrimaryColor.withOpacity(0.1)),
            ]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: searchController,
                  onSubmitted: (data) {
                    // messages.add({
                    //   'message': data,
                    //   'createdAt': DateTime.now(),
                    //   'id': email,
                    // });
                    BlocProvider.of<ChatCubit>(context)
                        .sendMessage(message: data, email: AutofillHints.email);
                    searchController.clear();
                    scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.send, color: kPrimaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    hintText: 'Send Message ',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        gapPadding: .6,
                        borderSide: BorderSide(color: kPrimaryColor)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    // } else {
    //   return Center(
    //     child: CircularProgressIndicator(
    //       backgroundColor: Colors.blue[300],
    //     ),
    //   );
    // }
    // },
    // );
  }
}
