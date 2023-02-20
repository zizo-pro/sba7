import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/components.dart';

class ChampionshipScreen extends StatelessWidget {
  const ChampionshipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Scaffold(
            body: Column(children: [
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
              textfield(
                  controller: cubit.swimmerSearchController,
                  type: TextInputType.name,
                  label: "Swimmer Name",
                  prefix: Icons.person,
                  obscure: false,
                  onChange: (value) {
                    cubit.swimmerSearch();
                  }),
            ]),
          ),
        ));
      },
    );
  }
}
