import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProcessoForm extends StatefulWidget {
  final void Function(String, String) onSubmit;

  ProcessoForm(this.onSubmit) {
    print('Constructor ProcessoForm');
  }

  @override
  _ProcessoFormState createState() {
    print('createState ProcessoForm');
    return _ProcessoFormState();
  }
}

class _ProcessoFormState extends State<ProcessoForm> {
  final _processoController = TextEditingController();
  final _descricaoController = TextEditingController();
  // DateTime _selectedDate = DateTime.now();

  _ProcessoFormState() {
    print('Constructor _TransactionFormState');
  }

  @override
  void initState() {
    super.initState();
    print('initState() _TransactionFormState');
  }

  @override
  void didUpdateWidget(ProcessoForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget() _TransactionFormState');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose() _TransactionFormState');
  }

  _submitForm() {
    final processo = _processoController.text.trim();
    final descricao = _descricaoController.text;

    if (processo.isEmpty || descricao.isEmpty) {
      return;
    }
    if (processo.length > 25) {
      return;
    }

    final String newProcesso = ('0' * (25 - processo.length)) + processo;
    const String pattern = r'^\d{7}\-\d{2}\.\d{4}\.\d.\d{2}\.\d{4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(newProcesso)) {
      return;
    }

    widget.onSubmit(newProcesso, descricao);
  }

  @override
  Widget build(BuildContext context) {
    print('build() TransactionForm');
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        //borderRadius: BorderRadius.circular(25.0)),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _processoController,
                keyboardType: TextInputType.number,
                keyboardAppearance: Brightness.light,
                maxLength: 25,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                  FilteringTextInputFormatter.allow(RegExp("[0-9.-]")),
                ],
                onChanged: (value) {
                  print(value);
                  //_processoController.text = _processoController.text.trim();
                  print(_processoController.text.trim());
                },
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  labelText: 'Processo',
                ),
              ),
              TextField(
                controller: _descricaoController,
                keyboardType: TextInputType.text,
                keyboardAppearance: Brightness.light,
                maxLength: 60,
                inputFormatters: [LengthLimitingTextInputFormatter(60)],
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors
                          .white, //Theme.of(context).textTheme.button.color,
                    ),
                    child: Text('Incluir Processo',
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    onPressed: _submitForm,
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
