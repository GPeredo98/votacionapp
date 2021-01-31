import 'package:http/http.dart' as http;
import 'package:app_votos/models/CodigoRandomModel.dart';
import 'package:app_votos/models/Validador.dart';

class GeneradorProvider {
  String _url = '1bfc19b4-46b0-4619-87be-edac321124dc.mock.pstmn.io';

  Future <CodigoRandom> getCode () async {
    final url = Uri.http(_url, 'codigos/get');
    return await _procesar(url);
  } 

  Future <CodigoRandom> _procesar (Uri url) async {
    final resp = await http.get(url);
    final decodedData = codigoRandomFromJson(resp.body);
    return decodedData;
  }

  Future postCode (String dato) async {
    final url  = "https://8e5306d5-5c83-4274-be8b-968ba743ccfd.mock.pstmn.io/codigos/send?=";
    final body = '{"code": $dato}';

    final res = await http.post(url, body: body, headers: {"Accept": "application/json","content-type": "application/json"});

    var data = validadorFromJson(res.body);

    print(data);

    return data.res;
  }
}