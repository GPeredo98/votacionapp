// To parse this JSON data, do
//
//     final votos = votosFromJson(jsonString);

import 'dart:convert';

List<Votos> votosFromJson(String str) => List<Votos>.from(json.decode(str).map((x) => Votos.fromJson(x)));

String votosToJson(List<Votos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Votos {
    int votoId;
    int candidatoId;
    int usuarioId;
    dynamic candidato;
    dynamic usuario;

    Votos({
        this.votoId,
        this.candidatoId,
        this.usuarioId,
        this.candidato,
        this.usuario,
    });

    factory Votos.fromJson(Map<String, dynamic> json) => Votos(
        votoId: json["votoID"],
        candidatoId: json["candidatoID"],
        usuarioId: json["usuarioID"],
        candidato: json["candidato"],
        usuario: json["usuario"],
    );

    Map<String, dynamic> toJson() => {
        "votoID": votoId,
        "candidatoID": candidatoId,
        "usuarioID": usuarioId,
        "candidato": candidato,
        "usuario": usuario,
    };
}