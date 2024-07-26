import 'package:cascade_flow/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasePage extends ConsumerWidget {
  final Widget child;
  final String title;

  const BasePage({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      /*appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SvgPicture.network(
                    'https://api.multiavatar.com/${authState.avatarHashable}.svg',
                    height: 32,
                    width: 32),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.headlineMedium),
                    Text(authState.username ?? "<username>", style: Theme.of(context).textTheme.headlineSmall),
                  ],
                )
              ],
            )),
        toolbarHeight: 80,
      ),*/
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xfff0f0f0),
        centerTitle: false,
        toolbarHeight: 120,
        title: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 5.0),
              child: 
                  Row(
                    children: [
                      SvgPicture.asset('assets/logo_vector_2_plain.svg',
                          height: 48, width: 48),
                      const SizedBox(width: 12),
                      const Text("CascadeFlow",
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "JosefinSans",
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0),
                          ),
                          Text(
                            authState.username ?? "<username>",
                            style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      body: Container(
        // rounded corners
        decoration: const BoxDecoration(
          color:  Color(0xffe0e0e0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: child
        ),
    );
  }
}