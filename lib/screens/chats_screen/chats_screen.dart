import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/ChatCubit/chat_cubit.dart';
import 'package:sba7/cubits/ChatCubit/chat_states.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      userChatCard(context: context, swimmerData: swimmers[0]),
                  itemCount: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
