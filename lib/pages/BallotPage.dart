import 'package:app_votos/models/UsuarioModel.dart';
import 'package:app_votos/providers/VotoProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_votos/providers/CandidatoProvider.dart';
import 'package:app_votos/models/CandidatoModel.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qr_reader/qr_reader.dart';

class BallotPage extends StatefulWidget {
  BallotPage({Key key}) : super(key: key);

  @override
  _BallotPageState createState() => _BallotPageState();
}

class _BallotPageState extends State<BallotPage> {
  final LocalStorage storage = new LocalStorage('some_key');
  int pSelected;
  int dSelected;

  void _showDialogEmpty() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error al ejecutar"),
          content: new Text("Debe votar en ambos campos"),
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
    CandidatoProvider candidatoProvider = new CandidatoProvider();
    //VotoProvider votoProvider = new VotoProvider();
    Usuario userId = ModalRoute.of(context).settings.arguments;

    return Container(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
                child: Text(
                  'CANDIDATOS A LA PRESIDENCIA',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              height: 220.0,
              child: FutureBuilder<List<Candidato>>(
                future: candidatoProvider.getCandidatosPresidentes(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Error al cargar datos'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return getCandidatosWidgets(snapshot.data);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Divider(
                height: 10,
                color: Colors.grey,
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
                child: Text(
                  'CANDIDATOS A DIPUTADOS',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              height: 220.0,
              child: FutureBuilder<List<Candidato>>(
                future: candidatoProvider.getCandidatosDiputados(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Error al cargar datos'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return getCandidatosWidgets(snapshot.data);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: RaisedButton(
                child: Text('CONFIRMAR'),
                onPressed: () {
                  _scanQR(
                      context,
                      userId,
                      int.parse(storage.getItem('presidente').toString()),
                      int.parse(storage.getItem('diputado').toString()));
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _showVoteResult(Candidato presidente, Candidato diputado) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("VOTO EJECUTADO"),
            content: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text('Presidente: '+presidente.nombres+' '+presidente.apellidos)
                  ),
                Image(
                  width: 200,
                  image: AssetImage(
                      'assets/'+presidente.nombres+' '+presidente.apellidos+'.jpg'),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text('Diputado: '+diputado.nombres+' '+diputado.apellidos)),
                Image(
                  width: 200,
                  image: AssetImage(
                      'assets/'+diputado.nombres+' '+diputado.apellidos+'.jpg'),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("ACEPTAR"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          );
        },
      );
    }

  void _scanQR(BuildContext context, Usuario vot, int presID, int dipID) async {
    String futureString;
    VotoProvider votoProvider = new VotoProvider();

    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      futureString = e.toString();
    }

    if (futureString != null) {
      final scan = futureString;
      print(scan);
      if (vot.mesaId.toString() == scan) {
        print('voto1: ' + storage.getItem('presidente').toString());
        print('voto2: ' + storage.getItem('presidente').toString());
        
          //Post: Votos diputado y presidente
          votoProvider.votarPresidente(
              int.parse(storage.getItem('presidente').toString()),
              vot.usuarioId);
          votoProvider.votarDiputado(
              int.parse(storage.getItem('diputado').toString()), vot.usuarioId);

          print(storage.getItem('presidente'));
          print(storage.getItem('diputado'));

          Candidato candPres = await votoProvider.getCandidato(int.parse(storage.getItem('presidente').toString()));
          Candidato candDip = await votoProvider.getCandidato(int.parse(storage.getItem('diputado').toString()));

          print('Prueba p: '+candPres.apellidos);
          print('Prueba d: '+candDip.apellidos);

          _showVoteResult(candPres, candDip);
        
      }
    }
  }

  StatefulWidget getCandidatosWidgets(List<Candidato> data) {
    return new CandidatoWidget(data: data);
  }
}

class CandidatoWidget extends StatefulWidget {
  const CandidatoWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final List<Candidato> data;

  @override
  _CandidatoWidgetState createState() => _CandidatoWidgetState();
}

class _CandidatoWidgetState extends State<CandidatoWidget> {
  final LocalStorage storage = new LocalStorage('some_key');
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        var objCandidato = widget.data[index];
        return GestureDetector(
          onTap: () {
            if (objCandidato.tipoVoto.nombre == 'Presidente') {
              storage.setItem('presidente', objCandidato.candidatoId);
              print('Guardado en storage: ' +
                  storage.getItem('presidente').toString());
            } else {
              storage.setItem('diputado', objCandidato.candidatoId);
              print('Guardado en storage: ' +
                  storage.getItem('diputado').toString());
            }

            print('Selecciono: ' +
                objCandidato.nombres +
                ' ' +
                objCandidato.candidatoId.toString());
            setState(() {
              for (var i = 0; i < widget.data.length; i++) {
                widget.data[i].seleccionado = false;
              }
              objCandidato.seleccionado = true;
            });
          },
          child: Container(
            color: (objCandidato.seleccionado) ? Colors.red : Colors.white,
            child: Card(
              child: Column(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/' +
                        objCandidato.nombres +
                        ' ' +
                        objCandidato.apellidos +
                        '.jpg'),
                    width: 100.0,
                  ),
                  Container(
                    width: 100.0,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Text(
                      objCandidato.nombres + ' ' + objCandidato.apellidos,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(child: Text(objCandidato.partido.sigla))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


