// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/AppCubit/app_cubit.dart';
import 'package:sba7/cubits/ChatCubit/chat_cubit.dart';
import 'package:sba7/cubits/Login_Cubit/login_cubit.dart';
import 'package:sba7/cubits/Login_Cubit/login_states.dart';
import 'package:sba7/layout/home_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sba7/screens/login_screen/login_screen.dart';
import 'package:sba7/screens/not_accepted_screen/not_accepted_screen.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscrition_cubit.dart';
import 'package:sba7/screens/subscription_screen/subscription_screen.dart';
import 'package:sba7/shared/bloc_observer.dart';
import 'package:sba7/shared/cache_helper.dart';
import 'package:sba7/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: "https://dclcrgiqacpenmbtvdnr.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjbGNyZ2lxYWNwZW5tYnR2ZG5yIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzUwOTgyMzEsImV4cCI6MTk5MDY3NDIzMX0.wWRyj2yKFKURYk_Pty0QKMm2LJUXCzfaN8S2c3SffMc");
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  await CacheHelper.init();

  Widget widget;
  token = CacheHelper.getData(key: 'token');
  teamCode = CacheHelper.getData(key: 'team_code');
  userAuth = CacheHelper.getData(key: 'userAuth');
  dynamic userdal = CacheHelper.getData(key: 'userData');
  if (userdal != null) {
    userData = json.decode(userdal);
  }
  if (token != null) {
    await Supabase.instance.client.from("users").select().eq('uid', token).then(
      (value) {
        userData = value[0];
      },
    );
    if (userData['user_type'] == "Coach") {
      
      widget = MyHomePage(userEmail: userData['email']);
    } else {
      if (userData['isAccepted'] == true) {
        widget = MyHomePage(userEmail: userData['email']);
      } else {
        widget = const NotAcceptedScreen();
      }
    }
  } else {
    widget = const LoginScreen();
  }

  BlocOverrides.runZoned(() {
    runApp(MyApp(startWidget: widget));
  }, blocObserver: MyBlocObserver());
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;
  const MyApp({super.key, this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginCubit()
              ..getTeamCodes()
              ..getEmail(),
          ),
          BlocProvider(
            create: (context) => AppCubit()
              ..getTraining()
              ..getUserData(email: userData['email'])
              ..init()
              ..getLocations(),
          ),
          BlocProvider(create: (context) => SubscriptionCubit()
                ..getSubscription()),
                BlocProvider(create: (context) => ChatCubit(),)
        ],
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(home: startWidget);
          },
        ));
  }
}
