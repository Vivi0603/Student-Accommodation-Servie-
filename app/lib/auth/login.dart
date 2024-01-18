import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app/auth/signup.dart';
import 'package:app/screens/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      http.post(Uri.parse("http://10.0.2.2:3000/auth/login"),
          body: {"email": _email, "password": _password}).then((res) {
        if (res.statusCode == 200) {
          var responseJson = json.decode(res.body);
          if (responseJson['success']) {
            // Login success
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(responseJson['user_id'],responseJson['cluster']),
              ),
            );
          } else {
            // Login failed
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: Text(responseJson['message']),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          var responseJson = json.decode(res.body);
          // HTTP request failed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text(responseJson['message']),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: ((context) => Scaffold(
              appBar: AppBar(
                title: const Text("Login"),
              ),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Password"),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                      TextButton(
                        child: const Text("Login"),
                        onPressed: () {
                          _submit(context);
                        },
                      ),
                      TextButton(
                        child: const Text("Singup"),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
