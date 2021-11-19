import 'package:flutter/material.dart';

//import '../../login/login_screen.dart';
//import '../../signup/signup_screen.dart';
// import '../screens/home_screen.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  State<TopBar> createState() => _TopBarState();
}

// appBar: AppBar(
//   title: Text('test'),
//   leading: Builder(
//     builder: (BuildContext context) {
//       return IconButton(
//         icon: Icon(Icons.menu),
//         onPressed: () {
//           Scaffold.of(context).openDrawer();
//         },
//         tooltip: 'Something else',
//       );
//     },
//   ),
// ),

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Udex',
          style: TextStyle(
            fontSize: 20,
          )),
      backgroundColor: Colors.purple[900],
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Painel de Controle da Minha Conta',
          );
        },
      ),
    );
  }
}



      // actions: [
      //   PopupMenuButton(
      //       onSelected: (selectedValue) {
      //         print(selectedValue);
      //         if (selectedValue == 1) {
      //           Navigator.push(
      //               context, MaterialPageRoute(builder: (_) => LoginScreen()));
      //         }
      //         if (selectedValue == 2) {
      //           Navigator.push(
      //               context, MaterialPageRoute(builder: (_) => SignUpScreen()));
      //         }
      //       },
      //       itemBuilder: (BuildContext ctx) => [
      //             PopupMenuItem(child: Text('Entrar'), value: 1),
      //             PopupMenuItem(child: Text('Cadastrar'), value: 2),
      //             PopupMenuItem(child: Text('Sair'), value: 3),
      //           ])
      // ],