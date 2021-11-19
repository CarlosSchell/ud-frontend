//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

//import '../providers/auth.dart';
import '../models/processo.dart';

class ProcessosManager extends ChangeNotifier{

  ProcessosManager(){
    _loadAllProcessos();
  }

  List<Processo> allProcessos = [];
  
  Future<void> _loadAllProcessos() async {
    // final QuerySnapshot snapProducts =
    //   await firestore.collection('products')
    //       .where('deleted', isEqualTo: false).getDocuments();

    // allProcessos = snapProducts.documents.map(
    //         (d) => Processo.fromDocument(d)).toList();

    notifyListeners();
  }

  Processo? findProcessoByProcesso(String processo){
    try {
      return allProcessos.firstWhere((p) => p.processo == processo);
    } catch (e){
      return null;
    }
  }

  void update(Processo processo){
    allProcessos.removeWhere((p) => p.processo == processo.processo);
    allProcessos.add(processo);
    notifyListeners();
  }

  void delete(Processo processo){
    // processo.delete();
    allProcessos.removeWhere((p) => p.processo == processo.processo);
    notifyListeners();
  }
}