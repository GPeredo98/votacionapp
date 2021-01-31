import 'dart:core';
import 'package:app_votos/models/CandidatoModel.dart';
import 'package:http/http.dart' as http;
import 'package:app_votos/main.dart' as main;

class VotoProvider {
  final String _url = 'http://'+main.ip;

  Future<bool> votarPresidente(int candidatoID, int usuarioID) async {
    final url = '$_url/Elecciones/api/votos';
    String json = '{"candidatoID": $candidatoID,"usuarioID": $usuarioID}';
    final resp = await http.post(url, body: json, headers: {"Accept": "application/json","content-type": "application/json"});

    print(resp.statusCode);
    if (resp.statusCode == 201) {
    return true;
    } else {
      return false;
    }
  }

  Future<Candidato> getCandidato(id) async {
    final _params = { "id" : "$id" };
    final uri = Uri.http('192.168.43.86', 'Elecciones/api/Candidatos/GetCandidatow', _params);
    print('Uri: $uri');
    final resp = await http.get(uri);
    //if (resp.statusCode == 201) {
      print('entro');
      Candidato aux = candidatodFromJson(resp.body);
      return aux;
    //} else {
    //  print('error');
    //}
  }

  Future<bool> votarDiputado(int candidatoID, int usuarioID) async {
    final url = '$_url/Elecciones/api/votos';
    String json = '{"candidatoID": $candidatoID,"usuarioID": $usuarioID}';
    final resp = await http.post(url, body: json, headers: {"Accept": "application/json","content-type": "application/json"});

    print (resp.statusCode);
    if (resp.statusCode == 201) {
    return true;
    } else {
      return false;
    }
  }
}