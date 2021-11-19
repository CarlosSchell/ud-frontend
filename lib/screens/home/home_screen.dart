import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './components/bottom_bar.dart';
import './components/top_bar.dart';
import './components/top_drawer.dart';
import '../../../providers/auth.dart';
import '../../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    print('Entrou no InitState _HomeScreenState');
    localLoadProcessos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void localLoadProcessos() async {
    print('Entrou no homescreen localLoadProcessos');
    setState(() {
      isLoading = true;
    });
    Auth auth = Provider.of(context, listen: false);
    await auth.loadProcessos();
    setState(() {
      isLoading = false;
    });
  }

  // void loadProcessosEPublicacoes() async {
  //   Auth auth = Provider.of(context, listen: false);
  //   await auth.loadProcessos();
  //   await auth.loadPublicacoesDaListaDeProcessos();
  // }

  @override
  Widget build(BuildContext context) {
    print('Entrou no HomeScreen');
    final Size size = MediaQuery.of(context).size;
    Auth auth = Provider.of(context, listen: true);
    return Scaffold(
      appBar: TopBar(),
      drawer: const TopDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: size.height * 0.08),
                      Text(
                        'Olá!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Text(
                        'Seja Bem vindo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        '${auth.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        height: size.height * 0.06,
                      ),
                      //
                      if (isLoading)
                        Column(children: <Widget>[
                          SizedBox(height: size.height * 0.03),
                          CircularProgressIndicator(),
                          SizedBox(height: size.height * 0.03),
                        ])
                      else
                        Column(
                          children: [
                            Text(
                              'Voce tem ${auth.processosCount} processos cadastrados',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Text(
                              'Atenção! : ${auth.novasPublicaoes20dias} novas publicações',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'nos ultimos 20 dias!',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),

                      SizedBox(height: size.height * 0.10),
                      Text(
                        'Versão: 18-11-2021 - 08:10hs',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: size.height * 0.05),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.CONTACTPAGE,
                          );
                        },
                        child: Text(
                          "contato@udex.app",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}


                        // Auth auth = Provider.of(context, listen: false);
                        // localLoadProcessos();
                        //print('Lista de Processos:');
                        //print(auth.processos);
                        //
                        // localLoadPublicacoesDaListaDeProcessos();
                        // Imprime Processos e Publicacoes da Auth
                        //print('Lista de Processos e Publicacoes da Auth:');
                        //print(auth.processos);
                        // final processosList = [...auth.processos];
                        // processosList.forEach((processoItem) {
                        //   print('------');
                        //   print(processoItem.processo);
                        //   print(processoItem.descricao);
                        //   print(processoItem.listaDePublicacoesDoProcesso);
                        //   print('------');
                        //   //print(processoItem.listaDePublicacoes.processo);
                        //   //print(processoItem.listaDePublicacoes.decisao
                        //   //.substring(0, 30));
                        // });