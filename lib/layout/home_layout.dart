import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/shared/constants.dart';

class MyHomePage extends StatelessWidget {
  final String? userEmail;
  const MyHomePage({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    if (userData['user_type'] != "Swimmer") {
      AppCubit.get(context).getSwimmers();
    } else {
      swimmers = [];
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: userData != null,
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          builder: (context) => Scaffold(
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.black,
                unselectedFontSize: 12,
                onTap: (value) {
                  cubit.changeBottomNav(value: value);
                },
                currentIndex: cubit.currentIndex,
                items: cubit.bottomNavItems),
          ),
        );
      },
    );
  }
}
