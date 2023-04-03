import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscription_states.dart';
import 'package:sba7/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit() : super(SubscriptionInitState());

  get allsubs => null;
  static SubscriptionCubit get(context) => BlocProvider.of(context);

  var supabase = Supabase.instance.client;
  TextEditingController swimmerFilterController = TextEditingController();

  List years = [];

  List<DropdownMenuItem> yearsDropdown = [];

  List<DropdownMenuItem> monthsDropdown = const [
    DropdownMenuItem(
      value: 0,
      child: Text('January'),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text('February'),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text('March'),
    ),
    DropdownMenuItem(
      value: 3,
      child: Text('April'),
    ),
    DropdownMenuItem(
      value: 4,
      child: Text('May'),
    ),
    DropdownMenuItem(
      value: 5,
      child: Text('June'),
    ),
    DropdownMenuItem(
      value: 6,
      child: Text('July'),
    ),
    DropdownMenuItem(
      value: 7,
      child: Text('August'),
    ),
    DropdownMenuItem(
      value: 8,
      child: Text('September'),
    ),
    DropdownMenuItem(
      value: 9,
      child: Text('October'),
    ),
    DropdownMenuItem(
      value: 10,
      child: Text('November'),
    ),
    DropdownMenuItem(
      value: 11,
      child: Text('December'),
    )
  ];

  List allSubs = [];

  void getSubscription() {
    supabase
        .from('subscription')
        .select('year,month,users(full_name,profile_picture,birth_date),amount')
        .order('year', ascending: true)
        .then((value) {
      allSubs = value;
      int x = 0;
      for (var i in value) {
        if (years.contains(i['year'])) {
        } else {
          years.add(i['year']);
          yearsDropdown.add(DropdownMenuItem(
            value: x,
            child: Text(
              i['year'].toString(),
            ),
          ));
          x += 1;
        }
      }
      monthDropdownValue = DateTime.now().month - 1;
      yearDropdownValue = years.indexOf(DateTime.now().year);
      print(value);
      emit(GetSubscriptionSuccessState());
    }).catchError((onError) {
      print(onError);
      emit(GetSubscriptionErrorState());
    });
  }

  List lol = [];
  void filter() {
    lol = allSubs
        .where((element) =>
            element['year'] == years[yearDropdownValue!] &&
            element['month'] == fullMonths[monthDropdownValue as int])
        .toList();
    print(lol);
  }

  int? yearDropdownValue = 0;
  void yearfilterDropdown({required int? value}) {
    yearDropdownValue = value;
    emit(SubscriptionChangeDropDownState());
  }

  int? monthDropdownValue = 0;
  void monthfilterDropdown({required int? value}) {
    monthDropdownValue = value;
    emit(SubscriptionChangeDropDownState());
  }
}
