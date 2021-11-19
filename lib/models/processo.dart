//import 'dart:convert';
// import 'dart:math';

import './publicacao.dart';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import '../constants/constants.dart';

class Processo {
  String processo = '';
  String descricao = '';
  List<Publicacao> publicacoes = [];

  Processo({
    required this.processo,
    required this.descricao,
    required this.publicacoes,
  });

  int _daysLate = 0;
  String _lastDecisao = '';
  String _tipoDecisao = '';
  // Random().nextInt(50); // 0;
  // List<Publicacao> publicacoes = [];

  get daysLate {
    return _daysLate;
  }

  setDaysLate(days) {
    _daysLate = days;
  }

  get lastDecisao {
    return _lastDecisao;
  }

  setLastDecisao(decisao) {
    _lastDecisao = decisao;
  }

  get tipoDecisao {
    return _tipoDecisao;
  }

  setTipoDecisao(decisao) {
    _tipoDecisao = decisao;
  }

  // get getPublicacoes => [...publicacoes];

  // set setPublicacoes(listaPublicacoesDB) {
  //   print('Dentro da Classe Processo: ${listaPublicacoesDB}');
  //   _publicacoes = listaPublicacoesDB;
  // }

  factory Processo.fromJson(Map<String, dynamic> json) {
    return Processo(
        processo: json["processo"].toString(),
        descricao: json["descricao"].toString(),
        publicacoes: []);
  }

  Map<String, dynamic> toJson() {
    return {
      "processo": processo,
      "descricao": descricao,
      "publicacoes": publicacoes,
    };
  }
}

// Map<String, dynamic> toJson() {
//   return {
//     "processo": processo,
//     "descricao": descricao,
//   };
// }

// Processo.fromJson(Map<String, dynamic> json)
//   : processo = json['processo'],
//     descricao = json['descricao'];

// class User {
//   final String name;
//   final String email;

//   User(this.name, this.email);

//   User.fromJson(Map<String, dynamic> json)
//       : name = json['name'],
//         email = json['email'];

//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "email": email,
//     };
//   }

// }

// Processo.fromDocument(Map<String, String> document) {
//   processo = document['processo'] as String;
//   descricao = document['descricao'] as String;
//   //this.isUpdated = false,
// }

//_processos: json["processos"].map<Processo>((processo) => Processo.fromJson(processo)

// get processo {
//   return _processo;
// }

// void _toggleFavorite() {
//   isFavorite = !isFavorite;
//   notifyListeners();
// }

// Future<void> toggleFavorite(String token, String userId) async {
//   // _toggleFavorite();

//   try {
//     final url = Uri.parse(
//         '${Constants.BASE_API_URL}/userFavorites/$userId/$id.json?auth=$token');
//     final response = await http.put(
//       url,
//       body: json.encode(isFavorite),
//     );

//     if (response.statusCode >= 400) {
//       _toggleFavorite();
//     }
//   } catch (error) {
//     _toggleFavorite();
//   }
// }
