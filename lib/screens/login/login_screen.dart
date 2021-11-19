import 'package:flutter/material.dart';

import 'components/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Udex'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple[900],
      ),
      body: LoginScreenBody(),
    );
  }
}
