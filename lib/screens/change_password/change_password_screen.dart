import 'package:flutter/material.dart';

import 'components/change_password_body.dart';


class ChangePasswordScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Mudar a senha'),
        backgroundColor: Colors.purple[900],
        // centerTitle: true,
      ),
      body: ChangePasswordBody(),
    );
  }
}
