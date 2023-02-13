import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/screens/login_screen/login_screen.dart';
import 'package:sba7/screens/train_info_screen/train_info_screen.dart';
import 'package:sba7/shared/cache_helper.dart';
import 'package:sba7/shared/constants.dart';

void navigateTo(context, dynamic screen) =>
    Navigator.push(context, MaterialPageRoute(builder: ((context) => screen)));

void navigateAndFinish(context, dynamic screen) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: ((context) => screen)), (route) {
      return false;
    });

void logOut({required context}) {
  CacheHelper.removeData(key: "team_code");
  CacheHelper.removeData(key: 'userAuth');
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      navigateAndFinish(
        context,
        const LoginScreen(),
      );
    }
  });
}

Widget textfield({
  required TextEditingController controller,
  required TextInputType type,
  Function(String?)? onSubmit,
  Function(String?)? onChange,
  String? Function(String?)? validate,
  required var label,
  required IconData prefix,
  required bool obscure,
}) =>
    TextFormField(
      validator: validate,
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.black),
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefix),
      ),
    );

Widget trainingCard({context, required item, cubit}) {
  return InkWell(
    splashColor: Colors.grey,
    onTap: () {
      cubit.testio(trainingID:item['id']);
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
              item['location'],
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
