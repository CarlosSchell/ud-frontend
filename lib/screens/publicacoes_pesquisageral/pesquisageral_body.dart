import 'dart:async';
import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../exceptions/auth_exception.dart';
import '../../../models/publicacao.dart';
import '../../../providers/auth.dart';
import '../../../utils/gen_utils.dart';
import 'pesquisageral_card_details.dart';

// https://pub.dev/packages/shared_preferences // TJRS - TJSP
// https://api.flutter.dev/flutter/material/Radio-class.html

class PesquisaGeralBody extends StatefulWidget {
  final String textoPesquisa;
  final String uf;
  final String tribunal;

  const PesquisaGeralBody(
    {Key? key, 
      required this.textoPesquisa,
      required this.uf,
      required this.tribunal,
      }
    ) : super(key: key);

  @override
  _PesquisaGeralBodyState createState() => _PesquisaGeralBodyState();
}

class _PesquisaGeralBodyState extends State<PesquisaGeralBody> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List _publicacoes = [];
  List _publicacoesList = [];

  Future<void> getPublicacoesTexto(textoPesquisa, uf, tribunal) async {
    print('Entrou no getPesquisaPublicacoes : $textoPesquisa');

    Auth auth = Provider.of(context, listen: false);
    String token = auth.token;

    final String url = Constants.BASE_API_URL + 'publicacao/texto';

    String bodyEncoded = jsonEncode({
      "texto": textoPesquisa,
      "uf": uf,
      "tribunal": tribunal,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: bodyEncoded,
    );

    final responseBody = await jsonDecode(response.body);
    //print(responseBody);

    if (responseBody["status"] == "fail") {
      throw AuthException(responseBody["message"]);
    } else {
      print('Buscou as publicacoes no database!');
      _publicacoesList = responseBody["data"]["publicacoes"].toList();
      _publicacoes =
          _publicacoesList.map((publi) => Publicacao.fromJson(publi)).toList();
    }
    return Future.value();
  }

  Future<void> copyToClipboard(csvData) async {
    print('Entrou no copy to Clipboard');
    await FlutterClipboard.copy(csvData);
    print('Enviou para o Clipboard');
    print('Antes de chamar o snackbar do copy to Clipboard');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'O resultado da pesquisa foi copiado para a área de transferência.'),
    ));
    print('Saiu do copy to Clipboard');
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no PublicacoesPesquisaScreen page');
    // final Size size = MediaQuery.of(context).size;
    final String texto = widget.textoPesquisa;
    final String uf = widget.uf;
    final String tribunal = widget.tribunal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisa : $texto',
            style: TextStyle(
              fontSize: 16,
            )),
        backgroundColor: Colors.purple[900],
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip:
                'Copia o resultado da pesquisa para a área de transferência',
            onPressed: () async {
              final String dataToPublish =
                  await GenUtils.encodeCSV(_publicacoesList);
              await copyToClipboard(dataToPublish);
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: FutureBuilder(
        future: getPublicacoesTexto(texto, uf, tribunal),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _publicacoes.length,
                    itemBuilder: (ctx, i) => Column(
                      children: <Widget>[
                        PesquisaGeralCardDetails(
                          publi: _publicacoes[i],
                          publiIndex: i,
                          publiTotal: _publicacoes.length,
                          searchText: texto,
                          isFromPesquisaPublicacao: true,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}








// DateTime today = new DateTime.now();
// String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
// print(dateSlug);


    // print(
    //     'Preparando para gravar a pesquisa na área de trasnferência - ClipBoard');
    // print(csvDataHeader);

    // print('    ');
    // print('    ');
    // print('------------------------------------------------------------');
    // print('    ');
    // print('    ');

    // print(csvDataHeader);
    //print(csvDataItem);

    // File file = new File("pesquisa.txt");
    // await file.writeAsString(csvDataHeader, mode: FileMode.append);
    // await file.writeAsString(csvDataItem, mode: FileMode.append);

    // csvDataHeader +

    //Directory appDocDir = await getTemporaryDirectory();
    // final directory = await getDownloadsDirectory();
    // Directory  directory  = appDocDir.path;

    // var logFile = File('${directory?.path}/pesquisa.txt');
    // var sink = logFile.openWrite();
    // sink.write(csvDataItems);
    // await sink.flush();
    // await sink.close();

    //final filename = 'pesquisa.txt';
    //await File(filename).writeAsString(csvDataItems);


