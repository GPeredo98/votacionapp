// To parse this JSON data, do
//
//     final candidato = candidatoFromJson(jsonString);

import 'dart:convert';

List<Candidato> candidatoFromJson(String str) => List<Candidato>.from(json.decode(str).map((x) => Candidato.fromJson(x)));

String candidatoToJson(List<Candidato> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Partido {
    int partidoId;
    String sigla;
    String nombre;
    String color;
    List<Candidato> candidatos;

    Partido({
        this.partidoId,
        this.sigla,
        this.nombre,
        this.color,
        this.candidatos,
    });

    factory Partido.fromJson(Map<String, dynamic> json) => Partido(
        partidoId: json["partidoID"],
        sigla: json["sigla"],
        nombre: json["nombre"],
        color: json["color"],
        candidatos: List<Candidato>.from(json["candidatos"].map((x) => Candidato.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "partidoID": partidoId,
        "sigla": sigla,
        "nombre": nombre,
        "color": color,
        "candidatos": List<dynamic>.from(candidatos.map((x) => x.toJson())),
    };
}

class Candidato {
    int candidatoId;
    String nombres;
    String apellidos;
    int tipoVotoId;
    int partidoId;
    TipoVoto tipoVoto;
    Partido partido;
    bool seleccionado = false;

    Candidato({
        this.candidatoId,
        this.nombres,
        this.apellidos,
        this.tipoVotoId,
        this.partidoId,
        this.tipoVoto,
        this.partido,
    });

    factory Candidato.fromJson(Map<String, dynamic> json) => Candidato(
        candidatoId: json["candidatoID"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        tipoVotoId: json["tipoVotoID"],
        partidoId: json["partidoID"],
        tipoVoto: TipoVoto.fromJson(json["tipoVoto"]),
        partido: json["partido"] == null ? null : Partido.fromJson(json["partido"]),
    );

    Map<String, dynamic> toJson() => {
        "candidatoID": candidatoId,
        "nombres": nombres,
        "apellidos": apellidos,
        "tipoVotoID": tipoVotoId,
        "partidoID": partidoId,
        "tipoVoto": tipoVoto.toJson(),
        "partido": partido == null ? null : partido.toJson(),
    };
}

class TipoVoto {
    int tipoVotoId;
    String nombre;

    TipoVoto({
        this.tipoVotoId,
        this.nombre,
    });

    factory TipoVoto.fromJson(Map<String, dynamic> json) => TipoVoto(
        tipoVotoId: json["tipoVotoID"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "tipoVotoID": tipoVotoId,
        "nombre": nombre,
    };
}