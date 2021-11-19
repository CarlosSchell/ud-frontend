import 'package:flutter/material.dart';

import 'components/reset_email_link_body.dart';

class ResetEmailLinkScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ResetEmailLinkScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Entrou no resendEmailLink');
    // print("Entrou no confirmEmail : ${urlToken}");
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Solicitar link para confirmar email',
        style: TextStyle(
              fontSize: 18,
            )),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[900],
      ),
      body: ResetEmailLinkBody(),
    );
  }
}
