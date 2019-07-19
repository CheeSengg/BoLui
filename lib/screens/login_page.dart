//Packages
import 'package:flutter/material.dart';
import 'package:bolui/models/auth_provider.dart';
import 'package:bolui/util/auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
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
        final BaseAuth auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          var userId = await auth.signInWithEmailAndPassword(_email, _password);
        } else {
          var userId =
              await auth.createUserWithEmailAndPassword(_email, _password);
        }
      } catch (e) {
        print('error $e');
      }
    }
  }

  void googleValidateAndSubmit() async {
    final BaseAuth auth = AuthProvider.of(context).auth;
    var userId = await auth.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: new Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: new SizedBox(
                          height: 180.0,
                          child: Center(
                            child: new Image(
                              fit: BoxFit.fitHeight,
                              image: AssetImage('assets/logo.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                          icon: Icon(Icons.email), labelText: "Email"),
                      validator: (value) =>
                          value.isEmpty ? 'Email can\'t be empty' : null,
                      onSaved: (value) => _email = value,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                          icon: Icon(Icons.lock), labelText: "Password"),
                      obscureText: true,
                      validator: (value) =>
                          value.isEmpty ? 'Password can\'t be empty' : null,
                      onSaved: (value) => _password = value,
                    ),
                    new SizedBox(
                      height: 10.0,
                      //child: ,
                    ),
                    middleLoginButton(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        child: Text('OR', style: TextStyle()),
                      ),
                    ),
                    new SignInButton(
                      Buttons.Google,
                      onPressed: googleValidateAndSubmit,
                    ),
                    new Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: bottomFlatButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget middleLoginButton() {
    return (_formType == FormType.login)
        ? new SignInButtonBuilder(
            text: 'Log in with Email',
            icon: Icons.email,
            onPressed: validateAndSubmit,
            backgroundColor: Colors.blueGrey[700],
          )
        : new SignInButtonBuilder(
            text: 'Sign Up',
            icon: Icons.email,
            onPressed: validateAndSubmit,
            backgroundColor: Colors.blueGrey[700],
          );
  }

  Widget bottomFlatButton() {
    return (_formType == FormType.login)
        ? new FlatButton(
            child: Text('New Here? Sign Up'),
            onPressed: moveToRegister,
          )
        : new FlatButton(
            child: Text('Have an account? Login'),
            onPressed: moveToLogin,
          );
  }

//  List<Widget> buildSubmitButtons() {
//    if (_formType == FormType.login) {
//      return [
//        new Padding(
//          padding: EdgeInsets.only(bottom: 30.0),
//        ),
//        new RaisedButton(
//          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
//          onPressed: validateAndSubmit,
//        ),
//        new Padding(
//          padding: EdgeInsets.only(bottom: 10.0),
//        ),
//        new FlatButton(
//          child: new Text('Create an account',
//              style: new TextStyle(fontSize: 20.0)),
//          onPressed: moveToRegister,
//        ),
//      ];
//    } else {
//      return [
//        new Padding(
//          padding: EdgeInsets.only(bottom: 30.0),
//        ),
//        new RaisedButton(
//          child: new Text('Create an account',
//              style: new TextStyle(fontSize: 20.0)),
//          onPressed: validateAndSubmit,
//        ),
//        new FlatButton(
//          child: new Text('Have an account? Login',
//              style: new TextStyle(fontSize: 20.0)),
//          onPressed: moveToLogin,
//        ),
//      ];
//    }
//  }
}
