import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:sba7/cubits/Login_Cubit/login_cubit.dart";
import "package:sba7/cubits/Login_Cubit/login_states.dart";
import "package:sba7/screens/register_screen/register_screen.dart";
import "package:sba7/shared/components.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.)
                textfield(
                    controller: cubit.loginText,
                    type: TextInputType.emailAddress,
                    label: 'Email',
                    obscure: false,
                    prefix: Icons.email),
                const SizedBox(
                  height: 10,
                ),
                textfield(
                    obscure: true,
                    controller: cubit.passwordText,
                    type: TextInputType.visiblePassword,
                    label: 'Password',
                    prefix: Icons.lock),
                const SizedBox(
                  height: 25,
                ),
                TextButton(
                    onPressed: () {
                      cubit.userLogin(
                          email: cubit.loginText.text,
                          password: cubit.passwordText.text,
                          context: context);
                    },
                    child: const Text("Login")),
                TextButton(
                    onPressed: () {
                      cubit.tt(context);
                    },
                    child: const Text("Continue with Google")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account",
                      style: TextStyle(fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () {
                        navigateTo(
                          context,
                          RegisterScreen(),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
