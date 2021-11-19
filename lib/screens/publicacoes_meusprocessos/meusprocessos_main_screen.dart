import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

import '../../../models/processo.dart';
import '../../../models/publicacao.dart';
import 'meusprocessos_card_details.dart';
//import '../../../utils/gen_utils.dart';

class MeusProcessosMainScreen extends StatefulWidget {
  final Processo processo;

  const MeusProcessosMainScreen({Key? key, required this.processo})
      : super(key: key);

  @override
  _MeusProcessosMainScreen createState() => _MeusProcessosMainScreen();
}

class _MeusProcessosMainScreen extends State<MeusProcessosMainScreen> {
  //List _publicacoes = [];
  int indice = 1;
  //List _publicacoesList = [];

  Future<void> copyToClipboard(csvData) async {
    print('Entrou no copy to Clipboard');
    await FlutterClipboard.copy(csvData);
    print('Enviou para o Clipboard');
    print('Antes de chamar o snackbar do copy to Clipboard');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'A sua lista de processos foi copiada para a área de transferência.'),
    ));
    print('Saiu do copy to Clipboard');
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no builder do PublicacoesMeusProcessos');
    final Size size = MediaQuery.of(context).size;
    final List<Publicacao> _publicacoes = widget.processo.publicacoes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Publicações do processo',
            style: TextStyle(
              fontSize: 16,
            )),
        backgroundColor: Colors.purple[900],
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.copy),
        //     tooltip:
        //         'Copia o resultado da pesquisa para a área de transferência',
        //     onPressed: () async {

        //     // _publicacoesList =
        //     //     _publicacoes.map((publi) => Publicacao.fromJson(publi)).toList();
        //       final String dataToPublish =
        //           await GenUtils.encodeCSV(_publicacoesList);
        //       await copyToClipboard(dataToPublish);
        //     },
        //   ),
        //   SizedBox(width: 15),
        //],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade200,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 360,
                maxWidth: (size.width > 1200) ? (size.width * 0.94) : 1200,
              ),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _publicacoes.map((publi) {
                  indice = indice + 1;
                  return MeusProcessosCardDetails(
                      publi: publi,
                      publiIndex: indice,
                      searchText: '',
                      isFromPesquisaPublicacao: false);
                }).toList(),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
