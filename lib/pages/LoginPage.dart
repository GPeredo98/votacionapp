import 'dart:io';
import 'package:app_votos/models/UsuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:app_votos/providers/UsuarioProvider.dart';
import 'package:app_votos/models/ExistModel.dart';

class LoginPage extends StatefulWidget {
  //LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _format = DateFormat("yyyy-MM-dd");

  final ciController = TextEditingController();
  final fechaController = TextEditingController();

  final usuarioProvider = new UsuarioProvider();
  var existAuth = new Exist();
  var autenticado = false;

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _biometrico() async {
    bool flag = true;

    if (flag) {
      bool authenticated = false;

      const androidString = const AndroidAuthMessages(
          cancelButton: "Cancelar",
          goToSettingsButton: "Ajustes",
          signInTitle: "Autenticar",
          fingerprintHint: "Coloque su huella",
          fingerprintNotRecognized: "Huella no reconocida",
          fingerprintSuccess: "Huella reconocida",
          goToSettingsDescription: "Por favor configure su huella");

      try {
        authenticated = await auth.authenticateWithBiometrics(
            localizedReason: "Autentiquese para poder emitir su voto",
            useErrorDialogs: true,
            stickyAuth: true,
            androidAuthStrings: androidString);

        if (!authenticated) {
          exit(0);
        }
      } catch (e) {
        print(e);
      }
      if (!mounted) {
        return;
      }
    }
  }

  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    ciController.dispose();
    fechaController.dispose();
    super.dispose();
  }

  Exist getExistValue(Exist data) {
    Exist aux = new Exist(respuesta: data.respuesta);
    return aux;
  }

  void _showDialogErrorUsuario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error al ingresar"),
          content: new Text("El usuario no se encuentra empadronado"),
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

  void _showDialogErrorMesa() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error al ingresar"),
          content: new Text("La mesa de sufragio ya cerró"),
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

  void _showDialogErrorVoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error al ingresar"),
          content: new Text("Este usuario ya emitio su voto"),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image(
                        image: AssetImage('assets/logo.png'),
                        width: 260.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 60.0, left: 60.0),
                      child: TextFormField(
                        controller: ciController,
                        decoration: InputDecoration(hintText: "CI"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 60.0, left: 60.0),
                      child: DateTimeField(
                        controller: fechaController,
                        decoration:
                            InputDecoration(hintText: "Fecha de nacimiento"),
                        format: _format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: RaisedButton(
                          child: Text('INGRESAR'),
                          onPressed: () async {
                            setState(() {
                              _biometrico();
                            });
                            print('CI: ' + ciController.text);
                            print('Fecha: ' + fechaController.text);
                            Usuario objUser =
                                await usuarioProvider.verificarUsuario(
                                    ciController.text, fechaController.text);

                            //Validar si los datos existen
                            if (objUser.ci == "error") {
                              _showDialogErrorUsuario();
                              print("error no existe ese ci o fecha");
                            } else {
                              print('INGRESO');
                              bool mesaStats = await usuarioProvider
                                  .verificarMesa(objUser.mesaId);

                              //Validar si la mesa esta cerrada
                              if (mesaStats) {
                                _showDialogErrorMesa();
                                print("La mesa ya esta cerrada");
                              } else {
                                bool votoStats = await usuarioProvider
                                    .verificarVoto(objUser.usuarioId);

                                //Validar si el usuario ya emitió su voto
                                if (votoStats) {
                                  _showDialogErrorVoto();
                                  print("Este usuario ya ejecuto su voto");
                                } else {
                                  Navigator.pushNamed(context, '/validate',
                                      arguments: objUser);
                                }
                                //Navigator.pushNamed(context, '/validate', arguments: objUser);
                              }
                            }
                          },
                        ),
                      ),
                    )
                  ],
                )),
          ),
          padding: EdgeInsets.all(56.0)),
    );
  }
}
