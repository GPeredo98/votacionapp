import 'package:app_votos/models/UsuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:app_votos/providers/UsuarioProvider.dart';
import 'package:app_votos/models/ExistModel.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

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

  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    ciController.dispose();
    fechaController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Verificando';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Pon tu huella para autenticar el ingreso',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Verificando';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Autorizado' : 'No autorizado';
    setState(() {
      _authorized = message;
    });
  }

  Exist getExistValue(Exist data) {
    Exist aux = new Exist(respuesta: data.respuesta);
    return aux;
  }

  void _cancelAuthentication() {
    // auth.stopAuthentication();
  }

  void verificarUsuarioExist() async {
    final existAux = await usuarioProvider.verificarUsuario(
        ciController.text, fechaController.text);
    // existAuth = existAux;
    setState(() {});
  }

  Future funcThatMakesAsyncCall() async {
    var result = usuarioProvider.verificarUsuario(
        ciController.text, fechaController.text);
    print(result);
    setState(() {
      var someVal = result;
    });
  }

  void _showDialogError() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error al ingresar"),
          content: new Text(
              "El usuario no se encuentra empadronado"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40),
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
                    //Text('Estado: $_authorized\n'),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: RaisedButton(
                        child: Text(_isAuthenticating
                            ? 'Verificar'
                            : 'Verificar Huella'),
                        onPressed: _isAuthenticating
                            ? _cancelAuthentication
                            : _authenticate,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        child: Text('INGRESAR'),
                        onPressed: () async {

                          Usuario objUser = await usuarioProvider.verificarUsuario(ciController.text, fechaController.text);
                          if(objUser.ci == "error") {
                            _showDialogError();
                            print("error no existe ese ci o fecha");
                          } else {
                            print(objUser.ci);
                            Navigator.pushNamed(context, '/validate', arguments: objUser);
                          }
                        },
                      ),
                    )
                  ],
                )),
          ),
          padding: EdgeInsets.all(56.0)),
    );
  }
}
