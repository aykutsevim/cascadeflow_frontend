import 'package:cascade_flow/widgets/base_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cascade_flow/models/work_item.dart';
import 'package:cascade_flow/widgets/icons/task_icon.dart';
import 'package:cascade_flow/providers/project_provider.dart';
import 'package:cascade_flow/providers/work_item_provider.dart';

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

    if (state.workItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: state.workItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            //_removeItem(_weatherItems[index]);
          },
          key: ValueKey(state.workItems[index].id),
          child: ListTile(
            title: Text(
              state.workItems[index].description ?? '',
            ),
            leading: TaskIcon(taskType : state.workItems[index].workItemTypeRef),
            trailing: Text(
              state.workItems[index].workItemStateName,
            ),
          ),
        ),
      );
    }

    if (state.error != null) {
      content = Center(child: Text(state.error!));
    }

    return BasePage(
      title: 'Work Items',
      child: content,
    );
  }
}