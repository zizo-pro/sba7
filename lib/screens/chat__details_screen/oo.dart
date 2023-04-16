// import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:udemy_course/layout/social_app/cubit/cubit.dart';
// import 'package:udemy_course/layout/social_app/cubit/states.dart';
// import 'package:udemy_course/models/social_app/message_model.dart';
// import 'package:udemy_course/models/social_app/users_model.dart';
// import 'package:udemy_course/shared/components/constants.dart';
// import 'package:udemy_course/shared/styles/colors.dart';
// import 'package:udemy_course/shared/styles/icon_broken.dart';

// class ChatDetailsScreen extends StatelessWidget {
//   ChatDetailsScreen({super.key, required this.model});
//   SocialUserModel model;
//   var messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       SocialCubit.get(context).getMessages(reciverId: model.uId as String);

//       return BlocConsumer<SocialCubit, SocialStates>(
//           listener: (context, state) {},
//           builder: (context, state) => Scaffold(
//               appBar: AppBar(
//                 titleSpacing: 0,
//                 title: Row(children: [
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundImage: NetworkImage('${model.image}'),
//                   ),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   Text('${model.name}')
//                 ]),
//               ),
//               body: ConditionalBuilder(
//                 condition: SocialCubit.get(context).messages.isNotEmpty,
//                 fallback: (context) =>
//                     const Center(child: CircularProgressIndicator()),
//                 builder: (context) => Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: ListView.separated(
//                             physics: const BouncingScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               var message =
//                                   SocialCubit.get(context).messages[index];
//                               if (SocialCubit.get(context).Usermodel!.uId ==
//                                   message.senderId) {
//                                 return buildMyMessage(message);
//                               } else {
//                                 return buildMessage(message);
//                               }
//                             },
//                             separatorBuilder: (context, index) {
//                               return const SizedBox(
//                                 height: 15,
//                               );
//                             },
//                             itemCount:
//                                 SocialCubit.get(context).messages.length),
//                       ),
//                       Container(
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Colors.grey[300] as Color, width: 1),
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0),
//                                 child: TextFormField(
//                                   controller: messageController,
//                                   decoration: const InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'type your message here ...'),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                                 height: 55,
//                                 color: defaultColor,
//                                 child: MaterialButton(
//                                   onPressed: () {
//                                     SocialCubit.get(context).sendMessage(
//                                         reciverId: model.uId as String,
//                                         dateTime: DateTime.now().toString(),
//                                         text: messageController.text);
//                                     messageController.text = '';
//                                   },
//                                   minWidth: 1,
//                                   child: const Icon(
//                                     IconBroken.Send,
//                                     size: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ))
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )));
//     });
//   }

//   Widget buildMessage(MessageModel message) => Align(
//         alignment: AlignmentDirectional.centerStart,
//         child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//             decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: const BorderRadiusDirectional.only(
//                     bottomEnd: Radius.circular(10),
//                     topEnd: Radius.circular(10),
//                     topStart: Radius.circular(10))),
//             child: Text(message.text as String)),
//       );

//   Widget buildMyMessage(MessageModel message) => Align(
//         alignment: AlignmentDirectional.centerEnd,
//         child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//             decoration: BoxDecoration(
//                 color: defaultColor.withOpacity(0.2),
//                 borderRadius: const BorderRadiusDirectional.only(
//                     bottomStart: Radius.circular(10),
//                     topEnd: Radius.circular(10),
//                     topStart: Radius.circular(10))),
//             child: Text(message.text as String)),
//       );
// }
