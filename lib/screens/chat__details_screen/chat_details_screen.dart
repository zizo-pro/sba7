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
  const ChatDetailscreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatCubit.get(context).getMessages(
        senderId: userData['uid'], receiverId: 'O72h0YRx5qcET5kKatWQmXt3SgZ2');
    // ChatCubit.get(context).isDelayed = false;

    return BlocConsumer<ChatCubit, ChatStates>(
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
                  fallback: (context) => const CircularProgressIndicator(),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.blue,
                      ),
                      Expanded(
                          child: messages!.isEmpty
                              ? const Center(
                                  child: Text('Start your conversation now :)'))
                              : ListView.builder(
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];

                                    return Text(message.content!);
                                  },
                                ))
                    ]),
                  ),
                );
              });
        });
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage(),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<MessageModel>> messagesStream;

  @override
  void initState() {
    messagesStream = supabase
        .from("messages")
        .stream(primaryKey: ['senderId'])
        .order('createdAt')
        .map((maps) => maps.map((map) => MessageModel.fromJson(map)).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatCubit.get(context);
          return StreamBuilder<List<MessageModel>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.blue,
                      ),
                      Expanded(
                          child: messages.isEmpty
                              ? const Center(
                                  child: Text('Start your conversation now :)'))
                              : ListView.builder(
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];

                                    return Text(message.content!);
                                  },
                                ))
                    ]),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              });
        });
  }
}
