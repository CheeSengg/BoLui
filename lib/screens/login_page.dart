//Packages
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//Own imports
import '../util/auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

//TODO: Settle await issue that throws an exception
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          var userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
        } else {
          var userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
        }
        widget.onSignedIn();
      } catch (e) {
        print('error $e');
      }
    }
  }

  void googleValidateAndSubmit() async {
    var userId = await widget.auth.signInWithGoogle();
    widget.onSignedIn();
  }

//TODO Beautify login in page
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Page"),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: "Email"),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: "Password"),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new Padding(padding: EdgeInsets.only(bottom: 30.0),),
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new Padding(padding: EdgeInsets.only(bottom: 10.0),),
        new RaisedButton(
          child: new Text('Sign In With Google', style: new TextStyle(fontSize: 20.0)),
          onPressed: googleValidateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Create an account',
              style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        new Padding(padding: EdgeInsets.only(bottom: 30.0),),
        new RaisedButton(
          child: new Text('Create an account', style: new TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Have an account? Login',
              style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
