import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cascade_flow/providers/project_provider.dart';

final GlobalKey<FormState> appFormKey = GlobalKey<FormState>();

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
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