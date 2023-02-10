import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sba7/cubits/Login_Cubit/login_cubit.dart';
import 'package:sba7/cubits/Login_Cubit/login_states.dart';
import 'package:sba7/screens/register_screen/complete_regestiration_screen.dart';
import 'package:sba7/shared/components.dart';

// @Zizo2412@!
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var kay = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            body: Form(
              key: kay,
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textfield(
                            controller: cubit.firstName,
                            type: TextInputType.name,
                            label: "First Name",
                            prefix: Icons.person,
                            obscure: false,
                            validate: (value) {
                              if (cubit.firstName.text.isNotEmpty) {
                                return null;
                              } else {
                                return "Please Enter your name";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          textfield(
                            controller: cubit.lastName,
                            type: TextInputType.name,
                            label: "Last Name",
                            prefix: Icons.person,
                            obscure: false,
                            validate: (value) {
                              if (cubit.lastName.text.isNotEmpty) {
                                return null;
                              } else {
                                return "Please Enter your last name";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          textfield(
                            controller: cubit.emailReg,
                            type: TextInputType.emailAddress,
                            label: "Email",
                            prefix: Icons.email,
                            obscure: false,
                            validate: (value) {
                              if (cubit.emailReg.text.isNotEmpty &
                                  cubit.emailReg.text.contains("@")) {
                                return null;
                              } else {
                                return "Please Enter a valid email";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          textfield(
                            controller: cubit.passwordReg,
                            type: TextInputType.visiblePassword,
                            label: "Password",
                            prefix: Icons.lock,
                            obscure: true,
                            validate: (value) {
                              if ((cubit.passwordReg.text.length > 7) &
                                  (cubit.confirmPassReg.text ==
                                      cubit.passwordReg.text)) {
                                return null;
                              } else if (cubit.passwordReg.text.length < 8) {
                                return "Password is too short";
                              } else if (cubit.passwordReg.text !=
                                  cubit.confirmPassReg.text) {
                                return "Please confirm your password";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          textfield(
                            controller: cubit.confirmPassReg,
                            type: TextInputType.visiblePassword,
                            label: "Confirm Password",
                            prefix: Icons.lock,
                            obscure: true,
                            validate: (value) {
                              if ((cubit.confirmPassReg.text.length > 7) &
                                  (cubit.confirmPassReg.text ==
                                      cubit.passwordReg.text)) {
                                return null;
                              } else if (cubit.confirmPassReg.text.length < 8) {
                                return "Password is too short";
                              } else if (cubit.passwordReg.text !=
                                  cubit.confirmPassReg.text) {
                                return "Please confirm your password";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          textfield(
                              controller: cubit.phoneReg,
                              type: TextInputType.phone,
                              label: "Phone Number",
                              prefix: Icons.phone,
                              obscure: false,
                              validate: (value) {
                                if (cubit.phoneReg.text.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'Please enter a valid phone number';
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          textfield(
                              controller: cubit.teamCodeReg,
                              type: TextInputType.phone,
                              label: "Team Code",
                              prefix: Icons.people,
                              obscure: false,
                              validate: (value) {
                                if (cubit.teamCodes
                                    .contains(cubit.teamCodeReg.text)) {
                                  return null;
                                } else {
                                  return "Please enter a valid team code";
                                }
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                              onPressed: () {
                                if (kay.currentState!.validate()) {
                                  cubit.userRegister(context: context);
                                  
                                }
                              },
                              child: const Text("Register")),
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
