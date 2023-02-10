import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sba7/shared/constants.dart';

class TrainScreen extends StatelessWidget {
  final training;
  const TrainScreen({super.key, required this.training});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(DateTime.parse(training['date']).day.toString(),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    months[DateTime.parse(training['date']).month - 1],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(DateTime.parse(training['date']).year.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
                ],
              ),
              Spacer(),
              Text(
                DateFormat("h:mm a").format(DateTime.parse(training['date'])),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          DefaultTabController(
              length: 2,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.people),
                    text: "Attendance",
                  ),
                  Tab(
                    icon: Icon(Icons.people),
                    text: "Attendance",
                  ),
                ],
              )),
          TabBarView(controller: ,children: [Text("ziad"), Text("ebrahim")])
        ]),
      ),
    );
  }
}
