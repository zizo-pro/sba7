// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/Login_Cubit/login_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sba7/layout/home_layout.dart';
import 'package:sba7/models/user_model.dart';
import 'package:sba7/screens/register_screen/complete_regestiration_screen.dart';
import 'package:sba7/shared/components.dart';
import 'package:sba7/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sba7/shared/cache_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());
  static LoginCubit get(context) => BlocProvider.of(context);
  final supabase = Supabase.instance.client;

  TextEditingController LoginText = TextEditingController();
  TextEditingController PasswordText = TextEditingController();

  TextEditingController fullName = TextEditingController();
  TextEditingController emailReg = TextEditingController();
  TextEditingController passwordReg = TextEditingController();
  TextEditingController confirmPassReg = TextEditingController();
  TextEditingController phoneReg = TextEditingController();
  TextEditingController teamCodeReg = TextEditingController();
  DateTime birthDate = DateTime(1980, 1, 1);
  List<String> teamCodes = [];
  List<Map<String, dynamic>> emails = [];

  void getTeamCodes() async {
    List<dynamic> codes = await supabase.from("teams").select('id');
    codes.forEach((element) {
      teamCodes.add(element['id'].toString());
    });
  }

  void getEmail() async {
    List<dynamic> email = await supabase.from("users").select();
    email.forEach((element) {
      emails.add(element);
    });
  }

  void getUserData({required email}) async {
    var userDatal = await supabase.from("users").select().eq('email', email);
    CacheHelper.saveData(key: "userData", value: userDatal[0]);
    userData = userDatal[0];
  }

  void userLogin({required email, required password, context}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emails.forEach((element) {
        if (email == element['email']) {
          if (element['isComplete'] == true) {
            CacheHelper.saveData(key: "token", value: value.user!.uid);
            CacheHelper.saveData(key: "userAuth", value: element['user_type']);
            CacheHelper.saveData(key: "team_code", value: element['team_code']);
            userAuth = element['user_type'];
            teamCode = element['team_code'];
            getUserData(email: email);
            navigateAndFinish(context, const MyHomePage());
            emit(LoginSuccessState());
          } else {
            navigateTo(
                context,
                CompleteRegisterScreen(
                  userEmail: LoginText.text,
                  uid: value.user!.uid,
                ));
          }
        }
      });
      token = value.user!.uid;
      print("logged succ");
    }).catchError((onError) {
      print(onError.toString());
      emit(LoginErrorState());
    });
  }

  late String uID;
  void userRegister({required context}) {
    emit(UserRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailReg.text, password: passwordReg.text)
        .then((value) async {
      uID = value.user!.uid;
      navigateAndFinish(
          context,
          CompleteRegisterScreen(
            userEmail: emailReg.text,
            uid: value.user!.uid,
          ));
      await userCreate(
          fullName: fullName.text,
          email: emailReg.text,
          phone: phoneReg.text,
          uId: uID,
          context: context,
          code: teamCodeReg.text);
      emit(UserRegisterSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(UserRegisterErrorState());
    });
  }

  Future<void> userCreate({
    required fullName,
    required email,
    required phone,
    required uId,
    required context,
    required code,
  }) async {
    emit(CreateUserLoadingState());
    UserModel model = UserModel(
        fullName: fullName,
        email: email,
        phone: phone,
        uId: uId,
        profilePic:
            'https://firebasestorage.googleapis.com/v0/b/sba7-ed3fd.appspot.com/o/user_profiles%2Fdefault%2Fuser.png?alt=media&token=ed7c16f0-2765-48b3-ba8b-c21938d2d156',
        code: code);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) async {
      await Supabase.instance.client.from('users').insert([
        {
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'uid': uId,
          'team_code': code,
          'isComplete': false,
          'profile_picture':
              "https://firebasestorage.googleapis.com/v0/b/sba7-ed3fd.appspot.com/o/user_profiles%2Fdefault%2Fuser.png?alt=media&token=ed7c16f0-2765-48b3-ba8b-c21938d2d156"
        }
      ]).then((value) {
        token = uId;
        teamCode = code;
        navigateAndFinish(context, MyHomePage());
        emit(CreateUserSuccessState());
        log("created user succ");
      }).catchError((onError) => print(onError.toString()));
    }).catchError((onError) {
      print(onError.toString());
      emit(CreateUserErrorState());
    });
  }

  int dropDownValue = 0;
  void changeDropDown(int newVal) {
    dropDownValue = newVal;
    emit(RegisterDropDownChange());
  }

  Future<void> updateReg(
      {required userType,
      required uemail,
      context,
      required uid,
      required DateTime birthDate}) async {
    print(uemail);
    var data = await Supabase.instance.client
        .from('users')
        .update({
          "isComplete": true,
          'user_type': userType,
          'birth_date': DateFormat('yyyy-MM-dd').format(birthDate)
        })
        .eq("email", uemail)
        .then((value) {
          CacheHelper.saveData(key: 'token', value: uid);
        })
        .catchError((onError) {
          print(onError.toString());
        })
        .then((value) {
          userAuth = userType;
          getUserData(email: uemail);
          CacheHelper.saveData(key: "userAuth", value: userType);
          navigateAndFinish(context, MyHomePage());
        });
  }
}
