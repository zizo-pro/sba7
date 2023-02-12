import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/Login_Cubit/login_cubit.dart';
import 'package:sba7/cubits/Login_Cubit/login_states.dart';
import 'package:sba7/shared/components.dart';

class CompleteRegisterScreen extends StatelessWidget {
  final String userEmail;
  final String uid;
  CompleteRegisterScreen(
      {super.key, required this.userEmail, required this.uid});
  final List<DropdownMenuItem> ites = const [
    DropdownMenuItem(
      value: 0,
      child: Text("Swimmer"),
    ),
    DropdownMenuItem(
      value: 1,
      child: Text("Coach"),
    ),
    DropdownMenuItem(
      value: 2,
      child: Text("Assistant"),
    )
  ];
  List<String> texts = ["Swimmer", "Coach", "Assistant"];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      " user type",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: double.infinity,
                      child: DropdownButtonFormField(
                          hint: Text("User"),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)))),
                          value: cubit.dropDownValue,
                          items: ites,
                          onChanged: (value) {
                            cubit.changeDropDown(value);
                          }),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      " Birth Date",
                      style: TextStyle(fontSize: 12),
                    ),

                    Container(
                      height: 100,
                      child: CupertinoDatePicker(
                        maximumDate: DateTime.now(),
                        initialDateTime: DateTime(1980, 1, 1),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (value) {
                          cubit.birthDate = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: TextButton(
                            onPressed: () async {
                              await cubit
                                  .updateReg(
                                    birthDate: cubit.birthDate,
                                      uemail: userEmail,
                                      userType: texts[cubit.dropDownValue],
                                      context: context,
                                      uid: uid)
                                  .then((value) => print("done"))
                                  .catchError((onError) {
                                print(onError.toString());
                              });
                            },
                            child: const Text("Continue"))),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
