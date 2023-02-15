// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/screens/attendance_screen/attendance_screen.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';

class TrainInfoScreen extends StatefulWidget {
  final training;
  const TrainInfoScreen({super.key, required this.training});

  @override
  State<TrainInfoScreen> createState() => _TrainInfoScreenState();
}

class _TrainInfoScreenState extends State<TrainInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(
                    DateTime.parse(widget.training['date']).day.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    months[DateTime.parse(widget.training['date']).month - 1],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(DateTime.parse(widget.training['date']).year.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400))
                ],
              ),
              const Spacer(),
              Text(
                DateFormat("h:mm a")
                    .format(DateTime.parse(widget.training['date'])),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
                onPressed: () {
                  AppCubit.get(context)
                      .testio(trainingID: widget.training['id']);
                  if (userData['user_type'] == "Coach" || userData['user_type'] == 'Assistant') {
                    navigateTo(
                        context,
                        AttendanceScreeen(
                          trainingID: widget.training['id'],
                          isAttendance: AppCubit.get(context).checkAttendance,
                        ));
                  } else {
                    print("You're not Authorized");
                  }
                },
                icon: const Icon(Icons.people),
                label: const Text("Attendance")),
          ),

          // Container(
          //   child: TabBar(
          //       unselectedLabelColor: Colors.red,
          //       labelColor: Colors.blue,
          //       dividerColor: Colors.green,
          //       indicatorColor: Colors.amber,
          //       tabs: [
          //         Tab(
          //           text: "Attendance",
          //         ),
          //         Tab(
          //           text: "lol",
          //         )
          //       ]),
          // )
          // TabBarView(controller: ,children: [Text("ziad"), Text("ebrahim")])
        ]),
      ),
    );
  }
}
