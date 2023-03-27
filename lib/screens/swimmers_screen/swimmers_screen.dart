import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';

class SwimmersScreen extends StatelessWidget {
  const SwimmersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined)),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlocConsumer<AppCubit, AppStates>(
                            listener: (context, state) {},
                            builder: (context, state) => AlertDialog(
                              title: const Text("New Swimmers"),
                              content: SingleChildScrollView(
                                child: Column(children: [
                                  ConditionalBuilder(
                                    condition: cubit.notAcc.isNotEmpty,
                                    fallback: (context) =>
                                        const Text('No Swimmers'),
                                    builder: (context) => ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            nonacceptSwimmers(
                                                index: index,
                                                swimmerData:
                                                    cubit.notAcc[index]),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 10),
                                        itemCount: cubit.notAcc.length),
                                  )
                                ]),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
            body: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                children: List.generate(
                    swimmers.length,
                    (index) => swimmerGridItem(
                        userData: swimmers[index], onTap: () {}))),
          );
        });
  }
}
