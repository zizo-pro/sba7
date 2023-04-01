import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscription_states.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscrition_cubit.dart';

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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                      child: Row(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '1500\$',
                                      style: TextStyle(
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
                                  children: const [
                                    Text(
                                      'No. of Swimmers:',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '10',
                                      style: TextStyle(
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
                                          child: DropdownButtonFormField(
                                              iconSize: 21,
                                              value: cubit.yearDropdownValue,
                                              onChanged: (value) {
                                                cubit.yearfilterDropdown(
                                                    value: value);
                                              },
                                              hint: const Text("Year"),
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6)))),
                                              items: cubit.yearsDropdown),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: DropdownButtonFormField(
                                              iconSize: 21,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              value: cubit.monthDropdownValue,
                                              onChanged: (value) {
                                                cubit.monthfilterDropdown(
                                                    value: value);
                                              },
                                              hint: const Text("Month"),
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6)))),
                                              items: cubit.monthsDropdown),
                                        ),
                                      ]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: "Swimmer Name",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(6)))),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
