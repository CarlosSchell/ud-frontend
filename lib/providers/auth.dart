import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../../../exceptions/auth_exception.dart';
import '../../../utils/gen_utils.dart';
import '../constants/constants.dart';
import '../localstore/localstore.dart';
import '../models/processo.dart';
import '../models/publicacao.dart';

//https://stackoverflow.com/questions/67874638/flutter-no-such-method-error-while-calling-close-function-on-timer

class Auth with ChangeNotifier {
  String _userId = '';
  String _name = '';
  String _email = '';
  String _role = '';
  String _token = '';
  List<Processo> _processos = [];

  DateTime _expiryDate = DateTime.now();
  //Timer _logoutTimer = Timer(Duration(seconds: 60), (){});

  int _selectedBottomMenuItem = 0;
  int get getSelectedBottomMenuItem => _selectedBottomMenuItem;

  void setSelectedBottomMenuItem(value) {
    _selectedBottomMenuItem = value;
    // notifyListeners();
  }

  bool get isAuth => token != '';
  // String get userId => isAuth ? _userId : '';
  String get name => _name;
  String get email => _email;
  String get role => _role;

  String get token {
    if (_token != '' &&
        // ignore: unrelated_type_equality_checks
        _expiryDate != '' &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return '';
    }
  }

  List get processos => [..._processos];
  int get processosCount => _processos.length;

  int _novasPublicaoes20dias = 0;

  int get novasPublicaoes20dias => _novasPublicaoes20dias;

  void setNovasPublicaoes20dias(int value) {
    _novasPublicaoes20dias = value;
    notifyListeners();
  }

  void addNovasPublicaoes20dias(int value) {
    _novasPublicaoes20dias = _novasPublicaoes20dias + value;
    notifyListeners();
  }

  String processosJson(_processos) => jsonEncode(_processos);

  Future<void> gravaUserLocalStore() async {
    await LocalStore.saveMap('userData', {
      "userId": _userId,
      "name": _name,
      "email": _email,
      "role": _role,
      "token": _token,
      "expiryDate": _expiryDate.toIso8601String(),
    });
    print('Gravou dados do Usuário na LocalStore');
    print(_expiryDate.toIso8601String());
  }

  Future<void> getOneUser() async {
    print('Entrou no auth.getOneUser');
    print('Token : $token');
    // atualiza o campo auth._processos;
    final String url = Constants.BASE_API_URL + 'users/oneuser';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final responseBody = json.decode(response.body);
    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      _name = '';
      _email = '';
      _role = '';
      _token = '';
      _processos = [];
      throw AuthException(responseBody["message"]);
    } else {
      _name = responseBody["user"]["name"];
      _email = responseBody["user"]["email"];
      _role = responseBody["user"]["role"];
    }
    print('3 - Achou o usuário no banco de dados : $_email');

    notifyListeners();
    return Future.value();
  }

  Future<void> tryAutoLogin() async {
    print('-------------------------------------------');
    print('0 - Entrou no autologin');

    // Verifica os dados do usuário na localStore
    print("1 - Verifica os dados do usuário na localStore.");
    final userData = await LocalStore.getMap('userData');
    if (userData.isEmpty) {
      print(
          '1  - Não encontrou dados do usuário na localStore'); // : ${userData}
    } else {
      _userId = userData["userId"] ?? '';
      _name = userData["name"] ?? '';
      _email = userData["email"] ?? '';
      _role = userData["role"] ?? '';
      _token = userData["token"] ?? '';
      //_expiryDate = userData["expiryDate"] ?? DateTime.now();
      //print('_expiryDate do token: ${_expiryDate.toIso8601String()}');
      //_processos = [];

      print('1  - Encontrou os dados do usuário na localStore : $_email');
      // Verifica a data de vencimento do token da localStore
      print("2 - Verifica a data de expiração do token da localStore");
      final _decodedTokenPayload = await verifyToken(_token);
      if (!(_decodedTokenPayload.isEmpty)) {
        int _milliseconds = _decodedTokenPayload['exp'] * 1000;
        _expiryDate = DateTime.fromMillisecondsSinceEpoch(
          _milliseconds,
          isUtc: false,
        );
      }

      if (_expiryDate.isBefore(DateTime.now())) {
        print('2  - Data token expirada: ${_expiryDate.toIso8601String()}');
      } else {
        print('2  - Data token válida: ${_expiryDate.toIso8601String()}');

        //print('3 - Verifica o usuário no banco de dados e pega os processos');
        await getOneUser();
        await gravaUserLocalStore();

        // Ativa o timer de logout automatico
        // _logoutTimer.cancel();
        // final _timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
        // _logoutTimer = Timer(Duration(seconds: _timeToLogout), logout);

        //_setAutoLogoutTimer();

        if (isAuth) {
          print("4 - O usuário já está logado e verificado.:  $_email");
          //_setAutoLogoutTimer();
        }
      }
    }

    notifyListeners();
    return Future.value();
  }

  Future<void> loadProcessos() async {
    print('Entrou no auth.loadProcessos');
    //print('Token : $token');
    final String url = Constants.BASE_API_URL + 'users/getprocessos';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    } else {
      final List _processosList = responseBody["data"]["processos"].toList();

      _processos =
          _processosList.map((proc) => Processo.fromJson(proc)).toList();

      //atualiza a lista _processos=> processo.publicacoes
      await Future.forEach(_processos, (proc) async {
        await getPublicacoesProcesso(proc);
      });

      //Calcula daysLate da ultima publicacao de cada processo
      //Coloca o texto da decisao da ultima publicacao de cada processo no card do processo
      setNovasPublicaoes20dias(0);
      _processos.forEach((proc) {
        atualizaDadosCardProcesso(proc);
      });
    }
    notifyListeners();
    return Future.value();
  }

  Future<List<Publicacao>> getPublicacoesProcesso(processo) async {
    print('getPublicacoes: ${processo.processo}');
    //String token = _token;
    //print('Token : $token');

    final String url = Constants.BASE_API_URL + 'publicacao/processo';
    String bodyEncoded = jsonEncode({
      "processo": processo.processo,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: bodyEncoded,
    );
    final responseBody = await jsonDecode(response.body);

    List<Publicacao> _publicacoes = [];

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    } else {
      final List _publicacoesList =
          responseBody["data"]["publicacoes"].toList();
      _publicacoes =
          _publicacoesList.map((publi) => Publicacao.fromJson(publi)).toList();
    }
    processo.publicacoes = _publicacoes;

    return Future.value(_publicacoes);
  }

  void atualizaDadosCardProcesso(processo) {
    int _minimumDaysLate = 1000000;
    final List<Publicacao> _publicacoes = processo.publicacoes;
    _publicacoes.forEach((publi) {
      final int daysLate = GenUtils.daysBetween(
          DateTime(
            int.parse(publi.ano),
            int.parse(publi.mes),
            int.parse(publi.dia),
          ),
          DateTime.now());
      if (daysLate < _minimumDaysLate) {
        _minimumDaysLate = daysLate;
        processo.setDaysLate(daysLate);
        processo.setLastDecisao(publi.decisao);
        processo.setTipoDecisao(publi.tipo);
      }
      if (daysLate <= 20) {
        addNovasPublicaoes20dias(1);
      }
    });
  }

  Future<void> gravaProcessos(_processos) async {
    print('Entrou no auth.gravaProcessos');
    //print('Token : $token');

    // Antes de gravar a lista de processos no banco de dados retira as publicações do objeto Processo
    List<Processo> _processosSemPublicacoes = [];

    _processos.forEach((proc) {
      //print(proc.processo);
      String processoInput = proc.processo;
      String descricaoInput = proc.descricao;
      Processo novoProcesso = new Processo(
          processo: processoInput, descricao: descricaoInput, publicacoes: []);
      _processosSemPublicacoes.add(novoProcesso);
    });

    // _processosSemPublicacoes.forEach((proc) {
    //   print(proc.processo);
    //   print(proc.descricao);
    //   print(proc.publicacoes);
    // });

    final encodedBody = jsonEncode({
      "email": _email,
      "processos": _processosSemPublicacoes,
    });
    //print('Passou do encodedBody');
    final String url = Constants.BASE_API_URL + 'users/gravaprocessos';
    final body = encodedBody;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    //print('Antes do decode response body');
    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    }

    return Future.value();
  }

  Future<void> excluiProcesso(String processo) async {
    print('Entrou no auth.excluiProcesso');
    //print('Token : $token');

    _processos.removeWhere((proc) => proc.processo == processo);
    print('Processo para excluir $processo');
    //print('Lista depois da exclusão  ${_processos}');

    // List _processosList = [];
    // _processos.forEach((item) => {print(item)}); // {print(item.toJson())});
    // print('Entrou no excluiProcesso - encoding');
    // _processos.forEach((item) => {_processosList.add(item.toJson())});

    //print('Vai entrar no gravaProcessos ');
    await gravaProcessos(_processos);
    //print('Excluiu processo ${processo}');
    //print('Processos restantes  ${_processos}');

    notifyListeners();
  }

  Future<void> adicionaProcesso(String processo, String descricao) async {
    print('Entrou no auth.adicionaProcesso');
    //print('Token : $token');

    Processo newProcesso = Processo(
      processo: processo,
      descricao: descricao,
      publicacoes: [],
    );

    newProcesso.publicacoes = await getPublicacoesProcesso(newProcesso);
    atualizaDadosCardProcesso(newProcesso);

    _processos.add(newProcesso);
    await gravaProcessos(_processos);
    notifyListeners();
  }

  Future verifyToken(tokenToVerify) async {
    print('Entrou no verify token ${tokenToVerify.substring(0, 10)}');

    Future<String> loadPublicKey() async {
      return await rootBundle.loadString('assets/keys/public.key');
    }

    String _publicKeyValue = await loadPublicKey();
    try {
      final jwt = JWT.verify(tokenToVerify, RSAPublicKey(_publicKeyValue));
      return jwt.payload;
    } on JWTExpiredError {
      print('jwt expired');
      //throw AuthException('jwt expired');
      return {};
    } on JWTError catch (ex) {
      print(ex.message);
      //throw AuthException(ex.message); // ex: invalid signature
      return {};
    }
    //return Future.value();
  }

  Future<void> login(String email, String password) async {
    print("Entrou no auth login:");

    final String url = Constants.BASE_API_URL + 'users/login';
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
          {'email': email, 'password': password},
        ));

    final responseBody = await json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    } else {
      _userId = '';
      _name = responseBody["data"]["name"];
      _email = responseBody["data"]["email"];
      _role = responseBody["data"]["role"];
      _token = responseBody["data"]["token"];
      final List _processosList = responseBody["data"]["processos"].toList();
      _processos =
          _processosList.map((proc) => Processo.fromJson(proc)).toList();

      final _decodedTokenPayload = await verifyToken(_token);
      if (!(_decodedTokenPayload.isEmpty)) {
        int _milliseconds = _decodedTokenPayload['exp'] * 1000;

        _expiryDate = DateTime.fromMillisecondsSinceEpoch(
          _milliseconds,
          isUtc: false,
        );
      }
      await gravaUserLocalStore();
      // Ativa o timer de logout automatico
      // _logoutTimer.cancel();
      // final _timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
      // _logoutTimer = Timer(Duration(seconds: _timeToLogout), logout);
      notifyListeners();
    }

    return Future.value();
  }

  void logout() async {
    print('Entrou no logout');
    //print('Token : $token');
    _userId = '';
    _name = '';
    _email = '';
    _role = '';
    _token = '';
    _processos = [];
    _expiryDate = DateTime.now();
    //_logoutTimer.cancel();
    await LocalStore.remove('userData');
    notifyListeners();
    print('Saiu ---> Logged Out');
    return Future.value();
  }

  //  _setAutoLogoutTimer() {
  //   print('Entrou no _setAutoLogoutTimer');
  //   //_logoutTimer.cancel();
  //   //final _timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
  //   // _logoutTimer = Timer(Duration(seconds: _timeToLogout), logout);
  //   //print(_timeToLogout);
  //   //_logoutTimer = Timer(Duration(seconds: 3600), logout);

  // }

  Future<void> signup(
    String name,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    final String url = Constants.BASE_API_URL + 'users/register';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    }

    return Future.value();
  }

  Future<void> confirmEmail(String urlToken) async {
    final String url = Constants.BASE_API_URL + 'users/confirmemail';
    DateTime _expiryDate = DateTime.now();

    final _decodedTokenPayload = await verifyToken(urlToken);
    if (!(_decodedTokenPayload.isEmpty)) {
      int _milliseconds = _decodedTokenPayload['exp'] * 1000;
      _expiryDate = DateTime.fromMillisecondsSinceEpoch(
        _milliseconds,
        isUtc: false,
      );
    }
    if (_expiryDate.isBefore(DateTime.now())) {
      throw AuthException(
          'Token inválido: data expirada! Solicite novo email de confirmação!');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $urlToken',
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    }

    return Future.value();
  }

  Future<void> resetPassword(
      String urlToken, String password, String passwordConfirm) async {
    final String url = Constants.BASE_API_URL + 'users/resetpassword';
    DateTime _expiryDate = DateTime.now();

    // verifica os dados do urlToken
    final _decodedTokenPayload = await verifyToken(urlToken);
    if (!(_decodedTokenPayload.isEmpty)) {
      int _milliseconds = _decodedTokenPayload['exp'] * 1000;
      _expiryDate = DateTime.fromMillisecondsSinceEpoch(
        _milliseconds,
        isUtc: false,
      );
    }
    if (_expiryDate.isBefore(DateTime.now())) {
      throw AuthException(
          'Token inválido: data expirada! Solicite novo link para alteração da senha!');
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $urlToken',
      },
      body: {
        'password': password,
        'passwordConfirm': passwordConfirm,
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    }

    return Future.value();
  }

  // Altera o password de dentro do app (request normal)
  Future<void> changePassword(String password, String passwordConfirm) async {
    final String url = Constants.BASE_API_URL + 'users/changePassword';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'password': password,
        'passwordConfirm': passwordConfirm,
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      return Future.value();
    }
  }

  Future<void> sendResetEmailLink(String emailToSend) async {
    final String url = Constants.BASE_API_URL + 'users/sendresetemaillink';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': emailToSend,
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    }

    return Future.value();
  }

  Future<void> sendResetPasswordLink(String emailToSend) async {
    final String url = Constants.BASE_API_URL + 'users/sendresetpasswordlink';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': emailToSend,
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    }

    return Future.value();
  }

  Future<void> sendEmail(String name, String email, String message) async {
    final String url = Constants.BASE_API_URL + 'geral/enviaemail';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'email': email,
        'message': message,
      },
    );

    final responseBody = json.decode(response.body);

    if ((responseBody["status"] == "fail") |
        (responseBody["status"] == "error")) {
      throw AuthException(responseBody["message"]);
    }

    return Future.value();
  }
}
