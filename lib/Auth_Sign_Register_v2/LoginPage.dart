import 'package:flutter/material.dart';
import 'AuthCheck.dart';
import 'BaseAuth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});
  final BaseAuth auth;
  final VoidCallback loginCallback;
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String userId = "";
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => AuthCheck(auth: widget.auth)));
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Registered user: $userId');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sisteme Giriş'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            )),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email boş olamaz' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Şifre'),
        validator: (value) => value.isEmpty ? 'Şifre boş olamaz' : null,
        onSaved: (value) => _password = value,
        obscureText: true,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Giriş',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        FlatButton(
          child: Text(
            'Hesap oluştur',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Bir hesap oluştur',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        FlatButton(
          child: Text(
            'Zaten bir hesabınız mı var? Giriş Yapın',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
