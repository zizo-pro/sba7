import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';

class AttendanceScreeen extends StatelessWidget {
  final String trainingID;
  final bool isAttendance;
  const AttendanceScreeen(
      {super.key, required this.trainingID, required this.isAttendance});

  @override
  Widget build(BuildContext context) {
    // complete the attendance screen by joining the two tables akeed enta fakr y3ny :)
    return ConditionalBuilder(
      condition: isAttendance,
      fallback: (context) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .submitAttenddance(trainingID: trainingID);
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => userAttendanceCard(
                          swimmerData: swimmers[index], context: context),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: swimmers.length)
                ],
              ),
            ),
          ),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => alreadyAttendance(
                            swimmerData:
                                AppCubit.get(context).ifAttendance[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: AppCubit.get(context).ifAttendance.length)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
