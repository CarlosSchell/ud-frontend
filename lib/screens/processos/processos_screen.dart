import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/processo.dart';
import '../../../providers/auth.dart';
import '../../../utils/gen_utils.dart';
import '../home/components/bottom_bar.dart';
import '../publicacoes_meusprocessos/meusprocessos_main_screen.dart';
import 'processo_form.dart';

class ProcessosScreen extends StatefulWidget {
  const ProcessosScreen({
    Key? key,
  }) : super(key: key);
  @override
  _ProcessosScreenState createState() => _ProcessosScreenState();
}

// class _ProcessosScreenState extends State<ProcessosScreen> with ChangeNotifier {
class _ProcessosScreenState extends State<ProcessosScreen> {
  List<Processo> _meusProcessos = [];
  bool isSortedByDate = true;
  bool isSortedByAscendingOrder = true;

  _sortProcessos() {
    if ((isSortedByDate == true) && (isSortedByAscendingOrder == true)) {
      print('Entrou no _sort by AscendingOrder');
      _meusProcessos.sort((a, b) => a.daysLate.compareTo(b.daysLate));
    }

    if ((isSortedByDate == true) && (isSortedByAscendingOrder == false)) {
      print('Entrou no _sort by DescendingOrder');
      _meusProcessos.sort((a, b) => b.daysLate.compareTo(a.daysLate));
    }

    if ((isSortedByDate == false) && (isSortedByAscendingOrder == true)) {
      print('Entrou no _sort by PublicacaoDate AscendingOrder');
      _meusProcessos.sort((a, b) => a.processo.compareTo(b.processo));
    }

    if ((isSortedByDate == false) && (isSortedByAscendingOrder == false)) {
      print('Entrou no _sort by PublicacaoDate  DescendingOrder');
      _meusProcessos.sort((a, b) => b.processo.compareTo(a.processo));
    }
  }

  _addProcesso(String processo, String descricao) async {
    Auth auth = Provider.of(context, listen: false);
    await auth.adicionaProcesso(processo, descricao);
    Navigator.of(context).pop();
  }

  _removeProcesso(processo) async {
    print('Entrou no _removeProcesso');
    Auth auth = Provider.of(context, listen: false);
    await auth.excluiProcesso(processo);
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ProcessoForm(_addProcesso);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no Processos');
    final Size size = MediaQuery.of(context).size;
    int decisaoLength = (size.width < 400) ? 120 : 500;
    Auth auth = Provider.of(context, listen: true);
    _meusProcessos = [...auth.processos];
    _sortProcessos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Processos',
            style: TextStyle(
              fontSize: 18,
            )),
        backgroundColor: Colors.purple[900],
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 18, right: 0.0),
            child: Text("Data"),
          ),
          Padding(
            padding: EdgeInsets.only(right: 3.0),
            child: IconButton(
              icon: Icon(Icons.swap_vert),
              tooltip: 'Ordena por data',
              onPressed: () {
                setState(() {
                  isSortedByDate = true;
                  isSortedByAscendingOrder = !isSortedByAscendingOrder;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18, right: 0.0),
            child: Text(
              "Proc",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: IconButton(
              icon: Icon(Icons.swap_vert),
              tooltip: 'Ordena por numero processo',
              onPressed: () {
                setState(() {
                  isSortedByDate = false;
                  isSortedByAscendingOrder = !isSortedByAscendingOrder;
                });
              },
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //       icon: Icon(Icons.add),
          //       onPressed: () => _openTransactionFormModal(context)),
          // ),
        ],
        // automaticallyImplyLeading: false,
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
                  children: _meusProcessos.map((proc) {
                    return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color:
                              Colors.red[900], // Theme.of(context).errorColor,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 38,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) {
                          return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('Tem certeza?'),
                                    content: Text(
                                        'Quer remover o processo da sua lista ?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Não'),
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Sim'),
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                        },
                                      ),
                                    ],
                                  ));
                        },
                        onDismissed: (_) {
                          final String procToRemove = proc.processo;
                          print("procToRemove $procToRemove");
                          setState(() {
                            _removeProcesso(procToRemove);
                          });
                        },
                        child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 5,
                            ),
                            child: Material(
                                color: Colors.amber[50],
                                child: ListTile(
                                  leading: Tooltip(
                                    message: 'Dias passados da publicação',
                                    child: CircleAvatar(
                                      backgroundColor:
                                          GenUtils.selectDaysLateColor(
                                              proc.daysLate),
                                      radius: 20,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: FittedBox(
                                          child: Text(
                                            GenUtils.selectDaysLateString(
                                                proc.daysLate),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ), //Text('${proc.id}'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                      proc.processo + ' - ' + proc.descricao,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                  // subtitle: Text(
                                  //   proc.descricao,
                                  // ),
                                  subtitle: Text(
                                      GenUtils.extraiTipoDecisaoCardProcesso(
                                              proc.tipoDecisao) +
                                          GenUtils
                                              .extraiFinalDecisaoCardProcesso(
                                                  proc.lastDecisao,
                                                  decisaoLength),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.brown,
                                      )),
                                  // selected: true,
                                  onTap: () {
                                    // Navigator.of(context)
                                    //     .pushReplacementNamed('/publicacoesmeusprocessos');
                                    final route = MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MeusProcessosMainScreen(
                                              processo: proc),
                                    );
                                    Navigator.of(context).push(route);
                                  },
                                  isThreeLine: true,
                                  // dense: true,
                                ))));
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Inclui na lista de processos',
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const BottomBar(),
    );
  }
}
