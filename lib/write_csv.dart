// import 'dart:convert';
// import 'dart:io';

// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';

// class writePesquisaCsv {
//   final String path;

//   writePesquisaCsv({required this.path});


//   Future generateCsv(listaResultadoPesquisa) async {

//   List<Map> data = [
//     { "uf": "R1", "tribunal": "TJ1", "decisao":"fica decidido abcd" },
//     { "uf": "R2", "tribunal": "TJ2", "decisao":"fica decidido efgh" },
//     { "uf": "R3", "tribunal": "TJ3", "decisao":"fica decidido ijkl" },
//     { "uf": "R4", "tribunal": "TJ4", "decisao":"fica decidido mnop" },
//   ];
  
//   String csvDataHeader = "uf" + "," 
//                   + "tribunal" + "," 
//                   + "decisaof" + "/n";

//   print(csvDataHeader);

//   for each Publicacao 

//   csvData = dataListToCsvConverter().convert(data);
//   final String directory = (await getApplicationSupportDirectory()).path;
//   final path = "$directory/csv-${DateTime.now()}.csv";
//   print(path);
//   final File file = File(path);
//   await file.writeAsString(csvData);

//   // Navigator.of(context).push(
//   //   MaterialPageRoute(
//   //     builder: (_) {
//   //       return LoadCsvDataScreen(path: path);
//   //     },
//   //   ),
//   // );

// }

// class LoadCsvDataScreen extends StatelessWidget {
//   final String path;

//   LoadCsvDataScreen({required this.path});


//   Future generateCsv() async {

//   List<List<String>> data = [
//     ["No.", "Name", "Roll No."],
//     ["1", randomAlpha(3), randomNumeric(3)],
//     ["2", randomAlpha(3), randomNumeric(3)],
//     ["3", randomAlpha(3), randomNumeric(3)]
//   ];
  
//   String csvData = '';
//   csvData = ListToCsvConverter().convert(data);
//   final String directory = (await getApplicationSupportDirectory()).path;
//   final path = "$directory/csv-${DateTime.now()}.csv";
//   print(path);
//   final File file = File(path);
//   await file.writeAsString(csvData);

//   // Navigator.of(context).push(
//   //   MaterialPageRoute(
//   //     builder: (_) {
//   //       return LoadCsvDataScreen(path: path);
//   //     },
//   //   ),
//   // );

// }

//   Future<List<List<dynamic>>> loadingCsvData(String path) async {
//     final csvFile = new File(path).openRead();
//     return await csvFile
//         .transform(utf8.decoder)
//         .transform(
//           CsvToListConverter(),
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("CSV DATA"),
//       ),
//       body: FutureBuilder(
//         future: loadingCsvData(path),
//         builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
//           print(snapshot.data.toString());
//           return snapshot.hasData
//               ? Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: snapshot.data
//                         .map(
//                           (data) => Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(
//                                   data[0].toString(),
//                                 ),
//                                 Text(
//                                   data[1].toString(),
//                                 ), Text(
//                                   data[2].toString(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 )
//               : Center(
//                   child: CircularProgressIndicator(),
//                 );
//         },
//       ),
//     );
//   }

// }