// import time;

class Publicacao {

  String ano = ''; 
  String mes = ''; 
  String dia = ''; 

  String uf = '';
  String tribunal = '';

  String diario = '';
  String pagina = '';

  String cidade = ''; 
  String grau = '';
  String gname = '';

  String orgao = ''; 
  String camara = '';
  String foro = ''; 
  String vara = '';
 
  String tipo = '';
  String obstipo = ''; 
  String desctipo = ''; 

  String classe = '';
  String assunto = '';

  String processo = ''; 

  String decisao = '';
  String obsdec = ''; 

  DateTime dataPublicacao = DateTime.now();

  Publicacao({
    required this.ano, 
    required this.mes, 
    required this.dia,

    required this.uf,
    required this.tribunal,

    required this.diario,
    required this.pagina,

    required this.cidade, 
    required this.grau,
    required this.gname,

    required this.orgao,
    required this.camara,
    required this.foro, 
    required this.vara,

    required this.tipo,
    required this.obstipo,
    required this.desctipo, 

    required this.classe,
    required this.assunto,

    required this.processo, 
    required this.decisao,

    required this.obsdec,
    required this.dataPublicacao,
  });

  int _daysLate = 0;
  
  get daysLate {
    return _daysLate;
  }

  factory Publicacao.fromJson(Map<String, dynamic> json) {
    return Publicacao(

        ano: json["ano"].toString(), 
        mes: json["mes"].toString(), 
        dia: json["dia"].toString(), 

        uf: json["uf"].toString(),
        tribunal: json["tribunal"].toString(),

        diario: json["diario"].toString(),
        pagina: json["pagina"].toString(),

        cidade: json["cidade"].toString(), 
        grau: json["grau"].toString(),
        gname: json["gname"].toString(),

        orgao: json["orgao"].toString(), 
        camara: json["camara"].toString(),
        foro: json["foro"].toString(), 
        vara: json["vara"].toString(),

        tipo: json["tipo"].toString(),
        desctipo: json["desctipo"].toString(), 
        obstipo: json["obstipo"].toString(),

        classe: json["classe"].toString(),
        assunto: json["assunto"].toString(),

        processo: json["processo"].toString(),

        decisao: json["decisao"].toString(),
        obsdec: json["obsdec"].toString(),

        dataPublicacao: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() =>
    {

        "ano": ano,
        "mes": mes,
        "dia": dia,

        "uf": uf,
        "tribunal": tribunal,

        "diario": diario,
        "pagina": pagina,

        "cidade": cidade,
        "grau":  grau,
        "gname": gname,

        "orgao": orgao,
        "camara": camara,
        "foro": foro,
        "vara": vara,

        "tipo": tipo,
        "obstipo": obstipo,
        "desctipo": desctipo,

        "classe": classe,
        "assunto": assunto,

        "processo": processo,

        "decisao": decisao,
        "obsdec": obsdec,

        "dataPublicacao": dataPublicacao.toIso8601String(),

    };

}
