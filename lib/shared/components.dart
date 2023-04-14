// ignore_for_file: constant_identifier_names, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/screens/login_screen/login_screen.dart';
import 'package:sba7/screens/train_info_screen/train_info_screen.dart';
import 'package:sba7/shared/cache_helper.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sba7/shared/constants.dart';

void navigateTo(context, dynamic screen) =>
    Navigator.push(context, MaterialPageRoute(builder: ((context) => screen)));

void navigateAndFinish(context, dynamic screen) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: ((context) => screen)), (route) {
      return false;
    });

void logOut({required context}) {
  userData = null;
  token = null;
  userAuth = null;
  swimmers = null;
  token = null;
  CacheHelper.removeData(key: "team_code");
  CacheHelper.removeData(key: 'userAuth');
  CacheHelper.removeData(key: 'userData');
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    userData = null;
    token = null;
    userAuth = null;
    swimmers = null;
    token = null;
    FirebaseAuth.instance.signOut();
    navigateAndFinish(
      context,
      const LoginScreen(),
    );
    Restart.restartApp();
  });
}

Widget textfield({
  required TextEditingController controller,
  required TextInputType type,
  Function(String?)? onSubmit,
  Function(String?)? onChange,
  Function()? onTap,
  String? Function(String?)? validate,
  var label,
  required IconData prefix,
  String? hint,
  required bool obscure,
}) {
  return TextFormField(
    validator: validate,
    controller: controller,
    keyboardType: type,
    obscureText: obscure,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    decoration: InputDecoration(
      labelStyle: const TextStyle(color: Colors.black),
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(prefix),
    ),
  );
}

Widget trainingCard({context, required item, cubit}) {
  return InkWell(
    splashColor: Colors.grey,
    onTap: () {
      cubit.testio(trainingID: item['id']);
      navigateTo(
          context,
          TrainInfoScreen(
            training: item,
          ));
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400] as Color,
            blurStyle: BlurStyle.outer,
            spreadRadius: 0.6,
            blurRadius: 7,
          )
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // {date: 2005-12-24, time: 20:00:00, location: Tipa rose}
                Text(
                  DateTime.parse(item['date']).day.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 28),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  months[DateTime.parse(item['date']).month - 1],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  DateFormat("EEEE").format(DateTime.parse(item['date'])),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 5),
                Text(
                  DateFormat("h:mm a").format(DateTime.parse(item['date'])),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              item["training_locations"]['location'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios)
      ]),
    ),
  );
}

Widget editAttendance({required swimmerData, required BuildContext context}) {
  Color? wrongColor;
  Color? rightColor;
  if (swimmerData['attended']) {
    rightColor = Colors.green;
    wrongColor = Colors.grey;
  } else {
    wrongColor = Colors.red;
    rightColor = Colors.grey;
  }
  return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Container(
          padding: const EdgeInsets.all(8),
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400] as Color,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0.6,
                blurRadius: 7,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 27,
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(80),
                        child: CachedNetworkImage(
                          imageUrl: swimmerData['users']['profile_picture'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      toBeginningOfSentenceCase(
                              swimmerData['users']["full_name"].toString())
                          .toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateTime.parse(swimmerData['users']['birth_date'])
                          .year
                          .toString(),
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: rightColor,
                  child: IconButton(
                    iconSize: 16,
                    color: Colors.white,
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      rightColor = Colors.green[600];
                      wrongColor = Colors.grey;
                      cubit.updateAttendance(
                          userID: swimmerData['user_id'], attented: true);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: wrongColor,
                  child: IconButton(
                    iconSize: 16,
                    color: Colors.white,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      rightColor = Colors.grey;
                      wrongColor = Colors.red;
                      cubit.updateAttendance(
                          userID: swimmerData['user_id'], attented: false);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Widget alreadyAttendance({required swimmerData}) {
  Color? iconColor;
  IconData? icon;
  if (swimmerData['attended']) {
    iconColor = Colors.green;
    icon = Icons.check;
  } else {
    iconColor = Colors.red;
    icon = Icons.close;
  }
  return Container(
    padding: const EdgeInsets.all(8),
    height: 80,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[400] as Color,
          blurStyle: BlurStyle.outer,
          spreadRadius: 0.6,
          blurRadius: 7,
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          CircleAvatar(
              radius: 27,
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(80),
                  child: CachedNetworkImage(
                    imageUrl: swimmerData['users']['profile_picture'],
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                toBeginningOfSentenceCase(
                        swimmerData['users']["full_name"].toString())
                    .toString(),
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                DateTime.parse(swimmerData['users']['birth_date'])
                    .year
                    .toString(),
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 16,
            backgroundColor: iconColor,
            child: Icon(
              icon,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget userAttendanceCard({required swimmerData, required context}) {
  Color? wrongColor = Colors.grey;
  Color? rightColor = Colors.grey;
  AppCubit.get(context).attendance = {};
  return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Container(
          padding: const EdgeInsets.all(8),
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400] as Color,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0.6,
                blurRadius: 7,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(children: [
              CircleAvatar(
                  radius: 27,
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(80),
                      child: CachedNetworkImage(
                        imageUrl: swimmerData['profile_picture'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    toBeginningOfSentenceCase(
                            swimmerData["full_name"].toString())
                        .toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    DateTime.parse(swimmerData['birth_date']).year.toString(),
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 16,
                backgroundColor: rightColor,
                child: IconButton(
                  iconSize: 16,
                  color: Colors.white,
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    rightColor = Colors.green[600];
                    wrongColor = Colors.grey;
                    cubit.attendanceMap(
                        userID: swimmerData['uid'], attented: true);
                  },
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 16,
                backgroundColor: wrongColor,
                child: IconButton(
                  iconSize: 16,
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    rightColor = Colors.grey;
                    wrongColor = Colors.red;
                    cubit.attendanceMap(
                        userID: swimmerData['uid'], attented: false);
                  },
                ),
              ),
            ]),
          ),
        );
      });
}

Widget championShipResult({required resData}) {
  return Container(
    padding: const EdgeInsets.all(8),
    height: 80,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[400] as Color,
          blurStyle: BlurStyle.outer,
          spreadRadius: 0.6,
          blurRadius: 7,
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Row(children: [
        CircleAvatar(
            radius: 27,
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(80),
                child: CachedNetworkImage(
                  imageUrl: resData['users']['profile_picture'],
                  fit: BoxFit.cover,
                ),
              ),
            )),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              toBeginningOfSentenceCase(
                      resData['users']["full_name"].toString())
                  .toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              DateTime.parse(resData['users']['birth_date']).year.toString(),
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              toBeginningOfSentenceCase(resData['events']["event"].toString())
                  .toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              resData['score'],
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        )
      ]),
    ),
  );
}

void showToast({required String msg, required ToastStates state}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color? color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
  }
  return color;
}

Widget adminGridItem(
    {required Function()? onTap,
    required IconData? icon,
    required String label}) {
  return InkWell(
    onTap: onTap,
    child: GestureDetector(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey[400] as Color,
                  blurRadius: 6,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 0,
                  offset: const Offset(-1, -1))
            ]),
            height: 150,
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 60,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                )
              ],
            ),
          )),
    ),
  );
}

Widget swimmerGridItem({required userData, required onTap}) {
  return InkWell(
    onTap: () {},
    child: GestureDetector(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.grey[400] as Color,
                  blurRadius: 6,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 0,
                  offset: const Offset(-1, -1))
            ]),
            height: 250,
            child: Column(
              children: [
                Container(
                  height: 110,
                  child: CircleAvatar(
                    radius: 55,
                    child: ClipOval(
                        child: SizedBox.fromSize(
                      size: const Size.fromRadius(55),
                      child: CachedNetworkImage(
                          imageUrl: userData['profile_picture'],
                          fit: BoxFit.fill),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  userData["full_name"],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  DateTime.parse(userData['birth_date']).year.toString(),
                  style: const TextStyle(),
                ),
              ],
            ),
          )),
    ),
  );
}

Widget nonacceptSwimmers({required swimmerData, required index}) {
  return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Container(
          // padding: const EdgeInsets.all(4),
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400] as Color,
                blurStyle: BlurStyle.outer,
                spreadRadius: 0.6,
                blurRadius: 7,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(children: [
              CircleAvatar(
                  radius: 27,
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(80),
                      child: CachedNetworkImage(
                        imageUrl: swimmerData['profile_picture'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 95,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      toBeginningOfSentenceCase(
                              swimmerData["full_name"].toString())
                          .toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    DateTime.parse(swimmerData['birth_date']).year.toString(),
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.green,
                radius: 16,
                child: IconButton(
                    iconSize: 16,
                    color: Colors.white,
                    onPressed: () {
                      cubit.acceptSwimmer(
                          id: swimmerData['uid'],
                          isAccepted: true,
                          index: index);
                    },
                    icon: const Icon(Icons.check)),
              ),
              const SizedBox(
                width: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 16,
                child: IconButton(
                    iconSize: 16,
                    color: Colors.white,
                    onPressed: () {
                      cubit.acceptSwimmer(
                          id: swimmerData['uid'],
                          isAccepted: false,
                          index: index);
                    },
                    icon: const Icon(Icons.close)),
              ),
            ]),
          ),
        );
      });
}

Widget subscriptionItemBuiler(swimmer, context, cubit) {
  Color textColor;
  if (swimmer['amount'] > 0) {
    textColor = Colors.green;
  } else {
    textColor = Colors.red;
  }
  return InkWell(
    splashColor: Colors.grey,
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(swimmer['users']['full_name']),
          content: ConditionalBuilder(
            condition: swimmer['amount'] == 0,
            fallback: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${swimmer['amount']} \$",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.green)),
                Text(swimmer['method'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                textfield(
                    label: "Amount",
                    controller: cubit.addAmountController,
                    obscure: false,
                    type: TextInputType.number,
                    prefix: Icons.attach_money),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                    value: cubit.dropdownvalue,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      labelText: "Payment Method",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text("Cash"),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text("Visa"),
                      )
                    ],
                    onChanged: (value) {
                      cubit.changeDropDown(value);
                    }),
                TextButton(
                  child: const Text("pay"),
                  onPressed: () {
                    cubit.addAmount(swimmer);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
    child: GestureDetector(
      child: Container(
        height: 180,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[500] as Color,
                  blurRadius: 10,
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 0,
                  offset: const Offset(-1, -1)),
            ],
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(60),
                      child: CachedNetworkImage(
                        imageUrl: swimmer['users']['profile_picture'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(swimmer['users']['full_name'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(DateTime.parse(swimmer['users']['birth_date'])
                    .year
                    .toString()),
                Text(
                  "${swimmer['amount'].toString()} \$",
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ]),
        ),
      ),
    ),
  );
}

Widget userChatCard({required swimmerData, required context}) {
  return Container(
    padding: const EdgeInsets.all(8),
    height: 80,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[400] as Color,
          blurStyle: BlurStyle.outer,
          spreadRadius: 0.6,
          blurRadius: 7,
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Row(children: [
        CircleAvatar(
            radius: 27,
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(80),
                child: CachedNetworkImage(
                  imageUrl: swimmerData['profile_picture'],
                  fit: BoxFit.cover,
                ),
              ),
            )),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              toBeginningOfSentenceCase(swimmerData["full_name"].toString())
                  .toString(),
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              DateTime.parse(swimmerData['birth_date']).year.toString(),
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
        const Spacer(),
      ]),
    ),
  );
}
