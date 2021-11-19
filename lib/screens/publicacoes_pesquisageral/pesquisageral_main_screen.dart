//import 'dart:async';
//import 'dart:convert';
//import "dart:io";

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './publicacao_card.dart';
import '../../../constants/constants.dart';
// import '../../../exceptions/auth_exception.dart';
// import '../../../models/publicacao.dart';
// import '../../../providers/auth.dart';
import '../home/components/bottom_bar.dart';
import 'pesquisageral_body.dart';

//enum TribunalEstado { tjrs, tjsp }

class PesquisaGeralMainScreen extends StatefulWidget {
  const PesquisaGeralMainScreen({Key? key}) : super(key: key);

  @override
  _PesquisaGeralMainScreenState createState() => _PesquisaGeralMainScreenState();
}

class _PesquisaGeralMainScreenState extends State<PesquisaGeralMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _textController = TextEditingController();

  Future<void> _getTribunalEstado() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String tribunalestado = _prefs.getString('tribunalestado') ?? 'tjrs';
    //sleep(Duration(seconds: 1));
    print('Dentro do Future -get tribunalestado: ' + tribunalestado);
    setState(() => _tribunalEstado = tribunalestado);
  }

  Future<void> _setTribunalEstado(tribunalestado) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('tribunalestado', tribunalestado);
    //sleep(Duration(seconds: 1));
    print('Dentro do Future - set tribunalestado: ' + tribunalestado);
    setState(() => _tribunalEstado = tribunalestado);
  }

  String _tribunalEstado = 'tjrs';

  @override
  void initState() {
    super.initState();
    _getTribunalEstado();
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no PublicacoesPesquisa');
    final Size size = MediaQuery.of(context).size;
    //_getTribunalEstado();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Pesquisar Publicações',
            style: TextStyle(
              fontSize: 18,
            )),
        backgroundColor: Colors.purple[900],
        automaticallyImplyLeading: false,
      ),
      body: Container(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 360,
                maxWidth: 450,
              ),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    SizedBox(height: size.height * 0.07),
                    Text(
                      "Diário da Justiça Eletrônico",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Constants.kTextColor,
                      ),
                    ),
                    Text(
                      "Selecione o Tribunal ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Constants.kTextColor,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Center(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: const Text('TJRS'),
                            leading: Radio(
                                value: 'tjrs',
                                groupValue: _tribunalEstado,
                                onChanged: (value) {
                                  _setTribunalEstado(value);
                                }),
                          ),
                          ListTile(
                            title: const Text('TJRJ'),
                            leading: Radio(
                                value: 'tjrj',
                                groupValue: _tribunalEstado,
                                onChanged: (value) {
                                  _setTribunalEstado(value);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.indigo[50],
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.none,
                        //obscureText: _isObscureText, // true,
                        key: ValueKey('searchpub'),
                        cursorColor: Constants.kPrimaryColor,
                        keyboardType: TextInputType.text,
                        keyboardAppearance: Brightness.light,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        controller: _textController,
                        inputFormatters: [LengthLimitingTextInputFormatter(60)],
                        onEditingComplete: () {
                          if (_textController.text != '') {
                            print(
                                'Clicou no botão done (enter) de pesquisa 01!');
                            print(_tribunalEstado);

                            String tribunal =
                                (_tribunalEstado.substring(0, 2).toLowerCase());
                            String uf =
                                (_tribunalEstado.substring(2, 4).toLowerCase());
                            print('tribunal: ' + tribunal);
                            print('uf: ' + uf);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PesquisaGeralBody(
                                          textoPesquisa: _textController.text,
                                          tribunal: tribunal,
                                          uf: uf,
                                        )));
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "digite sua busca",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                            color: Colors.grey[800],
                            onPressed: () {
                              if (_textController.text != '') {
                                print(
                                    'Clicou no botão done (enter) de pesquisa 01!');
                                print(_tribunalEstado);

                                String tribunal = (_tribunalEstado
                                    .substring(0, 2)
                                    .toLowerCase());
                                String uf = (_tribunalEstado
                                    .substring(2, 4)
                                    .toLowerCase());
                                print('tribunal: ' + tribunal);
                                print('uf: ' + uf);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PesquisaGeralBody(
                                              textoPesquisa:
                                                  _textController.text,
                                              tribunal: tribunal,
                                              uf: uf,
                                            )));
                              }
                            },
                          ),
                        ),
                        //controller: _passwordController,
                        //enabled: !_isLoading,
                        validator: (value) {
                          final String _value = value ?? '';
                          if (_value.length < 6) {
                            return 'Senha deve ter mais de 5 digitos.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ])))),
      bottomNavigationBar: const BottomBar(),
    );
  }
}

