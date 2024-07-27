import 'package:cascade_flow/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasePage extends ConsumerWidget {
  final Widget child;
  final Widget title;

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
        backgroundColor: const Color(0xffffffff),
        centerTitle: false,
        toolbarHeight: 100,
        title: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 5.0),
              child: 
                  Row(
                    children: [
                      title,
                      const Spacer(),
                      SvgPicture.network(
                        'https://api.multiavatar.com/${authState.avatarHashable}.svg',
                        height: 48,
                        width: 48),
                        const SizedBox(width: 20)
                    ],
                  ),
            ),
            const SizedBox(height: 20),
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