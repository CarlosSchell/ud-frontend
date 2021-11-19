import 'package:flutter/material.dart';

import '../constants/constants.dart';
// import '../screens/login/login_screen.dart';
// import '../screens/signup/signup_screen.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final void Function() press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    required this.login,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Não tem uma conta ?" : "Já tem uma conta ?",
          style: TextStyle(color: Constants.kPrimaryColor),
        ),
        TextButton(
          onPressed: press, 
          // style: TextButton(
          //   textcolor: Constants.kPrimaryColor,
          //   fontSize: 18,
          //   fontWeight: FontWeight.bold,
          //   padding: const EdgeInsets.all(16.0),
          //   primary: Colors.white,
          //   textStyle: const TextStyle(fontSize: 20),
          // ),
          child: Text(login ? " Cadastrar " : " Entrar "),
          )
        // GestureDetector(
        //   onTap: press,
        //   child: Text(
        //     login ? " Cadastrar " : " Entrar ",
        //     style: TextStyle(
        //       color: Constants.kPrimaryColor,
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // )
      ],
    );
  }
}
