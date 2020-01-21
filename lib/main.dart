import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro de Usuário',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Cadastro de Usuário'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  bool _termsChecked = false;
  int radioValue = -1;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    onSaved: (String value) {
                      email = value;
                    },
                    validator: _validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    onSaved: (String value) {
                      password = value;
                    },
                    validator: _validatePassword,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Gênero:",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      RadioListTile<int>(
                          title: Text('Masculino'),
                          value: 0,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange),
                      RadioListTile<int>(
                          title: Text('Feminino'),
                          value: 1,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange),
                      RadioListTile<int>(
                          title: Text('Não informar'),
                          value: 2,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CheckboxListTile(
                      title: Text('Termos e Condições'),
                      value: _termsChecked,
                      onChanged: (bool value) =>
                          setState(() => _termsChecked = value)),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    onPressed: _validateInputs,
                    child: Text('Salvar'),
                  )
                ],
              ))),
    );
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "Digite um endereço de e-mail";
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }

    return 'E-mail inválido!';
  }

  String _validatePassword(String value) {
    if (value.length > 5) {
      return null;
    }

    return 'A senha deve ter pelo menos 6 caracteres!';
  }

  void handleRadioValueChange(int value) {
    print(value);
    setState(() => radioValue = value);
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      if (radioValue < 0) {
        _showSnackBar('Por favor, selecione o seu sexo!');
      } else if (!_termsChecked) {
        _showSnackBar("Por favor, aceite nossos termos e condições!");
      } else {
        form.save();
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  content: Text("Todos os inputs estão válidos!"),
                ));
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void _showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
