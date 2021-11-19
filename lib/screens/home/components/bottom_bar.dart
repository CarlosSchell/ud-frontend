import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../../models/processo.dart';
import '../../../providers/auth.dart';
import '../../home/home_screen.dart';
import '../../processos/processos_screen.dart';
import '../../publicacoes_pesquisageral/pesquisageral_main_screen.dart';

/// This is the stateful widget that the main application instantiates.
class BottomBar extends StatefulWidget {
  //final List<Processo> meusProcessos;
  const BottomBar({
    Key? key,
    //required this.meusProcessos,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

/// This is the private State class that goes with BottomNavigation.
class _BottomBarState extends State<BottomBar> {
  int selectedBottomMenuItem = 0;

  void _onItemTapped(int index) {
    setState(() {
      Auth auth = Provider.of(context, listen: false);
      auth.setSelectedBottomMenuItem(index);
      if (index == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }

      if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ProcessosScreen()));
      }

      if (index == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => PesquisaGeralMainScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context, listen: true);
    int selectedBottomMenuItem = auth.getSelectedBottomMenuItem;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.format_list_bulleted,
            size: 30,
          ),
          label: 'Meus Processos',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            size: 30,
          ),
          label: 'Pesquisar',
        ),
      ],
      //backgroundColor: Colors.grey[200],
      currentIndex: selectedBottomMenuItem,
      selectedItemColor: Colors.purple.shade800,
      unselectedItemColor: Colors.black87,
      onTap: _onItemTapped,
    );
  }
}
