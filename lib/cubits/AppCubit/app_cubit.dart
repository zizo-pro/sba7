import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sba7/cubits/AppCubit/app_states.dart';
import 'package:sba7/cubits/Login_Cubit/login_states.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);
  final supabase = Supabase.instance.client;
  TabController tabController = TabController(length: 2,vsync: this);

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
      print(onError.toString());
      emit(AppGetTrainingErrorState());
    });
    return lol;
  }

  List<dynamic> upcomingTrain = [];
  List<dynamic> beforeTrain = [];
  void getTraining() async {
    var l = await selectMultiSupa(table: "trainings", columns: "");
    print(l);
    l.forEach((element) {
      if (DateTime.parse(element['date']).isAfter(DateTime.now())) {
        upcomingTrain.add(element);
      } else if (DateTime.parse(element['date']).isBefore(DateTime.now())) {
        beforeTrain.add(element);
      }
    });
    emit(AppGetTrainingSuccessState());
  }

//   void test() {
//     print(DateFormat("EEE").format(DateTime.now()));
//     for (var i = 1; i < 100; i++) {
//       print((DateFormat("EEE")
//           .format(DateTime.now().add(Duration(days: 7 * i)))));
//     }
//   }
}
