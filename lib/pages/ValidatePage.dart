import 'package:app_votos/models/CodigoRandomModel.dart';
import 'package:app_votos/models/UsuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:app_votos/providers/UsuarioProvider.dart';
import 'package:app_votos/providers/CodigoProvider.dart';

class ValidatePage extends StatefulWidget {
  const ValidatePage({Key key}) : super(key: key);

  @override
  _ValidatePageState createState() => _ValidatePageState();
}

class _ValidatePageState extends State<ValidatePage> {
  UsuarioProvider usuarioProvider = new UsuarioProvider();
  GeneradorProvider codigoProvider = new GeneradorProvider();
  final codigoController = TextEditingController();

  void _showDialogErrorCodigo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error al ingresar"),
          content: new Text("El código de seguridad es incorrecto"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Usuario usr = new Usuario();
    usr = ModalRoute.of(context).settings.arguments;

    return Container(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30.0, top: 80),
            child: Column(
              children: <Widget>[
                Text('Codigo de seguridad'),
                Container(
                    width: 300.0,
                    child: FutureBuilder<CodigoRandom>(
                      future: codigoProvider.getCode(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(child: Text('Error al cargar datos'));
                          }
                          return Container(
                              margin: EdgeInsets.only(top: 5, bottom: 40),
                              decoration: BoxDecoration(
                                border: Border.all(width: 3.0),
                              ),
                              child: Center(child: Text(snapshot.data.code)));
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )),
                Text('Ingrese el código de seguridad'),
                TextField(
                  controller: codigoController,
                  decoration: InputDecoration(
                    helperText:
                        'Es el número proporcionado por el campo generador de códigos',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    child: Text('VERIFICAR'),
                    onPressed: () async {
                      var res = await codigoProvider.postCode(codigoController.text);
                      print('RES: '+ res);
                      if(res == 'success') {
                        Navigator.pushNamed(context, '/ballot', arguments: usr);
                      } else {
                        _showDialogErrorCodigo();
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
