import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './top_drawer_header.dart';
// import '../components/custom_drawer_header.dart';

import '../../../providers/auth.dart';
import '../../../routes/app_routes.dart';

class TopDrawer extends StatelessWidget {
  const TopDrawer({Key? key}) : super(key: key);

  final Color primaryColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      child: Drawer(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.indigo.shade50,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
            ),
            ListView(children: <Widget>[
              TopDrawerHeader(),
              Divider(),
              ListTile(
                leading: const Icon(
                  Icons.person_outlined,
                  size: 28,
                  //color: Colors.deepPurple,
                ),
                title: const Text('Minha Conta',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(
                  //   AppRoutes.HOME,
                  //);
                },
              ),
              Divider(),
              ListTile(
                leading: const Icon(
                  Icons.lock,
                  size: 28,
                  color: Colors.deepPurple,
                ),
                title: const Text('Mudar Senha',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.CHANGEPASSWORD,
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  size: 28,
                  //color: Colors.deepPurple,
                ),
                title: const Text('Configurações',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(
                  //   AppRoutes.ORDERS,
                  // );
                },
              ),
              Divider(),
              ListTile(
                leading: const Icon(
                  Icons.payment,
                  size: 28,
                ),
                title: const Text('Assinatura',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(
                  //   AppRoutes.ORDERS,
                  // );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.cloud_download_outlined,
                  size: 28,
                ),
                title: const Text('Arquivos',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(
                  //   AppRoutes.WELCOME,
                  // );
                },
              ),
              Divider(),
              ListTile(
                leading: const Icon(
                  Icons.email,
                  color: Colors.deepPurple,
                  size: 28,
                ),
                title: const Text('Contato',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.CONTACTPAGE,
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  size: 28,
                  color: Colors.deepPurple,
                ),
                title: Text('Sair',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.LOGIN,
                  );
                },
              ),
              Divider(),
            ]),
          ],
        ),
      ),
    );
  }
}
