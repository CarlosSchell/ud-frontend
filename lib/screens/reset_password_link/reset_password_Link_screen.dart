import 'package:flutter/material.dart';

import 'components/reset_password_link_body.dart';

class ResetPasswordLinkScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ResetPasswordLinkScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Entrou no forgotPassword');
    // print("Entrou no confirmEmail : ${urlToken}");
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Solicitar link para mudar senha',
        style: TextStyle(
              fontSize: 18,
            )),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[900],
      ),
      body: ResetPasswordLinkBody(),
    );
  }
}
