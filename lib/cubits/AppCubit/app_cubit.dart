// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/screens/championship_screen/championship_screen.dart';
import 'package:sba7/screens/profile_screen/profile_screen.dart';
import 'package:sba7/screens/swimmers_admin_screen/swimmer_admin_screen.dart';
import 'package:sba7/screens/train_screen/train_screen.dart';
import 'package:sba7/shared/cache_helper.dart';
import 'package:sba7/shared/constants.dart';
import 'package:sba7/shared/custom_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);
  final supabase = Supabase.instance.client;
  // TabController tabController = TabController(length: 2,vsync: this);

  void reset() {
    currentIndex = 0;
  }

  void init() {
    if (userData['user_type'] == "Coach") {
      screens.insert(1, const SwimmerAdminScreen());
      bottomNavItems.insert(
          1,
          const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings_outlined), label: "Admin"));
    }
  }

  List<BottomNavigationBarItem> bottomNavItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trainings"),
    const BottomNavigationBarItem(
        icon: Icon(CustomIcons.medal), label: "Championships"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.person_rounded), label: "Profile"),
  ];
  List screens = [TrainScreen(), const ChampionshipScreen(), ProfileScreen()];
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
  List<dynamic> todayTrain = [];
  void getTraining() async {
    beforeTrain = [];
    todayTrain = [];
    upcomingTrain = [];
    var l = await supabase
        .from('trainings')
        .select('id,team,date,training_locations(id,location,maps)')
        .eq('team', userData["team_code"])
        .order('date', ascending: true);
    l.forEach((element) {
      if (DateTime.parse(element['date']).isAfter(DateTime.now())) {
        if (DateTime.parse(element['date']).day == DateTime.now().day &&
            DateTime.parse(element['date']).month == DateTime.now().month &&
            DateTime.parse(element['date']).month == DateTime.now().month &&
            DateTime.parse(element['date']).year == DateTime.now().year &&
            DateTime.parse(element['date']).hour >= DateTime.now().hour) {
          todayTrain.add(element);
        } else {
          upcomingTrain.add(element);
        }
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
  List notAcc = [];
  void getSwimmers() async {
    swimmerNames = [];
    notAcc = [];
    swimmers = [];
    var swims = await supabase
        .from('users')
        .select()
        .eq('user_type', "Swimmer")
        .eq("team_code", userData["team_code"]);
    // log(swims.toString());
    if (userData['user_type'] == 'Coach') {
      for (var i in swims) {
        if (i['isAccepted'] == false) {
          notAcc.add(i);
        } else {
          swimmerNames
              .add("${i['full_name']} ${DateTime.parse(i['birth_date']).year}");
          swimmers.add(i);
        }
      }
    } else {
      for (var i in swims) {
        swimmerNames
            .add("${i['full_name']} ${DateTime.parse(i['birth_date']).year}");
      }
    }
  }

  Map attendance = {};
  void attendanceMap({required userID, required attented}) {
    attendance[userID] = attented;

    emit(AppAttendanceChangeBool());
  }

  void updateAttendance({required userID, required attented}) {
    attendance.update(userID, (value) => attented);
    emit(AppAttendanceEditState());
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
      if (value.isEmpty) {
        checkAttendance = false;
      } else {
        for (dynamic i in value) {
          attendance[i['user_id']] = i['attended'];
        }
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
  void editAttendance({required trainingId, required BuildContext context}) {
    isEdit = !isEdit;
    if (isEdit == false) {
      supabase
          .from("attendance")
          .delete()
          .eq("training_id", trainingId)
          .then((value) {
        if (attendance.length == swimmers.length) {
          attendance.forEach((key, value) {
            supabase
                .from('attendance')
                .insert({
                  "user_id": key,
                  "training_id": trainingId,
                  "attended": value
                })
                .then((value) {})
                .catchError((onError) {
                  log(onError.toString());
                });
          });
        } else {}
      }).catchError((onError) => print(onError.toString()));
      Navigator.pop(context);
      Navigator.pop(context);
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
      events.add(const DropdownMenuItem(
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

  // add Training area

  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;
  void bottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  List<DropdownMenuItem<int>> dropLocations = [];
  List locations = [];
  void getLocations() {
    supabase
        .from("training_locations")
        .select("id,location,maps")
        .then((value) {
      locations = value;
      int x = 0;
      value.forEach((element) {
        dropLocations.add(DropdownMenuItem(
          value: x,
          child: Text(element['location']),
        ));
        x += 1;
      });
    });
  }

  int dropDownValue = 0;
  void weekDaysDropDown({required int value}) {
    dropDownValue = value;
    emit(AddTrainingDropDownState());
  }

  int? locationdropDownValue = 0;
  void locationDropDown({required int? value}) {
    locationdropDownValue = value;
    emit(AddTrainingDropDownState());
  }

  dynamic rad = 0;
  bool isRepeat = true;
  void radioButton(value) {
    rad = value;
    if (value == 0) {
      isRepeat = true;
    } else {
      isRepeat = false;
    }
    emit(AddTrainingRadioState());
  }

  void addOneTraining({required date, required time, required location}) {
    if (isRepeat) {
      DateTime? nextweekday;
      DateTime now = DateTime.now();
      if (date == 'Sunday') {
        nextweekday =
            now.add(Duration(days: (DateTime.sunday - now.weekday) % 7));
      } else if (date == 'Monday') {
        nextweekday =
            now.add(Duration(days: (DateTime.monday - now.weekday) % 7));
      } else if (date == 'Tuesday') {
        nextweekday =
            now.add(Duration(days: (DateTime.tuesday - now.weekday) % 7));
      } else if (date == 'Wednesday') {
        nextweekday =
            now.add(Duration(days: (DateTime.wednesday - now.weekday) % 7));
      } else if (date == 'Thursday') {
        nextweekday =
            now.add(Duration(days: (DateTime.thursday - now.weekday) % 7));
      } else if (date == 'Firday') {
        nextweekday =
            now.add(Duration(days: (DateTime.friday - now.weekday) % 7));
      } else if (date == 'Saturday') {
        nextweekday =
            now.add(Duration(days: (DateTime.saturday - now.weekday) % 7));
      }

      // DateTime nextweekday =
      //     now.add(Duration(days: (DateTime. - now.weekday) % 7));

      for (int i = 0; i < 250; i++) {
        supabase
            .from("trainings")
            .insert({
              'date': nextweekday!.add(Duration(days: 7 * i)).toString(),
              "team": teamCode,
              "location": location
            })
            .then((value) => print("done"))
            .catchError((onError) {
              print(onError.toString());
            });
      }
    } else {
      supabase.from("trainings").insert({
        'date': DateFormat("yyyy-MM-dd hh:mm").parse("$date $time").toString(),
        "team": teamCode,
        "location": location
      }).then((value) {
        getTraining();
      }).catchError((onError) => print(onError.toString()));
    }
  }

  void acceptSwimmer({required isAccepted, required id, index}) {
    if (isAccepted) {
      supabase
          .from('users')
          .update({'isAccepted': true})
          .eq('uid', id)
          .then((value) => print("done"))
          .catchError((onError) {
            print(onError.toString());
          });
    } else {
      supabase.from('users').delete().eq('uid', id)
          .then((value) => print("done"))
          .catchError((onError) {
        print(onError.toString());
      });
      ;
    }
    notAcc.removeAt(index);
    emit(AcceptSwimmerState());
  }
}
