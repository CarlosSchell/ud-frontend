class AuthException implements Exception {
  // static const Map<String, String> errors = {
  //   "EMAIL_EXISTS": "E-mail existe!",
  //   "OPERATION_NOT_ALLOWED": "Operação não permitida!",
  //   "TOO_MANY_ATTEMPTS_TRY_LATER": "Tente mais tarde!",
  //   "EMAIL_NOT_FOUND": "E-mail não encontrado!",
  //   "INVALID_PASSWORD": "Senha inválida!",
  //   "USER_DISABLED": "Usuário desativado!",
  // };

  final String msg;

  const AuthException(this.msg);

  @override
  String toString() {
    if (msg.isNotEmpty) {
      return msg;
    } else {
      return "Ocorreu um erro na autenticação!";
    }
  }
}
