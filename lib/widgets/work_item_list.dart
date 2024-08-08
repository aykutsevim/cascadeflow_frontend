import 'package:cascade_flow/widgets/base_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:cascade_flow/models/work_item.dart';
import 'package:cascade_flow/widgets/icons/task_icon.dart';
import 'package:cascade_flow/providers/project_provider.dart';
import 'package:cascade_flow/providers/work_item_provider.dart';
import 'package:cascade_flow/core/web_service.dart';

class WorkItemList extends ConsumerWidget {
  const WorkItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workItemProvider);
    final projectState = ref.watch(projectProvider);

    Widget content = const Center(child: Text('No items added yet.'));

    if (state.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      content = Center(child: Text(state.error!));
    }

    if (state.workItems.isNotEmpty) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 16.0),
            child: Text('Tasks',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Jaldi",
                    fontSize: 24,
                    fontWeight: FontWeight.normal)),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: state.workItems.length,
            itemBuilder: (ctx, index) {
              final workItem = state.workItems[index];

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
                              const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: TaskIcon(taskType: 1)),
                              /*SvgPicture.network(
                            '${WebService.baseIdenticonUrl}/${project.id}',
                            height: 40,
                            width: 40),*/
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(workItem.description ?? "",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontFamily: "Jaldi",
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal)),
                                    //Text(project.projectName),
                                  ],
                                ),
                              ),
                              /*IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            ref
                                .read(projectProvider.notifier)
                                .setSelectedProject(project);
                          },
                        ),*/
                            ],
                          ))));
/*
          return Dismissible(
          onDismissed: (direction) {
            //_removeItem(_weatherItems[index]);
          },
          key: ValueKey(workItem.id),
          child: ListTile(
            title: Text(
              workItem.description ?? '',
            ),
            leading: TaskIcon(taskType : workItem.workItemTypeRef),
            trailing: Text(
              workItem.workItemStateName,
            ),
          ),
        ),*/
            },
          )),
        ],
      );
    }

    return BasePage(
      title: Row(
        children: [
          projectState.selectedProject == null
              ? const SizedBox()
              : SvgPicture.network(
                  '${WebService.baseIdenticonUrl}/${projectState.selectedProject?.id}',
                  height: 40,
                  width: 40),
          const SizedBox(width: 20),
          Text(
            projectState.selectedProject == null
                ? ""
                : projectState.selectedProject?.projectName ?? "",
            style: const TextStyle(
                color: Colors.black54,
                fontFamily: 'Jaldi',
                fontWeight: FontWeight.normal,
                fontSize: 24.0),
          ),
        ],
      ),
      child: content,
    );
  }
}
