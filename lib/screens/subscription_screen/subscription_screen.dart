import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscription_states.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscrition_cubit.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionCubit, SubscriptionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SubscriptionCubit.get(context);
        return Scaffold(
            // backgroundColor: Colors.grey,
            appBar: AppBar(),
            body: ConditionalBuilder(
              condition: cubit.allSubs.isNotEmpty,
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[500] as Color,
                                  blurRadius: 10,
                                  blurStyle: BlurStyle.outer,
                                  spreadRadius: 0,
                                  offset: const Offset(-1, -1)),
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text(cubit.dateController.text)],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Total:',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${cubit.sum.toString()} \$",
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'No. of Swimmers:',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              cubit.lol
                                                  .where((element) =>
                                                      element['amount'] > 0)
                                                  .toList()
                                                  .length
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ]),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.filter_alt_outlined,
                                      color: Colors.blue,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Filter"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(children: [
                                                Expanded(
                                                    child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      cubit.dateController,
                                                  decoration: const InputDecoration(
                                                      labelText: "Date",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          6)))),
                                                  onTap: () => showMonthPicker(
                                                    context: context,
                                                    initialDate: DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month),
                                                    firstDate:
                                                        DateTime(2000, 01, 01),
                                                    lastDate:
                                                        DateTime(2040, 01, 01),
                                                  ).then((DateTime? value) {
                                                    cubit.dateSelect(value);
                                                  }),
                                                )),
                                              ]),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: cubit
                                                      .swimmerSearchController,
                                                  decoration: const InputDecoration(
                                                      labelText: "Swimmer Name",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          6)))),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  cubit.filter();
                                                },
                                                child: const Text("Filter"),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Paid",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                        children: List.generate(
                            cubit.lol
                                .where((element) => element['amount'] > 0)
                                .toList()
                                .length,
                            (index) => subscriptionItemBuiler(cubit.lol
                                .where((element) => element['amount'] > 0)
                                .toList()[index])),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Didn't Pay",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                        children: List.generate(
                            cubit.lol
                                .where((element) => element['amount'] == 0)
                                .toList()
                                .length,
                            (index) => subscriptionItemBuiler(cubit.lol
                                .where((element) => element['amount'] == 0)
                                .toList()[index])),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
