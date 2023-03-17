import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';

class TrainScreen extends StatelessWidget {
  TrainScreen({super.key});
  var formkey = GlobalKey<FormState>();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController locationController = TextEditingController();
  TextEditingController weekDayController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return ConditionalBuilder(
            condition:
                cubit.upcomingTrain.isNotEmpty || cubit.beforeTrain.isNotEmpty,
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            builder: (context) => DefaultTabController(
                length: 2,
                child: Scaffold(
                  key: scaffoldkey,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      if (userData['user_type'] == "Coach") {
                        if (cubit.isBottomSheetShown) {
                          cubit.bottomSheet(isShow: false, icon: Icons.edit);
                          if (cubit.isRepeat) {
                            cubit.addOneTraining(
                                date: weekdays[cubit.dropDownValue],
                                time: timeController.text,
                                location: cubit.locations[
                                    cubit.locationdropDownValue as int]['id']);
                          } else {
                            cubit.addOneTraining(
                                date: dateController.text,
                                time: timeController.text,
                                location: cubit.locations[
                                    cubit.locationdropDownValue as int]['id']);
                          }

                          Navigator.pop(context);
                        } else {
                          cubit.bottomSheet(isShow: true, icon: Icons.add);
                          scaffoldkey.currentState!
                              .showBottomSheet(
                                elevation: 20,
                                (context) {
                                  return BlocConsumer<AppCubit, AppStates>(
                                    listener: (context, state) {},
                                    builder: (context, state) => Container(
                                      height: 350,
                                      width: double.infinity,
                                      child: Form(
                                        key: formkey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              // textfield(
                                              //     controller: locationController,
                                              //     type: TextInputType.name,
                                              //     prefix:
                                              //         Icons.location_on_outlined,
                                              //     obscure: false,
                                              //     label: "Location"),
                                              // const SizedBox(
                                              //   height: 20,
                                              // ),
                                              Container(
                                                width: double.infinity,
                                                child: DropdownButtonFormField(
                                                    decoration: const InputDecoration(
                                                        label: Text("Location"),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            6)))),
                                                    value: cubit
                                                        .locationdropDownValue,
                                                    items: cubit.dropLocations,
                                                    onChanged: (value) {
                                                      cubit.locationDropDown(
                                                          value: value);
                                                    }),
                                              ),

                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: RadioListTile(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 2),
                                                      value: 0,
                                                      title:
                                                          const Text("Repeat"),
                                                      groupValue: cubit.rad,
                                                      onChanged: (value) {
                                                        cubit
                                                            .radioButton(value);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: RadioListTile(
                                                      value: 1,
                                                      title: const Text("Once"),
                                                      groupValue: cubit.rad,
                                                      onChanged: (value) {
                                                        cubit
                                                            .radioButton(value);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textfield(
                                                  controller: timeController,
                                                  type: TextInputType.datetime,
                                                  prefix: Icons.alarm,
                                                  label: "Time",
                                                  obscure: false,
                                                  onTap: () => showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now())
                                                      .then((value) =>
                                                          timeController.text =
                                                              value!
                                                                  .format(
                                                                      context)
                                                                  .toString())),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: ConditionalBuilder(
                                                  condition: cubit.isRepeat,
                                                  fallback: (context) => textfield(
                                                      controller:
                                                          dateController,
                                                      type: TextInputType
                                                          .datetime,
                                                      prefix: Icons
                                                          .calendar_month_outlined,
                                                      label: "Date",
                                                      obscure: false,
                                                      onTap: () => showDatePicker(
                                                              context: context,
                                                              firstDate: DateTime(
                                                                  2000, 01, 01),
                                                              lastDate: DateTime(
                                                                  2030, 12, 31),
                                                              initialDate:
                                                                  DateTime
                                                                      .now())
                                                          .then((value) =>
                                                              dateController.text =
                                                                  DateFormat('yyyy-MM-d').format(value!))),
                                                  builder: (context) =>
                                                      DropdownButtonFormField(
                                                          decoration: const InputDecoration(
                                                              label:
                                                                  Text("Day"),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              6)))),
                                                          value: cubit
                                                              .dropDownValue,
                                                          items: ites,
                                                          onChanged: (value) {
                                                            cubit
                                                                .weekDaysDropDown(
                                                                    value:
                                                                        value);
                                                          }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                              .closed
                              .then((value) => cubit.bottomSheet(
                                  isShow: false, icon: Icons.edit));
                        }
                      } else {
                        showToast(
                            msg: "you're not Authorized",
                            state: ToastStates.ERROR);
                      }
                    },
                    child: Icon(cubit.fabIcon),
                  ),
                  appBar: AppBar(
                    toolbarHeight: 10,
                    bottom: const TabBar(padding: EdgeInsets.all(0), tabs: [
                      Tab(
                          icon: Icon(Icons.upcoming_outlined),
                          text: "upcoming"),
                      Tab(icon: Icon(Icons.history), text: "History")
                    ]),
                  ),
                  body: TabBarView(children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ConditionalBuilder(
                          condition: cubit.upcomingTrain.isNotEmpty ||
                              cubit.todayTrain.isNotEmpty,
                          fallback: (context) => Center(
                            child: Text(
                              "No Upcoming Trainings",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[500]),
                            ),
                          ),
                          builder: (context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Today",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16)),
                                if (cubit.todayTrain.isEmpty)
                                  const Center(
                                      child: Text(
                                    "No Trainings Today",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                const SizedBox(
                                  height: 15,
                                ),
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        trainingCard(
                                            item: cubit.todayTrain[index],
                                            cubit: cubit,
                                            context: context),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 20),
                                    itemCount: cubit.todayTrain.length),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text("Upcoming",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16)),
                                const SizedBox(
                                  height: 15,
                                ),
                                if (cubit.upcomingTrain.isEmpty)
                                  const Center(
                                      child: Text(
                                    "No Upcoming Trainings",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        trainingCard(
                                            item: cubit.upcomingTrain[index],
                                            cubit: cubit,
                                            context: context),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 20),
                                    itemCount: cubit.upcomingTrain.length),
                              ]),
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
                )),
          );
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
