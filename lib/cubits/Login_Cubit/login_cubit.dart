// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailReg = TextEditingController();
  TextEditingController passwordReg = TextEditingController();
  TextEditingController confirmPassReg = TextEditingController();
  TextEditingController phoneReg = TextEditingController();
  TextEditingController teamCodeReg = TextEditingController();
  List<String> teamCodes = [];
  List<Map<String, dynamic>> emails = [];

  void getTeamCodes() async {
    List<dynamic> codes = await supabase.from("teams").select('id');
    codes.forEach((element) {
      teamCodes.add(element['id'].toString());
    });
  }

  void getEmail() async {
    List<dynamic> email =
        await supabase.from("users").select('email,isComplete');
    email.forEach((element) {
      emails.add(element);
    });
  }

  void userLogin({required email, required password, context}) {
    log(emails.toString());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emails.forEach((element) {
        log(element['email']);
        print(email);
        if (email == element['email']) {
          print(element);
          if (element['isComplete'] == true) {
            CacheHelper.saveData(key: "token", value: value.user!.uid);
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
          firstName: firstName.text,
          lastName: lastName.text,
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
    required firstName,
    required lastName,
    required email,
    required phone,
    required uId,
    required context,
    required code,
  }) async {
    emit(CreateUserLoadingState());
    UserModel model = UserModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        uId: uId,
        code: code);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) async {
      await Supabase.instance.client.from('users').insert([
        {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'uid': uId,
          'team_code': code,
          'isComplete': false
        }
      ]).then((value) {
        token = uId;
        teamCode = code;
        navigateAndFinish(context, MyHomePage());
        emit(CreateUserSuccessState());
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
      {required userType, required uemail, context, required uid}) async {
    print(uemail);
    var data = await Supabase.instance.client
        .from('users')
        .update({"isComplete": true, 'user_type': userType})
        .eq("email", uemail)
        .then((value) {
          CacheHelper.saveData(key: 'token', value: uid);
        })
        .catchError((onError) {
          print(onError.toString());
        })
        .then((value) => navigateAndFinish(context, MyHomePage()));

    //
  }
}
