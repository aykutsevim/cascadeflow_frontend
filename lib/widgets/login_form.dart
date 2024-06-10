import 'package:cascade_flow/providers/project_provider.dart';
import 'package:cascade_flow/widgets/project_list.dart';
import 'package:flutter/material.dart';
import 'package:cascade_flow/widgets/work_item_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cascade_flow/providers/auth_provider.dart';

final GlobalKey<FormState> appFormKey = GlobalKey<FormState>();

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final state = ref.watch(authProvider);

    // Checking for state changes and navigating accordingly
    if (state.isAuthenticated == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(projectProvider.notifier).fetchProjects();
     
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProjectList()),
        );
      });
    }


    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Form(
          key: appFormKey,
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
                  initialValue: "username",
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
                  onChanged: (value) => ref.read(authProvider.notifier).setUsername(value),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: TextFormField(
                  initialValue: "password",
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
                  onChanged: (value) => ref.read(authProvider.notifier).setPassword(value),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                      if (appFormKey.currentState!.validate()) {
                        appFormKey.currentState!.save();

                        ref.read(authProvider.notifier).login();
                      }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        )));
  }
}


