import 'dart:async';

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
  Future<void> getMessages() async {
    stat = 'not';
    messages = supabase
        .from("messages")
        .stream(primaryKey: ['messageId'])
        .order('createdAt')
        .map((maps) => maps.map((map) => MessageModel.fromJson(map)).toList());
    stat = 'done';
    emit(ChatInitState());
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
