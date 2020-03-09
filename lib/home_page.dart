import 'package:dio_nodejs_example/model/contato_model.dart';
import 'package:dio_nodejs_example/repositories/contatos_repository.dart';
import 'package:dio_nodejs_example/repositories/login_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<ContatoModel>> contatoFuture;
  ContatosRepository _repository;
  TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    LoginRepository().login();
    _repository = ContatosRepository();
    contatoFuture = _repository.findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exemplo DIO')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _buscaController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      if (_buscaController.text.isEmpty) {
                        contatoFuture = _repository.findAll();
                      } else {
                        contatoFuture = _repository.findFilter(_buscaController.text);
                      }
                    });
                  },
                  child: Text('Buscar'),
                ),
              )
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: this.contatoFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ContatoModel>> snapshot) {
                print(snapshot.hasData);
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      var item = snapshot.data[index];
                      return ListTile(
                        title: Text(item.nomeCompleto),
                        subtitle: Text(item.telefone),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
