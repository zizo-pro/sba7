import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        labelStyle: TextStyle(color: Colors.black),
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefix),
      ),
    );

Widget TrainingCard({context, required item, cubit}) {
  return InkWell(
    splashColor: Colors.grey,
    onTap: () {
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
                SizedBox(
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
        IconButton(
            onPressed: () {
              print("lol");
            },
            icon: const Icon(Icons.arrow_forward_ios))
        // MaterialButton(onPressed: () {})
      ]),
    ),
  );
}

Widget userAttendanceCard() {
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
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        CircleAvatar(
            radius: 25,
            child: CachedNetworkImage(
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/sba7-ed3fd.appspot.com/o/user_profiles%2Fdefault%2Fuser.png?alt=media&token=ed7c16f0-2765-48b3-ba8b-c21938d2d156",
            )),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ziad Ahmed",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "2005",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {},
        ),
      ]),
    ),
  );
}
