import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/components.dart';

class TrainScreen extends StatelessWidget {
  TrainScreen({super.key});
  var formkey = GlobalKey<FormState>();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController locationController = TextEditingController();
  TextEditingController weekDayController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                key: scaffoldkey,
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    if (cubit.isBottomSheetShown) {
                      cubit.bottomSheet(isShow: false, icon: Icons.edit);
                      Navigator.pop(context);
                    } else {
                      cubit.bottomSheet(isShow: true, icon: Icons.add);
                      scaffoldkey.currentState!.showBottomSheet(
                        elevation: 20,
                        (context) {
                          return Container(
                            height: 350,
                            width: double.infinity,
                            child: Form(
                              key: formkey,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    textfield(
                                        controller: locationController,
                                        type: TextInputType.name,
                                        prefix: Icons.location_on_outlined,
                                        obscure: false,
                                        label: "Location"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    textfield(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        prefix: Icons.alarm,
                                        obscure: false,
                                        onTap: () => showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) =>
                                                timeController.text = value!
                                                    .format(context)
                                                    .toString())),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: DropdownButtonFormField(
                                          hint: const Text("User"),
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)))),
                                          value: cubit.dropDownValue,
                                          items: ites,
                                          onChanged: (value) {
                                            cubit.weekDaysDropDown(
                                                value: value);
                                          }),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile(
                                            value: "Repeat",
                                            title: const Text("Repeat"),
                                            groupValue: cubit.rad,
                                            onChanged: (value) {
                                              cubit.radioButton("Repeat");
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile(
                                            value: "Once",
                                            title: const Text("Once"),
                                            groupValue: cubit.rad,
                                            onChanged: (value) {
                                              cubit.radioButton("Once");
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Icon(cubit.fabIcon),
                ),
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
                      child: ConditionalBuilder(
                        condition: cubit.upcomingTrain.isNotEmpty,
                        fallback: (context) => Center(
                          child: Text(
                            "No Upcoming Trainings",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[500]),
                          ),
                        ),
                        builder: (context) => ListView.separated(
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

const List<DropdownMenuItem> ites = [
  DropdownMenuItem(
    value: 0,
    child: Text("Sunday"),
  ),
  DropdownMenuItem(
    value: 1,
    child: Text("Monday"),
  ),
  DropdownMenuItem(
    value: 2,
    child: Text("Tuesday"),
  ),
  DropdownMenuItem(
    value: 3,
    child: Text("Wednesday"),
  ),
  DropdownMenuItem(
    value: 4,
    child: Text("Thursday"),
  ),
  DropdownMenuItem(
    value: 5,
    child: Text("Friday"),
  ),
  DropdownMenuItem(
    value: 6,
    child: Text("Saturday"),
  ),
];
