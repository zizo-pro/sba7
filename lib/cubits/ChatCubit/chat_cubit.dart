import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/ChatCubit/chat_states.dart';
import 'package:sba7/models/message_model.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitState());
  static ChatCubit get(context) => BlocProvider.of(context);
  final supabase = Supabase.instance.client;

  TextEditingController messageController = TextEditingController();

  Stream<List<MessageModel>>? messages;
  String stat = 'not';
  Future<void> getMessages(
      {required String senderId, required String receiverId}) async {
    messages = supabase
        .from("messages")
        .stream(primaryKey: ['messageId'])
        .order('createdAt')
        .map((maps) {
          log(maps.toString());
          return maps
              .where((element) =>
                  (element['receiverId'] == receiverId ||
                      element['receiverId'] == senderId) &&
                  (element['senderId'] == receiverId ||
                      element['senderId'] == senderId))
              .map((map) => MessageModel.fromJson(map))
              .toList();
        });
    print(messages == null);
    stat = 'done';
    emit(GetMessagesState());
  }

  void sendMessage({required String receiverId}) {
    if (messageController.text.isNotEmpty) {
      supabase.from("messages").insert({
        'senderId': userData['uid'],
        'content': messageController.text,
        'receiverId': receiverId
      }).then((value) {
        emit(ChatSendMessageSuccessState());
        messageController.clear();
      }).catchError((onError) {
        log(onError.toString());
        emit(ChatSendMessageErrorState());
      });
    } else {
      showToast(msg: "Can't Send an Empty message", state: ToastStates.WARNING);
    }
  }
}
