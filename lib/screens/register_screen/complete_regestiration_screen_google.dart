// // ignore_for_file: avoid_print, sized_box_for_whitespace

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sba7/cubits/Login_Cubit/login_cubit.dart';
// import 'package:sba7/cubits/Login_Cubit/login_states.dart';
// import 'package:sba7/shared/components.dart';

// class CompleteRegisterScreenGoogle extends StatelessWidget {
//   final String userEmail;
//   final String uid;
//   final String fullName;
//   CompleteRegisterScreenGoogle(
//       {super.key, required this.userEmail, required this.uid,required this.fullName});
//   final List<DropdownMenuItem> ites = const [
//     DropdownMenuItem(
//       value: 0,
//       child: Text("Swimmer"),
//     ),
//     DropdownMenuItem(
//       value: 1,
//       child: Text("Coach"),
//     ),
//     DropdownMenuItem(
//       value: 2,
//       child: Text("Assistant"),
//     )
//   ];
//   final List<String> texts = ["Swimmer", "Coach", "Assistant"];
//   @override
//   Widget build(BuildContext context) {
//     var key = GlobalKey<FormState>();
//     return BlocConsumer<LoginCubit, LoginStates>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           var cubit = LoginCubit.get(context);
//           return Scaffold(
//             body: Form(
//               key: key,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       textfield(
//                         controller: cubit.passwordReg,
//                         type: TextInputType.visiblePassword,
//                         label: "Password",
//                         prefix: Icons.lock,
//                         obscure: true,
//                         validate: (value) {
//                           if ((cubit.passwordReg.text.length > 7) &
//                               (cubit.confirmPassReg.text ==
//                                   cubit.passwordReg.text)) {
//                             return null;
//                           } else if (cubit.passwordReg.text.length < 8) {
//                             return "Password is too short";
//                           } else if (cubit.passwordReg.text !=
//                               cubit.confirmPassReg.text) {
//                             return "Please confirm your password";
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       textfield(
//                         controller: cubit.confirmPassReg,
//                         type: TextInputType.visiblePassword,
//                         label: "Confirm Password",
//                         prefix: Icons.lock,
//                         obscure: true,
//                         validate: (value) {
//                           if ((cubit.confirmPassReg.text.length > 7) &
//                               (cubit.confirmPassReg.text ==
//                                   cubit.passwordReg.text)) {
//                             return null;
//                           } else if (cubit.confirmPassReg.text.length < 8) {
//                             return "Password is too short";
//                           } else if (cubit.passwordReg.text !=
//                               cubit.confirmPassReg.text) {
//                             return "Please confirm your password";
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       textfield(
//                           controller: cubit.phoneReg,
//                           type: TextInputType.phone,
//                           label: "Phone Number",
//                           prefix: Icons.phone,
//                           obscure: false,
//                           validate: (value) {
//                             if (cubit.phoneReg.text.isNotEmpty) {
//                               return null;
//                             } else {
//                               return 'Please enter a valid phone number';
//                             }
//                           }),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       textfield(
//                           controller: cubit.teamCodeReg,
//                           type: TextInputType.phone,
//                           label: "Team Code",
//                           prefix: Icons.people,
//                           obscure: false,
//                           validate: (value) {
//                             if (cubit.teamCodes
//                                 .contains(cubit.teamCodeReg.text)) {
//                               return null;
//                             } else {
//                               return "Please enter a valid team code";
//                             }
//                           }),
//                                                 const SizedBox(
//                         height: 10,
//                       ),
//                       const Text(
//                         " user type",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       const SizedBox(
//                         height: 3,
//                       ),
//                       Container(
//                         width: double.infinity,
//                         child: DropdownButtonFormField(
//                             hint: const Text("User"),
//                             decoration: const InputDecoration(
//                                 border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(6)))),
//                             value: cubit.dropDownValue,
//                             items: ites,
//                             onChanged: (value) {
//                               cubit.changeDropDown(value);
//                             }),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       const Text(
//                         " Birth Date",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       Container(
//                         height: 100,
//                         child: CupertinoDatePicker(
//                           maximumDate: DateTime.now(),
//                           initialDateTime: DateTime(1980, 1, 1),
//                           mode: CupertinoDatePickerMode.date,
//                           onDateTimeChanged: (value) {
//                             cubit.birthDate = value;
//                           },
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 50,
//                       ),
//                       Center(
//                           child: TextButton(
//                               onPressed: () async {
//                                 await cubit
//                                     .updateReg(
//                                       birthDate: cubit.birthDate,
//                                         uemail: userEmail,
//                                         userType: texts[cubit.dropDownValue],
//                                         context: context,
//                                         uid: uid,)
//                                     .then((value) => print("done"))
//                                     .catchError((onError) {
//                                   print(onError.toString());
//                                 });
//                               },
//                               child: const Text("Continue"))),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
