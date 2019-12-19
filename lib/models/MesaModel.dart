// To parse this JSON data, do
//
//     final mesa = mesaFromJson(jsonString);

import 'dart:convert';

Mesa mesaFromJson(String str) => Mesa.fromJson(json.decode(str));

String mesaToJson(Mesa data) => json.encode(data.toJson());

class Mesa {
    int mesaId;
    int numero;
    String codigoQr;
    bool estadoMesa;

    Mesa({
        this.mesaId,
        this.numero,
        this.codigoQr,
        this.estadoMesa,
    });

    factory Mesa.fromJson(Map<String, dynamic> json) => Mesa(
        mesaId: json["mesaID"],
        numero: json["numero"],
        codigoQr: json["codigoQR"],
        estadoMesa: json["estadoMesa"],
    );

    Map<String, dynamic> toJson() => {
        "mesaID": mesaId,
        "numero": numero,
        "codigoQR": codigoQr,
        "estadoMesa": estadoMesa,
    };
}
