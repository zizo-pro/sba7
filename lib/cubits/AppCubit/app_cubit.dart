// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/screens/profile_screen/profile_screen.dart';
import 'package:sba7/screens/train_screen/train_screen.dart';
import 'package:sba7/shared/cache_helper.dart';
import 'package:sba7/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);
  final supabase = Supabase.instance.client;
  // TabController tabController = TabController(length: 2,vsync: this);

  void reset(){
    // resetting the cubit
  }
  List screens = [const TrainScreen(), ProfileScreen()];
  int currentIndex = 0;
  void changeBottomNav({required int value}) {
    currentIndex = value;
    emit(AppChagneBottomNavBarState());
  }

  selectMultiSupa(
      {required String table,
      required String columns,
      String filterCol = '',
      String filterVal = ''}) async {
    var lol = await supabase
        .from(table)
        .select(columns)
        .eq(filterCol, filterVal)
        .catchError((onError) {
      emit(AppGetTrainingErrorState());
    });
    return lol;
  }

  List<dynamic> upcomingTrain = [];
  List<dynamic> beforeTrain = [];
  void getTraining() async {
    var l = await supabase
        .from('trainings')
        .select()
        .eq('team', userData["team_code"]);
    l.forEach((element) {
      if (DateTime.parse(element['date']).isAfter(DateTime.now())) {
        upcomingTrain.add(element);
      } else if (DateTime.parse(element['date']).isBefore(DateTime.now())) {
        beforeTrain.add(element);
      }
    });
    emit(AppGetTrainingSuccessState());
  }

  File? profileimage;
  final picker = ImagePicker();

  Future<void> getprofileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileimage = File(pickedFile.path);
      uploadProfileImage();
      emit(AppProfileImagePickerSuccessState());
    } else {
      emit(AppProfileImagePickerErrorState());
    }
  }

  void uploadProfileImage() {
    emit(AppUploadProfilePhototLoadingState());
    FirebaseStorage.instance
        .ref()
        .child(
            'user_profiles/${Uri.file(profileimage!.path).pathSegments.last}')
        .putFile(profileimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        supabase
            .from('users')
            .update({'profile_picture': value})
            .eq("email", userData['email'])
            .then((value) => getUserData(email: userData['email']));
      }).catchError((onError) {
        emit(AppUploadProfilePhototErrorState());
      });
      emit(AppUploadProfilePhototSuccessState());
    }).catchError((onError) {
      emit(AppUploadProfilePhototErrorState());
    });
  }

  void getUserData({required email}) async {
    var userDatal = await supabase.from("users").select().eq('email', email);
    CacheHelper.saveData(key: "userData", value: userDatal[0]);
    userData = userDatal[0];
    emit(AppUpdateUserDataState());
  }

// Attendance area
  Color? wrongColor = Colors.grey;
  Color? rightColor = Colors.grey;

  void getSwimmers() async {
    var swims = await supabase
        .from('users')
        .select()
        .eq('user_type', "Swimmer")
        .eq("team_code", userData["team_code"]);
    log(swims.toString());
    swimmers = swims;
  }

  Map attendance = {};
  void attendanceMap({required userID, required attented}) {
    attendance[userID] = attented;
    emit(AppAttendanceChangeBool());
  }

  bool checkAttendance = false;
  List ifAttendance = [];
  void testio({required trainingID}) {
    supabase
        .from("attendance")
        .select('user_id,attended,users(full_name,birth_date,profile_picture)')
        .eq("training_id", trainingID)
        .catchError((onError) {
      print(onError.toString());
    }).then((value) {
      print(value);
      if (value.isEmpty) {
        checkAttendance = false;
      } else {
        checkAttendance = true;
        ifAttendance = value;
      }
      log(checkAttendance.toString());
    });
  }

  void submitAttenddance({required trainingID}) {
    if (attendance.length == swimmers.length) {
      attendance.forEach((key, value) {
        supabase
            .from('attendance')
            .insert(
                {"user_id": key, "training_id": trainingID, "attended": value})
            .then((value) {})
            .catchError((onError) {
              log(onError.toString());
            });
      });
    } else {
      log("false");
    }
  }
}
