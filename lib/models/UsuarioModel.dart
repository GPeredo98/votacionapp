import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    int usuarioId;
    String ci;
    String nombres;
    String apellidos;
    String fechaNacimiento;
    int edad;
    int mesaId;
    dynamic mesa;

    Usuario({
        this.usuarioId,
        this.ci,
        this.nombres,
        this.apellidos,
        this.fechaNacimiento,
        this.edad,
        this.mesaId,
        this.mesa,
    });

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        usuarioId: json["usuarioID"],
        ci: json["ci"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        fechaNacimiento: json["fechaNacimiento"],
        edad: json["edad"],
        mesaId: json["mesaID"],
        mesa: json["mesa"],
    );

    Map<String, dynamic> toJson() => {
        "usuarioID": usuarioId,
        "ci": ci,
        "nombres": nombres,
        "apellidos": apellidos,
        "fechaNacimiento": fechaNacimiento,
        "edad": edad,
        "mesaID": mesaId,
        "mesa": mesa,
    };
}
