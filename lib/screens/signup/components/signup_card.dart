import 'dart:async';

import 'package:email_validator/email_validator.dart';
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
//import './or_divider.dart';
//import './social_icon.dart';
import '../../../providers/auth.dart';
import '../../../utils/gen_utils.dart';
import '../../Login/login_screen.dart';

class SignUpCard extends StatefulWidget {
  const SignUpCard({
    Key? key,
  }) : super(key: key);
  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _isLoading = false;
  bool _isSucess = false;
  bool _isObscurePasswordText = true;
  bool _isObscurePasswordConfirmText = true;

  Future<void> _submit(
    String _name,
    String _email,
    String _password,
    String _passwordConfirm,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _isSucess = false;
    });

    _formKey.currentState!.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      await auth.signup(
        _name,
        _email,
        _password,
        _passwordConfirm,
      );
      setState(() {
        _isSucess = true;
        _isLoading = false;
      });
    } on AuthException catch (error) {
      print(error);
      setState(() {
        _isSucess = false;
        _isLoading = false;
      });
      await GenUtils.showScreenDialog(context, error.toString());
    } catch (error) {
      print(error);
      setState(() {
        _isSucess = false;
        _isLoading = false;
      });
      await GenUtils.showScreenDialog(context, "Ocorreu um erro inesperado!");
    } finally {
      if (_isSucess == true) {
        await GenUtils.showScreenDialog(context,
            "A nova conta foi criada com sucesso!. Verifique a sua caixa de email para confirmar a sua conta!");
        // Navigator.of(context).pop();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return LoginScreen();
        //     },
        //   ),
        // );
      }

      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no SignUpScreenBody');
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // minWidth: 360,
            maxWidth: 450,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 360 * 0.03),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                              autofocus: true,
                              autocorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              key: ValueKey('name'),
                              cursorColor: Constants.kPrimaryColor,
                              keyboardType: TextInputType.text,
                              keyboardAppearance: Brightness.light,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Nome curto até 20 letras',
                                border: OutlineInputBorder(),
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.grey[800],
                                ),
                              ),
                              controller: _nameController,
                              enabled: !_isLoading,
                              validator: (value) {
                                final String _value = value ?? '';
                                if (_value.isEmpty) {
                                  return 'Entre com o nome!';
                                }
                                if (_value.length > 20) {
                                  return 'O nome deve ter no máximo 20 letras.';
                                }
                                print('Nome ' + _value);
                                return null;
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                              autofocus: true,
                              autocorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              key: ValueKey('email'),
                              cursorColor: Constants.kPrimaryColor,
                              keyboardType: TextInputType.emailAddress,
                              keyboardAppearance: Brightness.light,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(60)
                              ],
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(),
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.grey[800],
                                ),
                              ),
                              controller: _emailController,
                              enabled: !_isLoading,
                              validator: (value) {
                                final String _value = value ?? '';
                                final isValidEmail =
                                    EmailValidator.validate(_value);
                                if (!isValidEmail) {
                                  return 'Email Inválido!';
                                }
                                print('Email is valid? ' +
                                    (isValidEmail ? 'yes' : 'no'));
                                return null;
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(60)
                            ],
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
                                    _isObscurePasswordText =
                                        !_isObscurePasswordText;
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(60)
                            ],
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
                              "Aguarde! Criando nova conta...",
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
                              text: "Criar Conta",
                              color: Constants.kPrimaryColor,
                              textColor: Constants.kPrimaryColor,
                              isActiveButton: true,
                              press: () {
                                print('Enviou para o _submit');
                                _submit(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _passwordConfirmController.text,
                                );
                              },
                            ),
                            SizedBox(height: size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Já tem uma conta ?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Constants.kPrimaryColor),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return LoginScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " Entrar ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Confirmar Email ? ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Constants.kPrimaryColor),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                           .pushNamed('/resetemail');
                                      // Navigator.of(context)
                                      //     .pushNamed('/signup');
                                    },
                                    //style : TextStyle(textColor: Colors.white,
                                    child: Container(
                                      // margin: const EdgeInsets.only(right: 5.0),
                                      child: const Text(
                                        'Reenviar Link',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ]),
                      ]),
                ),
              ]),
        ),
      ),
    );
  }
}

// ResetEmailLinkScreen

// RoundedButton(
//   text: "Cadastrar",
//   color: Constants.kPrimaryColor,
//   textColor: Constants.kPrimaryColor,
//   press: () {},
// ),

// SizedBox(height: size.height * 0.03),
// AlreadyHaveAnAccountCheck(
//   login: false,
//   press: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) {
//           return LoginScreen();
//         },
//       ),
//     );
//   },
// )

//if (!_isLoading && _isSucess)
// Column(children: <Widget>[
//   SizedBox(height: size.height * 0.03),
//   Text(
//     "A nova conta foi criada!",
//     style: TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 22,
//       color: Constants.kTextColor,
//     ),
//   ),
//   Text(
//     "Verifique a sua caixa de email",
//     style: TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 22,
//       color: Constants.kTextColor,
//     ),
//   ),
//   Text(
//     "para confirmar a sua conta!",
//     style: TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 22,
//       color: Constants.kTextColor,
//     ),
//   ),
// ]),
