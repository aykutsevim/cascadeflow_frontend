import 'package:cascade_flow/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cascade_flow/providers/project_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

final GlobalKey<FormState> appFormKey = GlobalKey<FormState>();

class ProjectList extends ConsumerWidget {
  const ProjectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SvgPicture.network(
                    'https://api.multiavatar.com/${authState.avatarHashable}.svg',
                    height: 48,
                    width: 48),
                const SizedBox(
                  width: 16,
                ),
                Text(authState.username ?? "<username>"),
              ],
            )),
        toolbarHeight: 160,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text(state.error!))
              : 
              state.projects.isEmpty
                ? const Center(child: Text('No projects found'))
                :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 16.0),
                    child: Text('Projects', style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.projects.length,
                        itemBuilder: (context, index) {
                          final project = state.projects[index];
                    
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 8, bottom: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          SvgPicture.network(
                                              'https://localhost:3001/api/Project/identicon/${project.id}',
                                              height: 40,
                                              width: 40),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(project.projectName),
                                                Text(project.projectName),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              ref
                                                  .read(projectProvider.notifier)
                                                  .removeProject(project);
                                            },
                                          ),
                                        ],
                                      ))));
                        },
                      ),
                  ),
                ],
              ),
    );
  }
}
