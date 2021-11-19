import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../utils/gen_utils.dart';
import '../../../components/rounded_button.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/auth_exception.dart';
import '../../../providers/auth.dart';
import '../../login/login_screen.dart';

class ResetPasswordBody extends StatefulWidget {
  final String urlToken;
  const ResetPasswordBody({
    Key? key,
    required this.urlToken,
  }) : super(key: key);
  @override
  _ResetPasswordBodyState createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String emailToken = '';
  bool _isPasswordTokenValid = false;
  //bool _isConfirmedSuccesfully = false;

  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isObscurePasswordText = true;
  bool _isObscurePasswordConfirmText = true;

  _loadTokenData(urlToken) async {
    final String tokenToVerify = urlToken.replaceAll('/resetpassword/', '');
    Auth auth = Provider.of(context, listen: false);
    final _decodedTokenPayload = await auth.verifyToken(tokenToVerify);
    print('_decodedTokenPayload[email] - ${_decodedTokenPayload['email']}');
    setState(() {
      emailToken = _decodedTokenPayload['email'];
      _isPasswordTokenValid = true;
    });
    return Future.value();
  }

  @override
  void initState() {
    //print('Entrou no InitState _ResetPasswordScreenBody');
    super.initState();
    //print('widget.urlToken - ${widget.urlToken}');
    _loadTokenData(widget.urlToken);
  }

  Future<void> _submit(
    String _urlToken,
    String _password,
    String _passwordConfirm,
  ) async {
    //print('Entrou no _submit ');
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    final String _tokenToVerify = _urlToken.replaceAll('/resetpassword/', '');
    //print('url do _submit : ${_tokenToVerify}');

    _formKey.currentState!.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      await auth.resetPassword(
        _tokenToVerify,
        _password,
        _passwordConfirm,
      );
      setState(() {
        _isSuccess = true;
      });
    } on AuthException catch (error) {
      print(error);
      await GenUtils.showScreenDialog(context, error.toString());
      setState(() {
        _isSuccess = false;
      });
    } catch (error) {
      print(error);
      await GenUtils.showScreenDialog(context, "Ocorreu um erro inesperado!");
      setState(() {
        _isSuccess = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (_isSuccess == true) {
      await GenUtils.showScreenDialog(
          context, "A nova senha foi atualizada com sucesso!.");
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('Entrou no resetPasswordBody');
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
                  SizedBox(height: size.height * 0.03),
                  Text(emailToken,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      )),
                  SizedBox(height: size.height * 0.02),
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
                        // setState(() {
                        //   _isPasswordTokenValid = false;
                        // });
                        final String _value = value ?? '';
                        if (_value.length < 6) {
                          return 'Senha deve ter mais de 5 digitos.';
                        }
                        if (_passwordController.text !=
                            _passwordConfirmController.text) {
                          return 'As senhas devem ser idênticas.';
                        }
                        setState(() {
                          _isPasswordTokenValid = true;
                        });
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  if (_isLoading)
                    Column(children: <Widget>[
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
                  // endif
                  if (!_isLoading)
                    RoundedButton(
                      text: "Atualizar senha",
                      color: Constants.kPrimaryColor,
                      textColor: Constants.kPrimaryColor,
                      isActiveButton: _isPasswordTokenValid,
                      //     _isPasswordTokenValid, // && _isConfirmedSuccesfully,
                      press: () {
                        _submit(
                          widget.urlToken,
                          _passwordController.text,
                          _passwordConfirmController.text,
                        );
                      },
                    ),
                  //endif
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
                  if (_isSuccess) //(_isSuccess)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Agora use o UDEX no seu celular,",
                          style: TextStyle(
                              fontSize: 18, color: Constants.kPrimaryColor),
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
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    )
                  // endif
                ]),
          ),
        ),
      ),
    );
  }
}

// Future<void> _localResetPassword(String urlToken) async {
//   print("Entrou na rotina localResetPassword");
//   setState(() {
//     _isLoading = true;
//     _isSuccess = false;
//   });

//   final String tokenToVerify = urlToken.replaceAll('/resetpassword/', '');
//   print('Dentro do localResetPassword ${tokenToVerify}');

//   Auth auth = Provider.of(context, listen: false);

//   //final String tokenToVerify = urlToken;
//   // final String tokenToVerify = base64.normalize(urlToken);

//   try {
//     await auth.resetPassword(tokenToVerify);
//     setState(() {
//       _isSucess = true;
//       _isConfirmedSuccesfully = true;
//     });
//   } on AuthException catch (error) {
//     print(error);
//     setState(() {
//       _isSucess = false;
//     });
//     await GenUtils.showScreenDialog(context, error.toString());
//   } catch (error) {
//     print(error);
//     await GenUtils.showScreenDialog(
//         context, "Ocorreu um erro na validação do token!");
//     setState(() {
//       _isSucess = false;
//     });
//   } finally {
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   if (_isSucess == true) {
//     await GenUtils.showScreenDialog(
//         context, 'O email da nova conta foi confirmado com sucesso!.');
//   }

//   setState(() {
//     _isLoading = false;
//   });
// }

// 15:40hs
// https://my-lex.app/#/resetpassword/eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImNhcmxvcy5zY2hlbGxlbmJlcmdlckBnbWFpbC5jb20iLCJpYXQiOjE2MjcyMzc3OTcsImV4cCI6MTYyNzI0MTM5N30.BZtOoSC6mxc6ZX-J_rRtLjYJuVbqBVKvSyZikeH32H684m_gGZgX6b-pEGjePwjmZfN5DlfqWtwqQikNPDoB5DQdDYCeypuo9g0-CzAdIIUZdp7lqs6bkWHM2wbHXODNHI39R6e2uKMDqazk5gqlyZCarpuuiJy4_Ae_9VnJkQqgBr9jOMoce5O94BIsMMBvtHHsW06pR17k1142EZf5-d8gsGB6lREMBsFi1-iQOUjZufdX47Q0fmnQBq1K36VWUrBoPRczIayspkap-aS99H3jvxUix7rYcjEmyLXrtbJKGNljUPdGDTCZcrSCJmKTEmAH7dNMY55wp0RtHvFr4Q