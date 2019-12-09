import 'dart:core';
import 'dart:core';
import 'package:app_votos/models/CandidatoModel.dart';
import 'package:http/http.dart' as http;

class CandidatoProvider {
  String _url = '192.168.137.125';
  
  Future<List<Candidato>> getCandidatosPresidentes() async {
    final url = Uri.http(_url, 'Elecciones/api/candidatos/presidente');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var listaCandidatos = candidatoFromJson(response.body);
      var lista = listaCandidatos;
      return lista;
    }
    throw Exception('Error al conectar');

  }
  Future<List<Candidato>> getCandidatosDiputados() async {
    final url = Uri.http(_url, 'Elecciones/api/candidatos/diputado');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var listaCandidatos = candidatoFromJson(response.body);
      var lista = listaCandidatos;
      return lista;
    }
    throw Exception('Error al conectar');
  }

  Future ejecutarVoto(String userId, String candidatoId) async {
    final url = Uri.http(_url, 'Elecciones/api/candidatos/diputado');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      var listaCandidatos = candidatoFromJson(response.body);
      var lista = listaCandidatos;
      return lista;
    }
    throw Exception('Error al conectar');
  }
}
