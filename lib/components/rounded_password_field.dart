import 'package:flutter/material.dart';

import './text_field_container.dart';
import '../constants/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Senha",
          // border: OutlineInputBorder(),
          icon: Icon(
            Icons.lock,
            color: Colors.grey[800],
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color:  Colors.grey[800],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}