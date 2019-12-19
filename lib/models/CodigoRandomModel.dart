import 'dart:convert';

CodigoRandom codigoRandomFromJson(String str) => CodigoRandom.fromJson(json.decode(str));

String codigoRandomToJson(CodigoRandom data) => json.encode(data.toJson());

class CodigoRandom {
    String res;
    String code;
    int ttl;

    CodigoRandom({
        this.res,
        this.code,
        this.ttl,
    });

    factory CodigoRandom.fromJson(Map<String, dynamic> json) => CodigoRandom(
        res: json["res"],
        code: json["code"],
        ttl: json["ttl"],
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "code": code,
        "ttl": ttl,
    };
}