import 'package:flutter/material.dart';

class NotAcceptedScreen extends StatelessWidget {
  const NotAcceptedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text(
            "Please Contact Your Coach \nTo Accept Your Request",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ));
  }
}
