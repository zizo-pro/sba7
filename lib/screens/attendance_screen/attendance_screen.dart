import 'package:flutter/material.dart';
import 'package:sba7/shared/components.dart';

class AttendanceScreeen extends StatelessWidget {
  const AttendanceScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding:const  EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [userAttendanceCard()],),
        ),
      )),
    );
  }
}
