// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';
import 'package:textfield_search/textfield_search.dart';

class ChampionshipScreen extends StatelessWidget {
  const ChampionshipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getChampionships();
    AppCubit.get(context).getEvents();
    AppCubit.get(context).getChampionshipsResults();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: (cubit.championships.isNotEmpty &&
              cubit.events.isNotEmpty &&
              cubit.championshipResults.isNotEmpty),
          fallback: (context) {
            if (state is FilterAppState ||
                state is ChampionshipsDropdownState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Championship'),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 160,
                            child: DropdownButtonFormField(
                              items: cubit.championships,
                              onChanged: (value) {
                                cubit.changeChampionsDropDown(value: value);
                              },
                              iconSize: 20,
                              value: cubit.championshipsDropdownValue,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Event'),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 160,
                            child: DropdownButtonFormField(
                              items: cubit.events,
                              onChanged: (value) {
                                cubit.changeEventDropDown(value: value);
                              },
                              value: cubit.eventsDropdownValue,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: textfield(
                            controller: cubit.swimmerSearchController,
                            type: TextInputType.name,
                            label: "Swimmer Name",
                            prefix: Icons.person,
                            obscure: false,
                            onChange: (value) {
                              cubit.swimmerSearch();
                            }),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        child: const Text("Filter"),
                        onPressed: () {
                          cubit.filter();
                        },
                      ),
                    ],
                  ),
                  const Center(child: Text("No Results"))
                ]),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          builder: (context) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 2,
              title: const Text(
                "Championships",
                style: TextStyle(color: Colors.blue),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (userData['user_type'] == 'Assitant' ||
                        userData['user_type'] == 'Coach') {
                      showDialog(
                        context: context,
                        builder: (dialogcontext) => AlertDialog(
                            content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFieldSearch(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.black45,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                label: "Swimmer Name",
                                initialList: swimmerNames,
                                controller:
                                    cubit.swimmerChampionResultSearchController,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Championship'),
                              const SizedBox(
                                height: 1,
                              ),
                              Container(
                                width: 250,
                                child: DropdownButtonFormField(
                                  items: cubit.championships,
                                  onChanged: (value) {
                                    cubit.changeChampionsDropDown(value: value);
                                  },
                                  iconSize: 20,
                                  value: cubit.championshipsDropdownValue,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)))),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text('Event'),
                              const SizedBox(
                                height: 1,
                              ),
                              Container(
                                width: 250,
                                child: DropdownButtonFormField(
                                  items: cubit.events,
                                  onChanged: (value) {
                                    cubit.changeEventDropDown(value: value);
                                  },
                                  value: cubit.eventsDropdownValue,
                                  decoration: const InputDecoration(
                                      hintText: "Event",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)))),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text('Score'),
                              const SizedBox(
                                height: 1,
                              ),
                              textfield(
                                  controller: cubit.championResultTimeContoller,
                                  type: TextInputType.datetime,
                                  // label: "Score",
                                  hint: "mm:ss:ms",
                                  prefix: Icons.alarm,
                                  obscure: false),
                              const SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                  onPressed: () {
                                    cubit.addChampioshipResult().then((value) {
                                      Navigator.pop(dialogcontext);
                                    });
                                  },
                                  child: const Text("Add"))
                            ],
                          ),
                        )),
                      );
                    } else {
                      showToast(
                          msg: "You're not Authorized to Add a result",
                          state: ToastStates.WARNING);
                    }
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.blue,
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Championship'),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 160,
                            child: DropdownButtonFormField(
                              items: cubit.championships,
                              onChanged: (value) {
                                cubit.changeChampionsDropDown(value: value);
                              },
                              iconSize: 20,
                              value: cubit.championshipsDropdownValue,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6)))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Event'),
                          const SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 160,
                            child: DropdownButtonFormField(
                              items: cubit.events,
                              onChanged: (value) {
                                cubit.changeEventDropDown(value: value);
                              },
                              value: cubit.eventsDropdownValue,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6)))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: textfield(
                            controller: cubit.swimmerSearchController,
                            type: TextInputType.name,
                            label: "Swimmer Name",
                            prefix: Icons.person,
                            obscure: false,
                            onChange: (value) {
                              cubit.swimmerSearch();
                            }),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        child:const Text("Filter"),
                        onPressed: () {
                          cubit.filter();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => championShipResult(
                          resData: cubit.championshipResults[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: cubit.championshipResults.length)
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
