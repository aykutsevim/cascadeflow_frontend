import 'package:cascade_flow/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cascade_flow/providers/project_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cascade_flow/core/web_service.dart';

final GlobalKey<FormState> appFormKey = GlobalKey<FormState>();

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: SvgPicture.network('https://api.multiavatar.com/${authState.avatarHashable}.svg',
                  height: 80, width: 80),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text(state.error!))
              : ListView.builder(
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) {
                    final project = state.projects[index];
                    return ListTile(
                      leading: SvgPicture.network('https://localhost:3001/api/Project/identicon/${project.id}',
                  height: 80, width: 80),
                      title: Text(project.projectName),
                      subtitle: Text(project.projectName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref.read(projectProvider.notifier).removeProject(project);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}