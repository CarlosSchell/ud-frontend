import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function() press;
  final bool isActiveButton;
  // final Function press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.color, // = Constants.kPrimaryColor,
    required this.textColor, // = Colors.white,
    required this.press,
    required this.isActiveButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextButton(
          style: TextButton.styleFrom(
            textStyle:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            backgroundColor: Colors.grey.shade200,
            // primary: Colors.red,
            // color: Colors.red,
          ),
          onPressed: () {
            if (isActiveButton) {
              press();
            } 
          },
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
