import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/components.dart';

class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

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
                          itemBuilder: (context, index) => trainingCard(
                              item: cubit.upcomingTrain[index],
                              cubit: cubit,
                              context: context),
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
                              itemBuilder: (context, index) => trainingCard(
                                  item: cubit.beforeTrain[index],
                                  context: context,
                                  cubit: cubit),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemCount: cubit.beforeTrain.length),
                          TextButton(
                              onPressed: () {
                                logOut(context: context);
                              },
                              child: const Text("Logout"))
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
