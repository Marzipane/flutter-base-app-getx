import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Row(
            children: [
              // Text("hello".tr),
              Expanded(flex: 3, child: Container(color: Colors.yellow, height: 50,)),
              Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.red,
                    height: 50,
                  )),
            ],
          )),
    );
  }
}
