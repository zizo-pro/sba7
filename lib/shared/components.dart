import 'package:flutter/material.dart';

void navigateTo(context, dynamic screen) =>
    Navigator.push(context, MaterialPageRoute(builder: ((context) => screen)));

void navigateAndFinish(context, dynamic screen) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: ((context) => screen)), (route) {
      return false;
    });


Widget textfield({
  required TextEditingController controller,
  required TextInputType type,
  Function(String?)? onSubmit,
  Function(String?)? onChange,
  String? Function(String?)? validate,
  required var label,
  required IconData prefix,
  required bool obscure,

}) =>
    TextFormField(
      
      validator: validate,
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.black),
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefix),
      ),
    );
