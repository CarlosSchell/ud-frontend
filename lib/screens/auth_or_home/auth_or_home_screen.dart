import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../home/home_screen.dart';
//import '../home/home_screen.dart';
import '../login/login_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Entrou no AuthOrHomeScreen');
    Auth auth = Provider.of(context, listen: false);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        child: Image.asset('/assets/images/logo_udex.png'),
                        height: 130.0,
                        width: 130.0,
                      ),
                    ),
                    // Center(
                    //   child: SizedBox(
                    //     child: CircularProgressIndicator(),
                    //     height: 50.0,
                    //     width: 50.0,
                    //   ),
                    // ),
                  ]));
        } else if (snapshot.error != null) {
          print(snapshot.error);
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? HomeScreen() : LoginScreen();
        }
      },
    );
  }
}
