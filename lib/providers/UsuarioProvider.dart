import 'dart:core';
import 'package:app_votos/models/VotosModel.dart';
import 'package:http/http.dart' as http;
import 'package:app_votos/models/UsuarioModel.dart';
import 'package:app_votos/models/MesaModel.dart';
import 'package:app_votos/main.dart' as main;

class UsuarioProvider {

  String _url = main.ip;
  
  Future<Usuario> getUsuario(String usuarioId) async {
    final url = Uri.http(_url, 'Elecciones/api/jurados/$usuarioId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final usuarioAux = usuarioFromJson(response.body);
      return usuarioAux;
    } else {
      Usuario usError = new Usuario(
        ci: "error"
      );
      return usError;
    }
  }

  Future<Usuario> verificarUsuario(String ci, String fecha) async {
    final url = Uri.http(_url, 'Elecciones/api/usuarios/$ci/$fecha');
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final respuesta = usuarioFromJson(response.body);
      return respuesta;
    } else {
      Usuario usr = new Usuario(
        ci: 'error'
      );
      return usr;
    }
  }

  Future<bool> verificarMesa(int id) async {
    final url = Uri.http(_url, 'Elecciones/api/mesas/$id');
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final mesa = mesaFromJson(response.body);
      return mesa.estadoMesa;
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<bool> verificarVoto(int id) async {
    final url = Uri.http(_url, 'Elecciones/api/votos');
    final response = await http.get(url);
    if(response.statusCode == 200) {
      bool flag = false;
      final listaVotos = votosFromJson(response.body);
      for (var i = 0; i < listaVotos.length; i++) {
        if(listaVotos[i].usuarioId == id) {
          flag = true;
        }
      }
      return flag;

    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<String> obtenerCodigo() async {
    final url = Uri.http('whitelabel', 'getCode');
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final respuesta = response.body.toString();
      return respuesta;
    } else {
      print('error obteniendo el codigo');
      return null;
    }
  }
}