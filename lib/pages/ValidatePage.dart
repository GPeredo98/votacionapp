import 'package:app_votos/models/UsuarioModel.dart';
import 'package:flutter/material.dart';

class ValidatePage extends StatelessWidget {
  const ValidatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Usuario usr = new Usuario();
    usr = ModalRoute.of(context).settings.arguments;

    return Container(
      child: Scaffold (
        body: Padding(
          padding: const EdgeInsets.only(right: 30.0, left: 30.0, top: 80),
          child: Column(
            children: <Widget>[
              
              Text('Ingrese el código de seguridad'),
              TextField(
                decoration: InputDecoration(
                  helperText: 'Es el número proporcionado por la app generadora de códigos',
                  ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  child: Text('VERIFICAR'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ballot');
                  },
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}