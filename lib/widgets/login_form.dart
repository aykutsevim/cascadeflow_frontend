import 'package:cascade_flow/core/web_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cascade_flow/widgets/work_item_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
  
      var response = await WebService.post('Auth/login', body: {'username': _username, 'password': _password});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await WebService.storeToken(data['token']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login Successful! Welcome ${data['username']}')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WorkItemList()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to login with status code: ${response.statusCode}')),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/logo_vector_drawing.svg',
                  height: 80, width: 80),
              const SizedBox(height: 15),
              const Text("CascadeFlow",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "JosefinSans",
                      fontSize: 40,
                      fontWeight: FontWeight.normal)),
              const SizedBox(height: 120),
              SizedBox(
                width: 250,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        )));
  }
}
