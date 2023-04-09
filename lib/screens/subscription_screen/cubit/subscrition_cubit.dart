import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscription_states.dart';
import 'package:sba7/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit() : super(SubscriptionInitState());

  static SubscriptionCubit get(context) => BlocProvider.of(context);
  TextEditingController dateController = TextEditingController();
  var supabase = Supabase.instance.client;

  TextEditingController swimmerFilterController = TextEditingController();
  TextEditingController swimmerSearchController = TextEditingController();

  List allSubs = [];

  void getSubscription() {
    dateController.text =
        "${fullMonths[DateTime.now().month - 1]} ${DateTime.now().year}";
    supabase
        .from('subscription')
        .select('date,users(full_name,profile_picture,birth_date,uid),amount')
        .order('id', ascending: true)
        .then((value) {
      allSubs = value;

      lol = allSubs
          .where((element) => element['date'] == dateController.text)
          .toList();
      sum = lol.fold(0, (acc, transaction) => acc + transaction['amount']);
      print(value);
      emit(GetSubscriptionSuccessState());
    }).catchError((onError) {
      print(onError);
      emit(GetSubscriptionErrorState());
    });
  }

  List lol = [];
  num sum = 0;
  void filter() {
    if (swimmerSearchController.text == '') {
      lol = allSubs
          .where((element) => element['date'] == dateController.text)
          .toList();
      mergeLists(swimmers, lol);
    } else {
      lol = allSubs
          .where((element) =>
              element['date'] == dateController.text &&
              element['users']['full_name']
                  .toUpperCase()
                  .contains(swimmerSearchController.text.toUpperCase()))
          .toList();
      mergeLists(swimmers, lol);
    }
    sum = lol.fold(0, (acc, transaction) => acc + transaction['amount']);

    emit(FilterSubscriptionState());
  }

  void dateSelect(DateTime? value) {
    dateController.text = '${fullMonths[value!.month - 1]} ${value.year}';
    emit(SubscriptionChangeDropDownState());
  }

  void mergeLists(List swimmers, List lol) {
    // Convert list b to a set of uids for faster lookup
    final bUidSet = Set.from(lol.map((e) => e['users']['uid'])).toList();

    // Iterate through list a and add elements from list b that are not in list a
    for (final element in swimmers) {
      if (bUidSet.contains(element['uid'])) {
        log('found ${element["uid"]}');
      } else {
        lol.add({
          "date": dateController.text,
          'amount': 0,
          'users': {
            "full_name": element['full_name'],
            "profile_picture": element['profile_picture'],
            "birth_date": element['birth_date'],
            'uid': element['uid']
          }
        });
      }
    }
  }
}
