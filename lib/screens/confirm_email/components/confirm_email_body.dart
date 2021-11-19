import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/gen_utils.dart';
import '../../../components/rounded_button.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/auth_exception.dart';
import '../../../providers/auth.dart';
import '../../login/login_screen.dart';

class ConfirmEmailScreenBody extends StatefulWidget {
  final String urlToken;
  const ConfirmEmailScreenBody({
    Key? key,
    required this.urlToken,
  }) : super(key: key);
  @override
  _ConfirmEmailScreenBodyState createState() => _ConfirmEmailScreenBodyState();
}

class _ConfirmEmailScreenBodyState extends State<ConfirmEmailScreenBody> {
  String emailToken = 'O token do email é invalido';
  bool _isEmailTokenValid = false;
  bool _isConfirmedSuccesfully = false;

  bool _isLoading = false;
  bool _isSucess = false;

  _loadTokenData(urlToken) async {
    final String tokenToVerify = urlToken.replaceAll('/confirmemail/', '');
    Auth auth = Provider.of(context, listen: false);
    final _decodedTokenPayload = await auth.verifyToken(tokenToVerify);
    print('_decodedTokenPayload[email] - ${_decodedTokenPayload['email']}');
    setState(() {
      emailToken = _decodedTokenPayload['email'];
      _isEmailTokenValid = true;
    });
    return Future.value();
  }

  @override
  void initState() {
    //print('Entrou no InitState _ConfirmEmailScreenBody');
    super.initState();
    //print('widget.urlToken - ${widget.urlToken}');
    _loadTokenData(widget.urlToken);
  }

  Future<void> _submit(String urlToken) async {
    setState(() {
      _isLoading = true;
      _isSucess = false;
    });

    final String tokenToVerify = urlToken.replaceAll('/confirmemail/', '');
    //print('url do _submit ${tokenToVerify}');

    Auth auth = Provider.of(context, listen: false);

    try {
      await auth.confirmEmail(tokenToVerify);
      setState(() {
        _isSucess = true;
        _isConfirmedSuccesfully = true;
      });
    } on AuthException catch (error) {
      print(error);
      setState(() {
        _isSucess = false;
      });
      await GenUtils.showScreenDialog(context, error.toString());
    } catch (error) {
      print(error);
      await GenUtils.showScreenDialog(context, "Ocorreu um erro inesperado!");
      setState(() {
        _isSucess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (_isSucess == true) {
      await GenUtils.showScreenDialog(
          context, 'O email foi confirmado com sucesso!.');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no ConfirmEmailBody');
    //print('Email do ConfirmEmailBody ${emailToken}');
    final Size size = MediaQuery.of(context).size;
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
                SizedBox(height: size.height * 0.06),
                Text("Confirmar Email",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                SizedBox(height: size.height * 0.03),
                Text(emailToken,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),

                SizedBox(height: size.height * 0.03),
                if (_isLoading)
                  Column(children: <Widget>[
                    Text(
                      "Aguarde! Confirmando o email...",
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
                // endif
                if (!_isLoading)
                  RoundedButton(
                      text: "Confirmar",
                      color: Colors.blue,
                      textColor: Constants.kPrimaryColor,
                      isActiveButton: _isEmailTokenValid,
                      press: () {
                        _submit(widget.urlToken);
                      }),
                // endif
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Link Expirado ?",
                      style: TextStyle(
                          fontSize: 16, color: Constants.kPrimaryColor),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return null;
                        //        //WelcomeScreen();
                        //     },
                        //   ),
                        // );
                      },
                      child: Text(" Reenviar Link",
                          style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                //
                if (_isConfirmedSuccesfully)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Agora use o UDEX no seu celular,",
                        style: TextStyle(
                            fontSize: 16, color: Constants.kPrimaryColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child: Text("ou Vá para o Sistema UDEX na Web",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  )
                // endif
              ]),
        ),
      ),
    );
  }
}


                          // onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return null;
                            //        //WelcomeScreen();
                            //     },
                            //   ),
                            // );
                          //},
// const confirmEmail = asyncHandler(async (req, res, next) => {
//   if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
//     token = req.headers.authorization.split(' ')[1]
//   }

//   console.log('confirmEmailtoken: ', token)

//   if (!token) {
//     return next(new AppError('O token de autorização não válido! Solicite nova confirmação de email', 401))
//   }

//   const decoded = verifyToken(token, next) //Synchronous

//   const email = decoded.email
//   const user = await User.findOne({ email })

//   if (!user) {
//     return next(new AppError(`Usuário não encontrado para este email ${email}`, 404))
//   }

//   if (token !== user.tokenEmailConfirm) {
//     console.log('Token : ', token)
//     console.log('tokenEmailConfirm : ', user.tokenEmailConfirm)
//     return next(new AppError('O token de autorização não válido! Solicite novo link de confirmação !', 404))
//   }

//   user.isConfirmedUser = true
//   user.tokenEmailConfirm = ''
//   await user.save()

//   console.log('O email do usuário foi confirmado!')

//   res.status(200).json({
//     status: 'success',
//     message: 'O email do usuário foi confirmado!',
//     user: {
//       email: user.email,
//     },
//   })
// })

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
