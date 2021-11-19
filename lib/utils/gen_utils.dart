import 'package:flutter/material.dart';

class GenUtils {
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static List<TextSpan> highlightOccurrences(String source, String? query) {
    if (query == null || query.isEmpty) {
      return <TextSpan>[TextSpan(text: source)];
    }

    final List<Match> matches = <Match>[];
    for (final String token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return <TextSpan>[TextSpan(text: source)];
    }
    matches.sort((Match a, Match b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = <TextSpan>[];
    const Color matchColor = Colors.red; //(0xFF602885);
    for (final Match match in matches) {
      if (match.end <= lastMatchEnd) {
        // already matched -> ignore
      } else if (match.start <= lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.end),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: matchColor),
        ));
      } else {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));

        children.add(TextSpan(
          text: source.substring(match.start, match.end),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: matchColor),
        ));
      }

      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < source.length) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, source.length),
      ));
    }

    return children;
  }

  static String extraiInicioDecisao(String decisao) {
    String parteInicialDecisao = decisao;
    if (decisao.length > 230) {
      parteInicialDecisao = decisao.substring(0, 230) + " ...... ";
    }
    return parteInicialDecisao;
  }

  static String extraiFimDecisao(String decisao, bool isFromPublicacaoScreen) {
    String parteFinalDecisao = '';
    if (!isFromPublicacaoScreen) {
      if (decisao.length > 230) {
        parteFinalDecisao =
            " ...... " + decisao.substring(decisao.length - 230);
      }
    }

    return parteFinalDecisao;
  }

    static String extraiTipoDecisaoCardProcesso(String tipoDecisao) {
    if (tipoDecisao.length > 0) {
      tipoDecisao = tipoDecisao + "  -  " ;
    }

    return tipoDecisao;
  }

  static String extraiFinalDecisaoCardProcesso(String decisao, int tamanho) {
    String parteFinalDecisao = decisao;

    if (decisao.length > tamanho) {
      parteFinalDecisao = " ..... " + decisao.substring(decisao.length - tamanho);
    }

    return parteFinalDecisao;
  }

  static Color selectDaysLateColor(daysLate) {
    if (daysLate <= 7) {
      return const Color(0xFFD50000);
    }

    if (daysLate <= 14) {
      return const Color(0xFFF4511E);
    }

    if (daysLate <= 30) {
      return const Color(0xFF2962FF);
    }

    if (daysLate <= 365) {
      return const Color(0xFF2962FF);
    }

    return Colors.grey;
  }

  static String selectDaysLateString(daysLate) {
    if (daysLate <= 30) {
      return daysLate.toString() + 'd';
    }

    if (daysLate <= 365) {
      return (daysLate ~/ 30).toString() + 'm';
    }

    return (daysLate ~/ 365).toString() + 'a';
  }

  static encodeCSV(csvData) async {
    print('Entrou da Rotina de CSV encoding. Utils');
    String csvDataHeader = "uf" +
        "," +
        "tribunal" +
        "," +
        "cidade" +
        "," +
        "grau" +
        "," +
        "gname" +
        "," +
        "diario" +
        "," +
        "pagina" +
        "," +
        "ano" +
        "," +
        "mes" +
        "," +
        "dia" +
        "," +
        "orgao" +
        "," +
        "camara" +
        "," +
        "foro" +
        "," +
        "vara" +
        "," +
        "tipo" +
        "," +
        "desctipo" +
        "," +
        "classe" +
        "," +
        "assunto" +
        "," +
        "processo" +
        "," +
        "decisao" +
        "\n";

    // print(csvDataHeader);

    String csvDatadeUmItem = "";
    String csvDataItems = "";
    csvData.forEach((publi) {
      csvDatadeUmItem = '"' +
          publi["uf"] +
          '"' +
          "," +
          '"' +
          publi["tribunal"] +
          '"' +
          "," +
          '"' +
          publi["cidade"] +
          '"' +
          "," +
          '"' +
          publi["grau"] +
          '"' +
          "," +
          '"' +
          publi["gname"] +
          '"' +
          "," +
          '"' +
          publi["diario"] +
          '"' +
          "," +
          '"' +
          publi["pagina"] +
          '"' +
          "," +
          '"' +
          publi["ano"] +
          '"' +
          "," +
          '"' +
          publi["mes"] +
          '"' +
          "," +
          '"' +
          publi["dia"] +
          '"' +
          "," +
          '"' +
          publi["orgao"] +
          '"' +
          "," +
          '"' +
          publi["camara"] +
          '"' +
          "," +
          '"' +
          publi["foro"] +
          '"' +
          "," +
          '"' +
          publi["vara"] +
          '"' +
          "," +
          '"' +
          publi["tipo"] +
          '"' +
          "," +
          '"' +
          publi["desctipo"] +
          '"' +
          "," +
          '"' +
          publi["classe"] +
          '"' +
          "," +
          '"' +
          publi["assunto"] +
          '"' +
          "," +
          '"' +
          publi["processo"] +
          '"' +
          "," +
          '"' +
          publi["decisao"] +
          '"' +
          "\n";

      //print(csvDatadeUmItem);
      csvDataItems = csvDataItems + csvDatadeUmItem;
    });
    print('Saiu da Rotina de CSV encoding.');
    return (csvDataHeader + csvDataItems);
  }

  static Future<void> showScreenDialog(context, String msg) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Atenção!',
          style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          msg,
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Fechar',
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
        elevation: 24.0,
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}

// DateTime today = new DateTime.now();
// String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
// print(dateSlug);