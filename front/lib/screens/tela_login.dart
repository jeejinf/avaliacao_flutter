import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'tela_notas.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String token = '';

  Future<void> fazerLogin() async {
    String apiUrl = dotenv.env['API_URL']!;
    var url = Uri.parse('$apiUrl/login');

    print(
        'Enviando dados: { username: ${nomeController.text}, password: ${senhaController.text} }');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': nomeController.text,
        'password': senhaController.text,
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        token = data['token'];
      });

      // Exibir o token como SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Token recebido: $token'),
          duration: Duration(seconds: 4), // Duração da notificação
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaNotas(token: token)),
      );
    } else {
      print('Erro ao fazer login. Status Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: senhaController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fazerLogin,
              child: Text('Login'),
            ),
            if (token.isNotEmpty) Text('Token recebido: $token'),
          ],
        ),
      ),
    );
  }
}
