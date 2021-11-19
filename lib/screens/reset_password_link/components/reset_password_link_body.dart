// import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/rounded_button.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/auth_exception.dart';
import '../../../providers/auth.dart';
import '../../../utils/gen_utils.dart';

class ResetPasswordLinkBody extends StatefulWidget {
  const ResetPasswordLinkBody({
    Key? key,
  }) : super(key: key);
  @override
  _ResetPasswordLinkBodyState createState() => _ResetPasswordLinkBodyState();
}

class _ResetPasswordLinkBodyState extends State<ResetPasswordLinkBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isSucess = false;
  bool _isReadyToSend = true;
  // bool _isConfirmedSuccesfully = false;
  // String emailToken = 'Digite aqui o seu email';
  // bool _isEmailTokenValid = false;
  // bool _isConfirmedSuccesfully = true;

  // Future<void> _submit {
  // }

  // @override
  // void initState() {
  //   print('Entrou no InitState _ForgotPasswordScreenBody');
  //   super.initState();
  // }

  Future<void> _submit(
    String _email,
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
      await auth.sendResetPasswordLink(
        _email,
      );
      setState(() {
        _isSucess = true;
        _isLoading = false;
      });
      await GenUtils.showScreenDialog(context,
          "O link foi enviado com sucesso !. Verifique a sua caixa de email para alterar a sua senha!");
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
    } 
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no _resetPasswodLinkBody');
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
                SizedBox(height: size.height * 0.05),
                Text("Solicitar link para mudar a senha",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                SizedBox(height: size.height * 0.03),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                      inputFormatters: [LengthLimitingTextInputFormatter(60)],
                      decoration: InputDecoration(
                        hintText: 'digite aqui o seu email',
                        border: OutlineInputBorder(),
                        icon: Icon(
                          Icons.email,
                          color: Colors.grey[800],
                        ),
                      ),
                      controller: _emailController,
                      enabled: true,
                      validator: (value) {
                        final String _value = value ?? '';
                        final isValidEmail = EmailValidator.validate(_value);
                        if (!isValidEmail) {
                          return 'Email Inválido!';
                        }
                        setState(() {
                          _isReadyToSend = true;
                        });
                        return null;
                      }),
                ),
                if (_isLoading)
                  Column(children: <Widget>[
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "Aguarde! Solicitando link",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Constants.kTextColor,
                      ),
                    ),
                    Text(
                      "para atualizar a senha...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Constants.kTextColor,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    CircularProgressIndicator(),
                    SizedBox(height: size.height * 0.03),
                  ])
                else
                  SizedBox(height: size.height * 0.01),
                RoundedButton(
                    text: "Solicitar Link",
                    color: Colors.blue,
                    textColor: Constants.kPrimaryColor,
                    isActiveButton: _isReadyToSend,
                    press: () {
                      _submit(_emailController.text);
                      // setState(() {
                      //   _isConfirmedSuccesfully = true;
                      // });
                    }),
                SizedBox(height: size.height * 0.03),
                if (_isSucess)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Agora acesse o seu email,",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(" e clique no link para confirmar a senha",
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
