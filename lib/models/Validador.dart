import 'dart:convert';

Validador validadorFromJson(String str) => Validador.fromJson(json.decode(str));

String validadorToJson(Validador data) => json.encode(data.toJson());

class Validador {
    String res;

    Validador({
        this.res,
    });

    factory Validador.fromJson(Map<String, dynamic> json) => Validador(
        res: json["res"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
    };
}