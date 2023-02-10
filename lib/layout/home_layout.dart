import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/screens/login_screen/login_screen.dart';
import 'package:sba7/screens/train_info_screen/train_info_screen.dart';
import 'package:sba7/shared/cache_helper.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 10,
                  bottom: const TabBar(padding: EdgeInsets.all(0), tabs: [
                    Tab(icon: Icon(Icons.upcoming_outlined), text: "upcoming"),
                    Tab(icon: Icon(Icons.history), text: "History")
                  ]),
                ),
                body: TabBarView(children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => TrainingCard(
                              item: cubit.upcomingTrain[index], cubit: cubit),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemCount: cubit.upcomingTrain.length),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  TrainingCard(item: cubit.beforeTrain[index],context: context),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemCount: cubit.beforeTrain.length),
                          TextButton(
                              onPressed: () {
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
                              },
                              child: Text("Logout"))
                        ],
                      ),
                    ),
                  ),
                ]),
              ));
          // return Scaffold(
          //   appBar: AppBar(),
          //   body: SingleChildScrollView(
          //     physics: const BouncingScrollPhysics(),
          //     child: Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Column(children: [
          //         const SizedBox(
          //           height: 15,
          //         ),
          //         ListView.separated(
          //             shrinkWrap: true,
          //             physics: const NeverScrollableScrollPhysics(),
          //             itemBuilder: (context, index) => TrainingCard(cubit: cubit),
          //             separatorBuilder: (context, index) =>
          //                 const SizedBox(height: 10),
          //             itemCount: 10)
          //       ]),
          //     ),
          //   ),
          // );
        });
  }
}


Widget TrainingCard({context, required item, cubit}) {
  return InkWell(
    splashColor: Colors.grey,
    onTap: () {
      navigateTo(context, TrainScreen(training: item,));
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
