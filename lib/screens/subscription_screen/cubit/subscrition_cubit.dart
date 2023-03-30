import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/screens/subscription_screen/cubit/subscription_states.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit() : super(SubscriptionInitState());
  static SubscriptionCubit get(context) => BlocProvider.of(context);

  var supabase = Supabase.instance.client;
  TextEditingController swimmerFilterController = TextEditingController();

  void getSubscription() {}

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
