import 'package:flutter/material.dart';

import 'components/reset_password_body..dart';

class ResetPasswordScreenArguments {
  final String urlToken;
  ResetPasswordScreenArguments(this.urlToken);
}

class ResetPasswordScreen extends StatelessWidget {
  final String urlToken;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ResetPasswordScreen({
    Key? key,
    required this.urlToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Entrou no confirmPasswordScreen');
    // print("Entrou no confirmEmail : ${urlToken}");
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Esqueci minha Senha'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[900],
      ),
      body: ResetPasswordBody(urlToken: urlToken),
    );
  }
}
