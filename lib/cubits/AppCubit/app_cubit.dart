// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/screens/championship_screen/championship_screen.dart';
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

  void reset() {
    currentIndex = 0;
  }

  List screens = [
    const TrainScreen(),
    const ChampionshipScreen(),
    ProfileScreen()
  ];
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

  Future<void> getUserData({required email}) async {
    var userDatal = await supabase.from("users").select().eq('email', email);
    CacheHelper.saveData(key: "userData", value: userDatal[0]);
    userData = userDatal[0];
    emit(AppUpdateUserDataState());
  }

// Attendance area
  Color? wrongColor = Colors.grey;
  Color? rightColor = Colors.grey;

  void getSwimmers() async {
    swimmerNames = [];
    var swims = await supabase
        .from('users')
        .select()
        .eq('user_type', "Swimmer")
        .eq("team_code", userData["team_code"]);
    // log(swims.toString());
    swimmers = swims;
    for (var i in swims) {
      swimmerNames
          .add("${i['full_name']} ${DateTime.parse(i['birth_date']).year}");
    }
  }

  Map attendance = {};
  void attendanceMap({required userID, required attented}) {
    attendance[userID] = attented;
    emit(AppAttendanceChangeBool());
  }

  bool checkAttendance = false;
  List ifAttendance = [];
  void testio({required trainingID}) {
    // ifAttendance = [];
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
        supabase.from('attendance').insert({
          "user_id": key,
          "training_id": trainingID,
          "attended": value
        }).then((value) {
          testio(trainingID: trainingID);
        }).catchError((onError) {
          log(onError.toString());
        });
      });
    } else {
      log("false");
    }
  }

  bool isEdit = false;
  void editAttendance({required trainingId}) {
    print(attendance);
    print(swimmers);
    isEdit = !isEdit;
    if (isEdit == false) {
      supabase
          .from("attendance")
          .delete()
          .eq("training_id", trainingId)
          .then((value) {
        if (attendance.length == swimmers.length) {
          attendance.forEach((key, value) {
            supabase.from('attendance').insert({
              "user_id": key,
              "training_id": trainingId,
              "attended": value
            }).then((value) {
              // testio(trainingID: trainingId);
            }).catchError((onError) {
              log(onError.toString());
            });
          });
        } else {
          log("false");
        }
      }).catchError((onError) => print(onError.toString()));
    }
    emit(AppAttendanceEditState());
  }
  // Finish attendace area

  // Start Championships area
  List championshipsData = [];
  List uneditedChampionResult = [];
  List<DropdownMenuItem> championships = [];
  int championshipsDropdownValue = 0;

  Future<void> changeChampionsDropDown({required int value}) async {
    championshipsDropdownValue = value;
    emit(ChampionshipsDropdownState());
  }

  void filterChampion({required int value}) {
    for (var i in uneditedChampionResult) {
      log("${i['championships']['name']} ${i['championships']['year']}");
      print(
          "${championshipsData[value - 1]['name']} ${championshipsData[value - 1]['year']}");
      if ("${i['championships']['name']} ${i['championships']['year']}" ==
          "${championshipsData[value - 1]['name']} ${championshipsData[value - 1]['year']}") {
        championshipResults.add(i);
      }
    }
  }

  void filterEvent({required int value}) {
    for (var i in uneditedChampionResult) {
      if (i['events']['event'] == eventsData[value - 1]['event']) {
        championshipResults.add(i);
      }
    }
  }

  Future<void> filter() async {
    championshipResults = [];
    if (championshipsDropdownValue == 0 &&
        eventsDropdownValue == 0 &&
        swimmerSearchController.text == '') {
      championshipResults = uneditedChampionResult;
    } else if (championshipsDropdownValue != 0 &&
        eventsDropdownValue == 0 &&
        swimmerSearchController.text == '') {
      filterChampion(value: championshipsDropdownValue);
    } else if (championshipsDropdownValue == 0 &&
        eventsDropdownValue != 0 &&
        swimmerSearchController.text == '') {
      filterEvent(value: eventsDropdownValue);
    } else if (championshipsDropdownValue == 0 &&
        eventsDropdownValue == 0 &&
        swimmerSearchController.text != '') {
      for (var i in uneditedChampionResult) {
        log(i['users']['full_name']
            .contains(swimmerSearchController.text)
            .toString());
        print(swimmerSearchController.text);
        if (i['users']['full_name']
            .toLowerCase()
            .contains(swimmerSearchController.text.toLowerCase())) {
          championshipResults.add(i);
        }
      }
    } else if (championshipsDropdownValue != 0 &&
        eventsDropdownValue != 0 &&
        swimmerSearchController.text == '') {
      for (var i in uneditedChampionResult) {
        if (i['events']['event'] ==
                eventsData[eventsDropdownValue - 1]['event'] &&
            "${i['championships']['name']} ${i['championships']['year']}" ==
                "${championshipsData[championshipsDropdownValue - 1]['name']} ${championshipsData[championshipsDropdownValue - 1]['year']}") {
          championshipResults.add(i);
        }
      }
    } else if (championshipsDropdownValue != 0 &&
        eventsDropdownValue == 0 &&
        swimmerSearchController.text != '') {
      for (var i in uneditedChampionResult) {
        if ("${i['championships']['name']} ${i['championships']['year']}" ==
                "${championshipsData[championshipsDropdownValue - 1]['name']} ${championshipsData[championshipsDropdownValue - 1]['year']}" &&
            i['users']['full_name']
                .toLowerCase()
                .contains(swimmerSearchController.text.toLowerCase())) {
          championshipResults.add(i);
        }
      }
    } else if (championshipsDropdownValue == 0 &&
        eventsDropdownValue != 0 &&
        swimmerSearchController.text != '') {
      for (var i in uneditedChampionResult) {
        if (i['events']['event'] ==
                eventsData[eventsDropdownValue - 1]['event'] &&
            i['users']['full_name']
                .toLowerCase()
                .contains(swimmerSearchController.text.toLowerCase())) {
          championshipResults.add(i);
        }
      }
    } else {
      for (var i in uneditedChampionResult) {
        if (i['events']['event'] ==
                eventsData[eventsDropdownValue - 1]['event'] &&
            i['users']['full_name']
                .toLowerCase()
                .contains(swimmerSearchController.text.toLowerCase()) &&
            "${i['championships']['name']} ${i['championships']['year']}" ==
                "${championshipsData[championshipsDropdownValue - 1]['name']} ${championshipsData[championshipsDropdownValue - 1]['year']}") {
          championshipResults.add(i);
        }
      }
    }
    emit(FilterAppState());
  }

  void checkFilter() {}

  dynamic eventsDropdownValue = 0;
  List<DropdownMenuItem> events = [];
  void changeEventDropDown({required int value}) {
    eventsDropdownValue = value;
    emit(ChampionshipsDropdownState());
  }

  Future<void> getChampionships() async {
    championships = [];
    championshipsData = [];
    await supabase
        .from("championships")
        .select('name,year,month,id')
        .then((value) {
      championshipsData = value;
      int x = 1;
      championships.add(const DropdownMenuItem(
        value: 0,
        child: Text('...'),
      ));
      value.forEach((element) {
        championships.add(
          DropdownMenuItem(
            value: x,
            child: Text("${element['name']} ${element['year']}"),
          ),
        );
        x += 1;
        emit(ChampionGetDataSuccessState());
      });
    }).catchError((onError) => print(onError.toString()));
  }

  List eventsData = [];
  List uneditedEvents = [];
  Future<void> getEvents() async {
    events = [];
    uneditedEvents = [];
    eventsData = [];
    await supabase.from("events").select('event,id').then((value) {
      int x = 1;
      eventsData = value;
      uneditedEvents = value;
      events.add(DropdownMenuItem(
        value: 0,
        child: Text('...'),
      ));
      value.forEach((element) {
        events.add(
          DropdownMenuItem(
            value: x,
            child: Text("${element['event']}"),
          ),
        );
        x += 1;
        emit(EventGetDataSuccessState());
      });
    }).catchError((onError) => print(onError.toString()));
  }

  TextEditingController swimmerSearchController = TextEditingController();
  void swimmerSearch() {
    getChampionshipsResults();
  }

  List championshipResults = [];
  Future<void> getChampionshipsResults() async {
    await supabase
        .from('championship_results')
        .select(
            "users!inner(full_name,birth_date,profile_picture),events(event),championships(name,year),score")
        .eq('users.team_code', userData['team_code'])
        .then((value) {
      championshipResults = value;
      uneditedChampionResult = value;
      log(value.toString());
    });
  }

  TextEditingController swimmerChampionResultSearchController =
      TextEditingController();
  Future<List<String>> addSwimmerResultFilter(filter) async {
    List<String> s = [];
    for (var i in swimmers) {
      if (i['full_name'].toString().toLowerCase().contains(filter)) {
        s.add(i["full_name"]);
      }
    }
    return s;
  }

  TextEditingController championResultTimeContoller = TextEditingController();

  Future<void> addChampioshipResult() async {
    await supabase.from("championship_results").insert({
      "swimmer": swimmers[swimmerNames
          .indexOf(swimmerChampionResultSearchController.text)]['uid'],
      'championship': championshipsData[championshipsDropdownValue - 1]['id'],
      'event': eventsData[eventsDropdownValue - 1]['id'],
      'score': championResultTimeContoller.text
    }).then((value) {
      print("done");
      eventsDropdownValue = 0;
      championshipsDropdownValue = 0;
      swimmerChampionResultSearchController.clear();
      getChampionshipsResults()
          .then((value) => emit(AddChampioshipResultState()));
    }).catchError((onError) => print(onError.toString()));
  }
}
