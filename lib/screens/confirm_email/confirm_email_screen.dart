import 'package:flutter/material.dart';

import 'components/confirm_email_body.dart';

class ScreenArguments {
  final String urlToken;
  ScreenArguments(this.urlToken);
}

class ConfirmEmailScreen extends StatelessWidget {
  final String urlToken;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ConfirmEmailScreen({
    Key? key,
    required this.urlToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Entrou no confirmEmailScreen');
    // print("Entrou no confirmEmail : ${urlToken}");
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Confirmar Email'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[900],
      ),
      body: ConfirmEmailScreenBody(urlToken: urlToken),
    );
  }
}
