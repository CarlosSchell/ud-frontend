import 'package:flutter/material.dart';

import './text_field_container.dart';
import '../constants/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Constants.kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.grey[800],
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}