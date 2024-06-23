import 'package:cascade_flow/models/work_item.dart';
import 'package:cascade_flow/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cascade_flow/core/web_service.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class WorkItemState {
  final List<WorkItem> workItems;
  final bool isLoading;
  final String? error;
  final WorkItem? selectedWorkItem;
  final WorkItem? newWorkItem;

  WorkItemState({
    required this.workItems,
    required this.isLoading,
    this.error,
    this.selectedWorkItem,
    this.newWorkItem,
  });

  WorkItemState copyWith({
    List<WorkItem>? workItems,
    bool? isLoading,
    String? error,
    WorkItem? selectedWorkItem,
    WorkItem? newWorkItem,
  }) {
    return WorkItemState(
      workItems: workItems ?? this.workItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedWorkItem: selectedWorkItem ?? this.selectedWorkItem,
      newWorkItem: newWorkItem ?? this.newWorkItem,
    );
  }
}

class WorkItemNotifier extends StateNotifier<WorkItemState> {
  Ref ref;

  ProjectNotifier project = ProjectNotifier();

  WorkItemNotifier(this.ref) 
   : super(WorkItemState(workItems: [], isLoading: false)) {
    project = ref.watch(projectProvider.notifier);
  }

  void addWorkItem(WorkItem workItem) {
    state = state.copyWith(workItems: [...state.workItems, workItem]);
  }

  void removeWorkItem(WorkItem workItem) {
    state = state.copyWith(workItems: state.workItems.where((element) => element.id != workItem.id).toList()); 
  }

  void updateWorkItem(WorkItem workItem) {
    state = state.copyWith(workItems: state.workItems.map((e) => e.id == workItem.id ? workItem : e).toList());
  }

  void setWorkItems(List<WorkItem> workItems) {
    state = state.copyWith(workItems: workItems);
  }

  void setSelectedWorkItem(WorkItem workItem) {
    state = state.copyWith(selectedWorkItem: workItem);
  }
  
  void initNewWorkItem(WorkItem? parentWorkItem) {
    var workItem = WorkItem(
      id: WebService.generateGuid(),
      title: '',
      priority: 0,
      code: 0,
      assignee: '',
      description: '',
      workItemTypeName: 'Task',
      workItemTypeRef: 0,
      workItemStateName: 'New',
      workItemStateRef: 0,
      workItemRef: parentWorkItem?.id,
    );
    state = state.copyWith(newWorkItem: workItem);
  }  

  Future<void> fetchWorkItems() async {

    try {
      state = state.copyWith(isLoading: true);

      var response = await WebService.get('workItem/project/${project.state.selectedProject?.id}/toplevel');

      if (response.statusCode >= 400) {
        state = state.copyWith(error: 'Failed to fetch data. Please try again later.');
      }

      var data = jsonDecode(response.body) as List<dynamic>;
      var workItems = data.map((e) => WorkItem.fromJson(e)).toList();

      state = state.copyWith(workItems: workItems);
    } catch (e) {
      state = state.copyWith(error: 'Failed to fetch data. Please try again later.');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final workItemProvider = StateNotifierProvider<WorkItemNotifier, WorkItemState>((ref) => WorkItemNotifier(ref));


