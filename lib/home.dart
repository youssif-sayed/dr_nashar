import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: DottedBorder(
          color: Colors.blueAccent,
          borderType: BorderType.Circle,
          radius: const Radius.circular(110),
          padding: const EdgeInsets.all(10),
          dashPattern: const [20,10 ],
          child: const CircleAvatar(
            backgroundColor: Colors.red,
            radius: 100,
          ),
        ),
      ),
    );
  }
}
