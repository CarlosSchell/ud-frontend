import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/publicacao.dart';
import '../../../utils/gen_utils.dart';
import '../../../utils/whatsapp_unilink.dart';
import '../../exceptions/auth_exception.dart';
import '../../providers/auth.dart';

class PesquisaGeralCardDetails extends StatefulWidget {
  final Publicacao publi;
  final int publiIndex;
  final int publiTotal;
  final String searchText;
  final bool isFromPesquisaPublicacao;

  const PesquisaGeralCardDetails({
    Key? key,
    required this.publi,
    required this.publiIndex,
    required this.publiTotal,
    required this.searchText,
    required this.isFromPesquisaPublicacao,
  }) : super(key: key);

  @override
  State<PesquisaGeralCardDetails> createState() => _PesquisaGeralCardDetails();
}

class _PesquisaGeralCardDetails extends State<PesquisaGeralCardDetails> {
  final String phoneNumber = "";
  final String text = '';

  Future<void> _copyToClipboard(processo) async {
    await FlutterClipboard.copy(processo);
    final snackBar = SnackBar(
        content: Text(
            "O número do processo foi copiado para a área de transferência."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return Future.value();
  }

  Future<void> _launchWhatsApp(phoneNumber, text) async {
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: text,
    );
    await launch('$link');
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Não pode abrir: $url';
    }
  }

  _sendWhatsappMessage() {
    //print('Entrou no _launchWhatsApp');
    final String msg =
        'Data: ${widget.publi.dia}/${widget.publi.mes}/${widget.publi.ano} - TJ${widget.publi.uf}' +
            "\n" +
            widget.publi.decisao;
    _launchWhatsApp(phoneNumber, msg);
  }

  _sendEmail() async {
    //print('Entrou no _sendEmail');
    final String corpoMsg =
        'Data: ${widget.publi.dia}/${widget.publi.mes}/${widget.publi.ano} - TJ${widget.publi.uf}' +
            "\n" +
            widget.publi.decisao;

    final String assuntoMsg =
        "Publicacao do ${widget.publi.tribunal}${widget.publi.uf} - ${widget.publi.dia}/${widget.publi.mes}/${widget.publi.ano} - Processo: ${widget.publi.processo}";

    // 'mailto:xxx?subject=${Uri.encodeFull(assuntoMsg)}&body=${Uri.encodeFull(corpoMsg)}';

    final url =
        'mailto:?subject=${Uri.encodeFull(assuntoMsg)}&body=${Uri.encodeFull(corpoMsg)}';

    _launchInBrowser(url);
  }

  _loadSiteDoTribunal() {
    // 0249243-86.2021.8.19.0001
    String processoToTribunal = (widget.publi.processo);
    String codigoEstadoTribunal = processoToTribunal.substring(16, 20);
    codigoEstadoTribunal = codigoEstadoTribunal.substring(0, 4);

    String urlEstadoTribunal = '';
    if (codigoEstadoTribunal == '8.21') {
      _copyToClipboard(processoToTribunal);
      urlEstadoTribunal =
          'https://www.tjrs.jus.br/novo/busca/?return=proc&client=wp_index';
    } else {
      if (codigoEstadoTribunal == '8.19') {
        String parte01CodigoProcesso = processoToTribunal.substring(0, 15);
        String parte02CodigoProcesso = processoToTribunal.substring(21, 25);

        //parte01CodigoProcesso + '\r\n' + parte02CodigoProcesso + '\r\n';
        //parte01CodigoProcesso + '\0x0a' + '\x0D' + parte02CodigoProcesso + '\0x0a' + '\x0D';
        String processoToClipboard =
            parte01CodigoProcesso + '\0x0a' + '\x0D' + parte02CodigoProcesso;
        _copyToClipboard(processoToClipboard);
        urlEstadoTribunal =
            'https://www3.tjrj.jus.br/consultaprocessual/#/consultapublica#porNumero';
      }
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      //print('Abriu o link do Tribunal : Processo ${widget.publi.processo}');
      _launchInBrowser(urlEstadoTribunal);
    });
  }

  Future<void> _addProcesso(String processo, String descricao) async {
    print('Adiciona Processo : $processo');
    print('                  : $descricao');
    Auth auth = Provider.of(context, listen: false);
    try {
      await auth.adicionaProcesso(processo, descricao);
      final snackBar =
          SnackBar(content: Text('Processo Incluído na sua Lista!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on AuthException catch (error) {
      print(error);
      final snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      print(error);
      final snackBar = SnackBar(content: Text("Ocorreu um erro inesperado!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final String _ano = widget.publi.ano;
    final String _mes = widget.publi.mes;
    final String _dia = widget.publi.dia;

    final String _uf = widget.publi.uf;
    final String _tribunal = widget.publi.tribunal;

    final String _diario = widget.publi.diario;
    final String _pagina = widget.publi.pagina;

    final String _cidade = widget.publi.cidade;
    final String _grau = widget.publi.grau;
    final String _gname = widget.publi.gname;

    final String _orgao = widget.publi.orgao;
    final String _camara = widget.publi.camara;
    final String _foro = widget.publi.foro;
    final String _vara = widget.publi.vara;

    final String _tipo = widget.publi.tipo;
    //final String _obstipo = widget.publi.obsdec;
    final String _desctipo = widget.publi.desctipo;

    final String _classe = widget.publi.classe;
    final String _assunto = widget.publi.assunto;

    final String _processo = widget.publi.processo;

    final String _decisao = widget.publi.decisao;
    //final String _obsdec = widget.publi.obsdec;

    final Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 6,
      color: Color(0xFFFCEADE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
        child: ExpansionTile(
            title: Text(
              //${(widget.indexPubli + 1)}
              'Nro ${(widget.publiIndex + 1)}/${(widget.publiTotal)} - $_tribunal/$_uf - $_cidade - $_grau GRAU :  ' +
                  '$_dia/$_mes/$_ano - ' +
                  GenUtils.extraiInicioDecisao(_decisao),
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Text(' '), //Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: Text(
            //     GenUtils.extraiFimDecisao(
            //         _decisao, widget.isFromPesquisaPublicacao),
            //     style: TextStyle(fontSize: 14.0, color: Colors.black),
            //   ),
            //),
            backgroundColor: Colors.yellow[50],
            children: <Widget>[
              Container(
                  width: size.width,
                  // color: Colors.lime[100], //green[50], //yellow[50],
                  // height: size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 10),
                                    child: Text(
                                      '$_tribunal$_uf',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.red[800]),
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 4.0, // gap between adjacent chips
                                    runSpacing: 4.0,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.send, size: 20),
                                          tooltip: 'Envia pelo Whatsapp',
                                          onPressed: _sendWhatsappMessage),
                                      SizedBox(width: 6, height: 10),
                                      IconButton(
                                          icon: Icon(Icons.mail, size: 20),
                                          tooltip: 'Envia pelo email',
                                          onPressed: _sendEmail),
                                      SizedBox(width: 6, height: 10),
                                      IconButton(
                                          icon: Icon(
                                              Icons.account_balance_sharp,
                                              size: 20),
                                              tooltip: 'Acessa o site do Tribunal',
                                          onPressed: _loadSiteDoTribunal),
                                      SizedBox(width: 6, height: 10),
                                      IconButton(
                                          icon: Icon(Icons.plus_one, size: 20),
                                          tooltip: 'Inclui na lista de processos',
                                          onPressed: () {
                                            _addProcesso(
                                              widget.publi.processo,
                                              widget.publi.decisao
                                                  .substring(33, 90),
                                            );
                                          }),
                                      SizedBox(width: 3, height: 10),
                                      // SizedBox(width: 5, height: 10),
                                      // SizedBox(width: 5, height: 10),
                                    ],
                                  ),
                                ]),
                          ),
                          // Text(
                          //   'DJ$_uf: $_dia/$_mes/$_ano',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 17,
                          //       color: Colors.red[800]),
                          // ),
                          Text(
                            '$_processo',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87),
                          ),
                          Text(
                            'Data  $_dia/$_mes/$_ano',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54),
                          ),
                          Text(
                            'Grau: $_gname / $_cidade',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal[900]),
                          ),
                          if (_orgao != '')
                            Text(
                              'Órgão: $_orgao',
                              style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.teal[900]),
                            ),
                          if (_camara != '')
                            Text(
                              'Camara: $_camara',
                              style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.teal[900]),
                            ),
                          if (_foro != '')
                            Text(
                              'Foro: $_foro',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[900]),
                            ),
                          if (_vara != '')
                            Text(
                              'Vara: $_vara',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[900]),
                            ),
                          if (_tipo != '')
                            Text(
                              'Tipo: $_tipo - $_desctipo',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[900]),
                            ),
                          if (_classe != '')
                            Text(
                              'Classe: $_classe',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[900]),
                            ),
                          if (_assunto != '')
                            Text(
                              'Assunto: $_assunto',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[900]),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                            child: Text(
                              'Diário: $_diario - Pág: $_pagina',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.teal[900]),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: GenUtils.highlightOccurrences(
                                  'Decisao: $_decisao', widget.searchText),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]),
                  ))
            ]),
      ),
    );
  }
}



                                  // PopupMenuButton(
                                  //     color: Colors.grey[200],
                                  //     onSelected: (selectedValue) {
                                  //       _onItemSelected(int.parse(
                                  //           selectedValue.toString()));
                                  //     },
                                  //     itemBuilder: (BuildContext ctx) => [
                                  //           PopupMenuItem(
                                  //               child: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: <Widget>[
                                  //                   Text(
                                  //                     'Whatsapp',
                                  //                     style: TextStyle(
                                  //                       fontSize: 16,
                                  //                     ),
                                  //                   ),
                                  //                   Icon(Icons.send),
                                  //                 ],
                                  //               ),
                                  //               value: 1),
                                  //           PopupMenuItem(
                                  //               child: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: <Widget>[
                                  //                   Text(
                                  //                     'Email',
                                  //                     style: TextStyle(
                                  //                       fontSize: 16,
                                  //                     ),
                                  //                   ),
                                  //                   Icon(Icons.mail),
                                  //                 ],
                                  //               ),
                                  //               value: 2),
                                  //           PopupMenuItem(
                                  //               child: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: <Widget>[
                                  //                   Text(
                                  //                     'Tribunal',
                                  //                     style: TextStyle(
                                  //                       fontSize: 16,
                                  //                       //color:
                                  //                       //Colors.blue[900]),
                                  //                     ),
                                  //                   ),
                                  //                   Icon(Icons
                                  //                       .account_balance_sharp),
                                  //                 ],
                                  //               ),
                                  //               value: 3),
                                  //           PopupMenuItem(
                                  //               enabled: widget
                                  //                   .isFromPesquisaPublicacao,
                                  //               child: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: <Widget>[
                                  //                   Text(
                                  //                     'Incluir Meus Processos',
                                  //                     style: TextStyle(
                                  //                       fontSize: 16,
                                  //                     ),
                                  //                   ),
                                  //                   Icon(Icons.plus_one),
                                  //                 ],
                                  //               ),
                                  //               value: 4),
                                  //         ]),



  // String ano = ''; 
  // String mes = ''; 
  // String dia = ''; 

  // String uf = '';
  // String tribunal = '';

  // String diario = '';
  // String pagina = '';

  // String cidade = ''; 
  // String grau = '';
  // String gname = '';

  // String orgao = ''; 
  // String camara = '';
  // String foro = ''; 
  // String vara = '';
 
  // String tipo = '';
  // String obstipo = ''; 
  // String desctipo = ''; 

  // String classe = '';
  // String assunto = '';

  // String processo = ''; 

  // String decisao = '';
  // String obsdec = ''; 



            // leading: CircleAvatar(
            //   backgroundColor: GenUtils.selectDaysLateColor(daysLate),
            //   radius: 20,
            //   child: Padding(
            //     padding: const EdgeInsets.all(2),
            //     child: FittedBox(
            //       child: Text(
            //         GenUtils.selectDaysLateString(daysLate),
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ), //Text('${proc.id}'),
            //       ),
            //     ),
            //   ),
            // ),
            // trailing: SizedBox.shrink(),

        // onTap: () {
        //   // Navigator.push(
        //   //     //Replacement
        //   //     context,
        //   //     MaterialPageRoute(
        //   //         builder: (_) => PublicacaoCardActionsScreen(
        //   //             publi: publi, searchText: searchText)));
        // },

  // Future<void> copyToClipboard(processo) async {
  //   print('Entrou no copy to Clipboard');
  //   print(processo);
  //   await FlutterClipboard.copy(processo);
  //   //.then((value) => print('Enviou para o Clipboard'));
  //   // await Clipboard.setData(ClipboardData(text: csvData));
  //   // print('Enviou para o Clipboard');
  //   // print('Antes de chamar o snackbar do copy to Clipboard');
  //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   //   content: Text(
  //   //       'O número do processo pesquisa foi copiado para a área de transferência.'),
  //   // ));
  //   print('Saiu do copy to Clipboard');
    

// highlightOccurrences(String source, String? query)

  // RichText(
  //   text: TextSpan(
  //     children: genUtils.highlightOccurrences(decisao, searchText),
  //     style: const TextStyle(color: Colors.red),
  //   ),
  // ),

      // title: RichText(
      //   text: TextSpan(
      //     children: provider.highlightOccurrences(item.name, provider.searchValue),
      //     style: const TextStyle(color: Colors.black),
      //   ),
      // ),

                                // IconButton(
                                //   icon: Icon(Icons.send),
                                //   onPressed: () => {},
                                // ),


                  // RichText(
                  //   text: TextSpan(
                  //     text: _decisao,
                  //     style: DefaultTextStyle.of(context).style,
                  //     children: <TextSpan>[
                  //       TextSpan(
                  //           text: searchText,
                  //           style: TextStyle(
                  //               color: Colors.red,
                  //               backgroundColor: Colors.blue,
                  //               fontWeight: FontWeight.bold)),
                  //       // TextSpan(text: searchText),
                  //     ],
                  //   ),
                  // ),