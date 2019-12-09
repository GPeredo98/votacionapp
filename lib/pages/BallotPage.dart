import 'package:flutter/material.dart';
import 'package:app_votos/providers/CandidatoProvider.dart';
import 'package:app_votos/models/CandidatoModel.dart';

class BallotPage extends StatefulWidget {
  BallotPage({Key key}) : super(key: key);

  @override
  _BallotPageState createState() => _BallotPageState();
}

class _BallotPageState extends State<BallotPage> {
  int pSelected;
  int dSelected;
  List<Candidato> lista_candidatos;

  @override
  Widget build(BuildContext context) {
    CandidatoProvider candidatoProvider = new CandidatoProvider();

    return Container(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: <Widget>[
            Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      'CANDIDATOS A LA PRESIDENCIA',
                      style: TextStyle(fontSize: 20),
                    )),
            Container (
              height: 200.0,
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
            Container (
              height: 200.0,
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
                      print('Candidatos seleccionados: ');
                      print(pSelected);
                      print(dSelected);
                    },
                  ),
                )
          ]),
        ),
      ),
    );
  }

  ListView getCandidatosWidgets(List<Candidato> data) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        var objCandidato = data[index];
        return new CandidatosWidget(objCandidato: objCandidato, datas: data);
      },
    );
  }
}

class CandidatosWidget extends StatefulWidget {
  const CandidatosWidget({
    Key key,
    @required this.objCandidato,
    @required this.datas
  }) : super(key: key);

  final Candidato objCandidato;
  final List<Candidato> datas;

  @override
  _CandidatosWidgetState createState() => _CandidatosWidgetState();
}

class _CandidatosWidgetState extends State<CandidatosWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.objCandidato.tipoVotoId == 1){
          _BallotPageState().pSelected = widget.objCandidato.candidatoId;
        } else if(widget.objCandidato.tipoVotoId == 2){
          _BallotPageState().dSelected = widget.objCandidato.candidatoId;
        }
        print('Selecciono: '+widget.objCandidato.nombres);
        setState(() {
          for (var i = 0; i < widget.datas.length; i++) {
            widget.datas[i].seleccionado = false;
          }
          widget.objCandidato.seleccionado = true;
        });
      },
      child: Container (
        color: (widget.objCandidato.seleccionado)?Colors.red:Colors.white,
        child: Card(
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('assets/'+widget.objCandidato.nombres + ' ' + widget.objCandidato.apellidos + '.jpg'),
                width: 100.0,
              ),
              Container(
                width: 100.0,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Text(
                  widget.objCandidato.nombres + ' ' + widget.objCandidato.apellidos,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
