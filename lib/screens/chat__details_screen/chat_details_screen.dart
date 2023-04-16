import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/ChatCubit/chat_cubit.dart';
import 'package:sba7/cubits/ChatCubit/chat_states.dart';
import 'package:sba7/models/message_model.dart';
import 'package:sba7/models/profile.dart';
import 'package:sba7/shared/constants.dart';
import 'dart:async';
import 'package:timeago/timeago.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client
final supabase = Supabase.instance.client;

/// Simple preloader inside a Center widget
const preloader =
    Center(child: CircularProgressIndicator(color: Colors.orange));

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Basic theme to change the look and feel of the app
final appTheme = ThemeData.light().copyWith(
  primaryColorDark: Colors.orange,
  appBarTheme: const AppBarTheme(
    elevation: 1,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
  ),
  primaryColor: Colors.orange,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.orange,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.orange,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(
      color: Colors.orange,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 2,
      ),
    ),
    focusColor: Colors.orange,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.orange,
        width: 2,
      ),
    ),
  ),
);

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

class ChatDetailscreen extends StatelessWidget {
  final swimmer;
  const ChatDetailscreen({super.key, required this.swimmer});

  @override
  Widget build(BuildContext context) {
    ChatCubit.get(context)
        .getMessages(senderId: userData['uid'], receiverId: swimmer['uid']);
    // ChatCubit.get(context).isDelayed = false;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                radius: 20,
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(80),
                    child: CachedNetworkImage(
                      imageUrl: swimmer['profile_picture'],
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            const SizedBox(
              width: 10,
            ),
            Text(swimmer['full_name']),
          ],
        ),
      ),
      body: BlocConsumer<ChatCubit, ChatStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = ChatCubit.get(context);
            return StreamBuilder<List<MessageModel>>(
                stream: cubit.messages,
                builder: (context, snapshot) {
                  final messages = snapshot.data;
                  // The null problem
                  return ConditionalBuilder(
                    condition: messages != null,
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        Expanded(
                            child: messages!.isEmpty
                                ? const Center(
                                    child:
                                        Text('Start your conversation now :)'))
                                : ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    reverse: true,
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                      final message = messages[index];
                                      if (message.senderId == userData['uid']) {
                                        return buildMyMessage(message);
                                      } else {
                                        return buildMessage(message);
                                      }
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(
                                        height: 5,
                                      );
                                    },
                                  )),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey[300] as Color, width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: TextFormField(
                                    controller: cubit.messageController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'type your message here ...'),
                                  ),
                                ),
                              ),
                              Container(
                                  height: 55,
                                  color: Colors.blue,
                                  child: MaterialButton(
                                    onPressed: () {
                                      cubit.sendMessage(
                                          receiverId: swimmers['uid']);
                                    },
                                    minWidth: 1,
                                    child: const Icon(
                                      Icons.send,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ]),
                    ),
                  );
                });
          }),
    );
  }

  Widget buildMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(10),
                    topEnd: Radius.circular(10),
                    topStart: Radius.circular(10))),
            child: Text(message.content as String)),
      );

  Widget buildMyMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: const BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(10),
                    topEnd: Radius.circular(10),
                    topStart: Radius.circular(10))),
            child: Text(message.content as String)),
      );
}
