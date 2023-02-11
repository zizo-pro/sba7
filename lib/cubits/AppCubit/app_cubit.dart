import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
    var l = await selectMultiSupa(table: "trainings", columns: "");
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
}
