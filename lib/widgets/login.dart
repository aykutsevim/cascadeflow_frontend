import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopping_list/widgets/work_item_list.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/logo_vector_drawing.svg',
              height: 80, width: 80),
          const SizedBox(height: 15),
          const Text("CascadeFlow",
              style: TextStyle(
                  color:Colors.black54,
                  fontFamily: "JosefinSans",
                  fontSize: 40,
                  fontWeight: FontWeight.normal)),
          const SizedBox(height: 160),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WorkItemList()),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
      ) );
  }
}
