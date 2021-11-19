import 'package:flutter/material.dart';

class Blank extends StatefulWidget {
  const Blank({Key? key}) : super(key: key);

  @override
  _BlankState createState() => _BlankState();
}

class _BlankState extends State<Blank> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 80,
          width: 150,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: null,
            child: const Text(
              'Blank Page',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
