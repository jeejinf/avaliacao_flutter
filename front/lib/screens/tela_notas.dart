import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TelaNotas extends StatefulWidget {
  final String token;

  TelaNotas({required this.token});

  @override
  _TelaNotasState createState() => _TelaNotasState();
}

class _TelaNotasState extends State<TelaNotas> {
  List alunos = [];
  List filteredAlunos = [];

  Future<void> carregarNotas() async {
    String apiUrl = dotenv.env['API_URL']!;
    var url = Uri.parse('$apiUrl/notasAlunos');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${widget.token}',
    });

    if (response.statusCode == 200) {
      setState(() {
        alunos = jsonDecode(response.body);
        filteredAlunos = alunos;
      });
    } else {
      print('Erro ao carregar notas');
    }
  }

  @override
  void initState() {
    super.initState();
    carregarNotas();
  }

  void filtrarAlunos(int filtro) {
    setState(() {
      if (filtro == 1) {
        filteredAlunos = alunos.where((aluno) => aluno['nota'] < 60).toList();
      } else if (filtro == 2) {
        filteredAlunos = alunos
            .where((aluno) => aluno['nota'] >= 60 && aluno['nota'] < 100)
            .toList();
      } else if (filtro == 3) {
        filteredAlunos = alunos.where((aluno) => aluno['nota'] == 100).toList();
      }
    });
  }

  void removerFiltros() {
    setState(() {
      filteredAlunos = alunos; // Restaura a lista original
    });
  }

  Color definirCor(int nota) {
    if (nota == 100) {
      return Colors.green;
    } else if (nota >= 60) {
      return Colors.blue;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas dos Alunos'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => filtrarAlunos(1), child: Text('Nota < 60')),
              ElevatedButton(
                  onPressed: () => filtrarAlunos(2),
                  child: Text('Nota >= 60 e < 100')),
              ElevatedButton(
                  onPressed: () => filtrarAlunos(3), child: Text('Nota = 100')),
              ElevatedButton(
                  onPressed: removerFiltros, // Botão para remover filtros
                  child: Text('Remover Filtros')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAlunos.length,
              itemBuilder: (context, index) {
                var aluno = filteredAlunos[index];
                return Container(
                  color: definirCor(aluno['nota']),
                  child: ListTile(
                    title: Text(aluno['nome']),
                    subtitle: Text(
                        'Matrícula: ${aluno['matricula']} - Nota: ${aluno['nota']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
