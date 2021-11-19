import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../utils/gen_utils.dart';
import '../../../components/rounded_button.dart';
import '../../../constants/constants.dart';
import '../../../exceptions/auth_exception.dart';
import '../../../providers/auth.dart';

class ContactScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Enviar Email para a Udex'),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.purple[900],
      ),
      body: ContactScreenBody(),
    );
  }
}

class ContactScreenBody extends StatefulWidget {
  const ContactScreenBody({
    Key? key,
  }) : super(key: key);
  @override
  _ContactScreenBodyState createState() => _ContactScreenBodyState();
}

class _ContactScreenBodyState extends State<ContactScreenBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;
  //bool _isSucess = false;

  Future<void> _sendContactEmail(
      String name, String email, String message) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      //_isSucess = false;
    });

    _formKey.currentState!.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      await auth.sendEmail(
        name,
        email,
        message,
      );
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        //_isSucess = true;
        _isLoading = false;
      });
      await GenUtils.showScreenDialog(
          context, "A mensagem foi enviada com sucesso!");
    } on AuthException catch (error) {
      print(error);
      setState(() {
        //_isSucess = false;
        _isLoading = false;
      });
      await GenUtils.showScreenDialog(context, error.toString());
    } catch (error) {
      print(error);
      setState(() {
        //_isSucess = false;
        _isLoading = false;
      });
      await GenUtils.showScreenDialog(context, "Ocorreu um erro inesperado!");
    } 
  }

  @override
  Widget build(BuildContext context) {
    print('Entrou no ContactScreen');
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
                      SizedBox(height: size.height * 0.004),
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
                          key: ValueKey('name'),
                          keyboardType: TextInputType.text,
                          cursorColor: Constants.kPrimaryColor,
                          keyboardAppearance: Brightness.light,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60)
                          ],
                          decoration: InputDecoration(
                            hintText: 'Nome',
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
                              Icons.person,
                              size:20,
                              color: Colors.grey[800],
                            ),
                          ),
                          controller: _nameController,
                          enabled: !_isLoading,
                        ),
                      ),
                      SizedBox(height: size.height * 0.004),
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
                      SizedBox(height: size.height * 0.004),
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
                        child: TextField(
                          maxLines: 7,
                          key: ValueKey('message'),
                          cursorColor: Constants.kPrimaryColor,
                          keyboardType: TextInputType.multiline, //TextInputType.text,
                          keyboardAppearance: Brightness.light,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10000)
                          ],
                          decoration: InputDecoration(
                            hintText: 'Mensagem',
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
                          ),
                          controller: _messageController,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      if (_isLoading)
                        Column(children: <Widget>[
                          SizedBox(height: size.height * 0.03),
                          CircularProgressIndicator(),
                          SizedBox(height: size.height * 0.03),
                        ])
                      else
                        RoundedButton(
                          text: "Enviar Mensagem",
                          color: Constants.kPrimaryColor,
                          textColor: Constants.kPrimaryColor,
                          isActiveButton: true,
                          press: () {
                            _sendContactEmail(
                              _nameController.text,
                              _emailController.text,
                              _messageController.text,
                            );
                          },
                        ),
                      //SizedBox(height: size.height * 0.05),
                      // Text(
                      //   "Email: contato@udex.app ",
                      //   style: TextStyle(fontSize: 16, color: Colors.black87),
                      // ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: Scaffold(
//     body: Padding(
//       padding: const EdgeInsets.all(20),
//       child: PageForm()
//     )
//   )
// ));

// class PageForm extends StatefulWidget {
//   @override
//   _PageFormState createState() => _PageFormState();
// }

// class _PageFormState extends State<PageForm> {
//   final _formKey = GlobalKey<FormState>();
  
//   var _autovalidate = false;
//   var _user;
//   var _password;
//   var _passwordRepeat;
  
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       autovalidate: _autovalidate,
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           FlutterLogo(size: 100),
//           SizedBox(height: 20),
//           Text('Sign up', 
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 30,
//               color: Colors.grey,
//             )),
//           SizedBox(height: 30),
//           TextFormField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Username'
//             ),
//             onChanged: (value) {
//               _user = value;
//             },
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter your username';
//               }
//               return null;
//             }
//           ),
//           SizedBox(height: 20),
//           TextFormField(
//             obscureText: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Password'
//             ),
//             onChanged: (value) {
//               _password = value;
//             },
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter your password';
//               }
//               return null;
//             }
//           ),
//           SizedBox(height: 20),
//           TextFormField(
//             obscureText: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Repeat password'
//             ),
//             onChanged: (value) {
//               _passwordRepeat = value;
//             },
//             validator: (value) {
//               if (_password != value) {
//                 return 'Passwords do not match';
//               }
//               return null;
//             }
//           ),
//           SizedBox(height: 20),
//           SizedBox(
//             width: double.infinity,
//             child: FlatButton(
//               color: Colors.blue,
//               child: Text('Submit', style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               )),
//               onPressed: () {
              
//                 if (_formKey.currentState.validate()) {
//                   print('$_user:$_password:$_passwordRepeat');
                  
//                   Scaffold.of(context)
//                     .showSnackBar(SnackBar(
//                       backgroundColor: Colors.green,
//                       content: Text('Submitted successfully :)')
//                     ));
//                 } else {
//                   Scaffold.of(context)
//                     .showSnackBar(SnackBar(
//                       backgroundColor: Colors.redAccent,
//                       content: Text('Problem submitting form :(')
//                     ));
//                   setState(() {
//                     _autovalidate = true;
//                   });
//                 }
              
//               }
//             )
//           )
//         ]
//       )
//     );
//   }
// }


