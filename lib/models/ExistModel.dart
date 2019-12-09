import 'dart:convert';

Exist existFromJson(String str) => Exist.fromJson(json.decode(str));

String existToJson(Exist data) => json.encode(data.toJson());

class Exist {
    String respuesta;

    Exist({
        this.respuesta,
    });

    factory Exist.fromJson(Map<String, dynamic> json) => Exist(
        respuesta: json["respuesta"],
    );

    Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
    };
}
