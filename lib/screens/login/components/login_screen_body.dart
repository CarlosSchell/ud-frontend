import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_routes.dart';
import '../../../../utils/gen_utils.dart';
import '../../../components/rounded_button.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/auth_exception.dart';
import '../../../providers/auth.dart';
import '../../home/home_screen.dart';
import '../../reset_password_link/reset_password_link_screen.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({
    Key? key,
  }) : super(key: key);
  @override
  _LoginScreenBodyState createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isSucess = false;
  bool _isObscureText = true;

  Future<void> _submit(String _email, String _password) async {
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
      await auth.login(
        _email,
        _password,
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
        // await _showErrorDialog("O login foi efetuado com sucesso!");
        Navigator.of(context).pop();
        if (auth.isAuth) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no LoginScreen');
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 360,
            maxWidth: 450,
          ),
          child: Column(
              //width: 360,
              //mainAxisSize: MainAxisSize.min,
              //crossAxisSize: CrossAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.003),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: (size.width >= 360)
                            ? (size.width * 0.9)
                            : (360 * 0.9),
                        decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                            // autofocus: true,
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
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              // focusedBorder: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                              // border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
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
                              return null;
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        width: (size.width >= 360)
                            ? (size.width * 0.9)
                            : (360 * 0.9),
                        decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                            autocorrect: false,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.none,
                            obscureText: _isObscureText, // true,
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
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              icon: Icon(
                                Icons.lock,
                                color: Colors.grey[800],
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                color: Colors.grey[800],
                                onPressed: () {
                                  setState(() {
                                    _isObscureText = !_isObscureText;
                                  });
                                },
                              ),
                            ),
                            controller: _passwordController,
                            enabled: !_isLoading,
                            validator: (value) {
                              final String _value = value ?? '';
                              if (_value.length < 6) {
                                return 'Senha deve ter mais de 5 digitos.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (e) {
                              _submit(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }),
                      ),
                      if (_isLoading)
                        Column(children: <Widget>[
                          SizedBox(height: size.height * 0.03),
                          CircularProgressIndicator(),
                          SizedBox(height: size.height * 0.03),
                        ])
                      else
                        RoundedButton(
                          text: "Entrar",
                          color: Constants.kPrimaryColor,
                          textColor: Constants.kPrimaryColor,
                          isActiveButton: true,
                          press: () {
                            _submit(
                              _emailController.text,
                              _passwordController.text,
                            );
                          },
                        ),
                      SizedBox(height: size.height * 0.02),
                      Wrap(
                        spacing: 4,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Esqueceu sua senha ?",
                            style: TextStyle(
                                fontSize: 16, color: Constants.kPrimaryColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ResetPasswordLinkScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "  Nova Senha ",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Wrap(
                          spacing: 4,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Não tem uma conta ? ",
                              style: TextStyle(
                                  fontSize: 16, color: Constants.kPrimaryColor),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/signup');
                              },
                              //style : TextStyle(textColor: Colors.white,
                              child: Container(
                                // margin: const EdgeInsets.only(right: 5.0),
                                child: const Text(
                                  'Criar Conta',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ]),
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
                          ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}



// onSaved: (value) {
//   // final String _value = value ?? '';
//   // setState(() {
//   //   _authData['email'] = _value;
//   // });
//   print('Valor dentro do email onSaved');
//   print(_emailController.text);
// },

// onSaved: (value) {
//   // final String _value = value ?? '';
//   // setState(() {
//   //   _authData['password'] = _value;
//   // });
//   print('Valor dentro do password onSaved');
//   print(_passwordController.text);
// },

// final String _email = _authData["email"] ?? '';
// final String _password = _authData["password"] ?? '';

// print('Valores vindos do authcard : ');
// print('email :' + _email);
// print('password :' + _password);

// final String _email = _emailController.text;
// final String _password = _passwordController.text;

// print('Valores dentro do _submit');
// print(_emailController.text);
// print(_email);
// print(_passwordController.text);
// print(_password);

// final Map<String, String> _authData = {
//   'email': '',
//   'password': '',
// };
// 'token': '',

// Column(
//   mainAxisSize: MainAxisSize.min,
//   children: <Widget>[
//     ElevatedButton(
//       onPressed: () {
//         if (_formKey.currentState!.validate()) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               content: Text(
//                   'Aguarde!... Processando a entrada do usuário')));
//           _submit();
//         }
//       },
//       child: Text('Submit'),
//     ),
//   ],
//),
