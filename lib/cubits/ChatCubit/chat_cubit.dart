import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/ChatCubit/chat_states.dart';
import 'package:sba7/models/message_model.dart';
import 'package:sba7/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitState());
  static ChatCubit get(context) => BlocProvider.of(context);
  final supabase = Supabase.instance.client;

  Stream<List<MessageModel>>? messages;
  String stat = 'not';
  Future<void> getMessages(
      {required String senderId, required String receiverId}) async {
    stat = 'not';
    messages = supabase
        .from("messages")
        .stream(primaryKey: ['messageId'])
        .eq("senderId", senderId)
        .order('createdAt')
        .map((maps) {
          log(maps.toString());
          return maps.where((element) => element['receiverId'] == receiverId).map((map) => MessageModel.fromJson(map)).toList();
        });
    print(messages == null);
    stat = 'done';
    emit(GetMessagesState());
  }

  bool isDelayed = false;
  void test() {
    // isDelayed = false;
    Timer(const Duration(milliseconds: 50), () {
      isDelayed = true;
    });
    emit(ChatInitState());
  }
}
