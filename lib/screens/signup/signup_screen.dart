import 'package:flutter/material.dart';

import 'components/signup_card.dart';


class SignUpScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Nova Conta'),
        backgroundColor: Colors.purple[900],
        // centerTitle: true,
      ),
      body: SignUpCard(),
    );
  }
}
