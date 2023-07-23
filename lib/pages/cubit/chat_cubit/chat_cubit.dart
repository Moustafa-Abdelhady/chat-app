import 'dart:js';

import 'package:bloc/bloc.dart';
import 'package:chat_app/widgets/show_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
      
      List<Message> messagesList = [];

  void sendMessage({required String message, required String email}) {
    try {
      messages.add({
        'message': message,
        'createdAt': DateTime.now(),
        'id': email,
      });
    } on Exception catch (e) {
      emit(ChatIndicator());
      print('something went wrong');
    }
  }

  void getMessages() {
    messages.orderBy('createdAt', descending: true).snapshots().listen((event) {
      
      print(event.docs);
      messagesList.clear();

      for (var doc in event.docs) {
        messagesList.add(Message.fromJsson(doc));
      }
      emit(ChatSuccess(messages: messagesList));
      print('Success');
    });
  }
}
