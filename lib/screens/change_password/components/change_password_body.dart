import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//import './background.dart';
// import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/rounded_button.dart';
// import '../../../components/rounded_input_field.dart';
// import '../../../components/rounded_password_confirm_field.dart';
// import '../../../components/rounded_password_field.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/auth_exception.dart';
import '../../../utils/gen_utils.dart';
//import './social_icon.dart';
import '../../../providers/auth.dart';

class ChangePasswordBody extends StatefulWidget {
  const ChangePasswordBody({
    Key? key,
  }) : super(key: key);
  @override
  _ChangePasswordBodyState createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _isLoading = false;
  bool _isSucess = false;
  bool _isObscurePasswordText = true;
  bool _isObscurePasswordConfirmText = true;

  Future<void> _submit(
    String _password,
    String _passwordConfirm,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    print('Entrou no _submit');

    setState(() {
      _isLoading = true;
      _isSucess = false;
    });

    _formKey.currentState!.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      await auth.changePassword(
        _password,
        _passwordConfirm,
      );
      setState(() {
        _isSucess = true;
      });
    } on AuthException catch (error) {
      print(error);
      GenUtils.showScreenDialog(context, error.toString());
      setState(() {
        _isSucess = false;
      });
    } catch (error) {
      print(error);
      GenUtils.showScreenDialog(context, "Ocorreu um erro inesperado!");
      setState(() {
        _isSucess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (_isSucess == true) {
      GenUtils.showScreenDialog(context, "A nova senha foi atualizada com sucesso!.");
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no ChangePasswordBody');
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // minWidth: 360,
            maxWidth: 450,
          ),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 360 * 0.12),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      obscureText: _isObscurePasswordText, // true,
                      key: ValueKey('password'),
                      cursorColor: Constants.kPrimaryColor,
                      keyboardType: TextInputType.text,
                      keyboardAppearance: Brightness.light,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(60)],
                      decoration: InputDecoration(
                        hintText: "Senha",
                        border: OutlineInputBorder(),
                        //border: InputBorder.none,
                        icon: Icon(
                          Icons.lock,
                          color: Colors.grey[800],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility),
                          color: Colors.grey[800],
                          onPressed: () {
                            setState(() {
                              _isObscurePasswordText = !_isObscurePasswordText;
                            });
                          },
                        ),
                      ),
                      controller: _passwordController,
                      enabled: !_isLoading,
                      validator: (value) {
                        final String _value = value ?? '';
                        if (_value.length < 6) {
                          return 'A senha deve ter no mínimo 6 digitos.';
                        }
                        if (_value.length > 60) {
                          return 'A senha deve ter no máximo 60 digitos.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      obscureText: _isObscurePasswordConfirmText, // true,
                      key: ValueKey('passwordConfirm'),
                      cursorColor: Constants.kPrimaryColor,
                      keyboardType: TextInputType.text,
                      keyboardAppearance: Brightness.light,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(60)],
                      decoration: InputDecoration(
                        hintText: "Confirme a Senha",
                        border: OutlineInputBorder(),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.grey[800],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility),
                          color: Colors.grey[800],
                          onPressed: () {
                            setState(() {
                              _isObscurePasswordConfirmText =
                                  !_isObscurePasswordConfirmText;
                            });
                          },
                        ),
                      ),
                      controller: _passwordConfirmController,
                      enabled: !_isLoading,
                      validator: (value) {
                        final String _value = value ?? '';
                        if (_value.length < 6) {
                          return 'Senha deve ter mais de 5 digitos.';
                        }
                        if (_passwordController.text !=
                            _passwordConfirmController.text) {
                          return 'As senhas devem ser idênticas.';
                        }
                        return null;
                      },
                    ),
                  ),
                  if (_isLoading)
                    Column(children: <Widget>[
                      SizedBox(height: size.height * 0.03),
                      Text(
                        "Aguarde! Atualizando a nova senha...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Constants.kTextColor,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      CircularProgressIndicator(),
                      SizedBox(height: size.height * 0.03),
                    ]),
                  if (!_isLoading)
                    Column(children: <Widget>[
                      RoundedButton(
                        text: "Atualizar senha",
                        color: Constants.kPrimaryColor,
                        textColor: Constants.kPrimaryColor,
                        isActiveButton: true,
                        press: () {
                          print('Enviou para o _submit');
                          _submit(
                            _passwordController.text,
                            _passwordConfirmController.text,
                          );
                        },
                      ),
                    ]),
                ]),
          ),
        ),
      ),
    );
  }
}
