import 'package:cascade_flow/models/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cascade_flow/core/web_service.dart';
import 'dart:convert';

class ProjectState {
  final List<Project> projects;
  final bool isLoading;
  final String? error;
  final Project? selectedProject;


  ProjectState({
    required this.projects,
    required this.isLoading,
    this.error,
    this.selectedProject,
  });

  ProjectState copyWith({
    List<Project>? projects,
    bool? isLoading,
    String? error,
    Project? selectedProject,
  }) {
    return ProjectState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedProject: selectedProject ?? this.selectedProject,
    );
  }
}

class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier() : super(ProjectState(projects: [], isLoading: false));

  void addProject(Project project) {
    state = state.copyWith(projects: [...state.projects, project]);
  }

  void removeProject(Project project) {
    state = state.copyWith(projects: state.projects.where((element) => element.id != project.id).toList()); 
  }

  void updateProject(Project project) {
    state = state.copyWith(projects: state.projects.map((e) => e.id == project.id ? project : e).toList());
  }

  void setProjects(List<Project> projects) {
    state = state.copyWith(projects: projects);
  }

  void setSelectedProject(Project project) {
    state = state.copyWith(selectedProject: project);
  }
  
  Future<void> fetchProjects() async {
    try {
      state = state.copyWith(isLoading: true);

      var response = await WebService.get('Project/tenant');

      if (response.statusCode >= 400) {
        state = state.copyWith(error: 'Failed to fetch data. Please try again later.');
      }

      if (response.body == 'null') {
        state = state.copyWith(isLoading: false);

        return;
      }

      final List<dynamic> fetchedRawData = json.decode(response.body);
      final List<Project> loadedItems = fetchedRawData.map((item) => Project.fromJson(item)).toList();

      state = state.copyWith(projects: loadedItems, isLoading: false);

    } catch (error) {
      state = state.copyWith(error: 'Failed to fetch data. Please try again later.');
    }

  }

}

final projectProvider = StateNotifierProvider<ProjectNotifier, ProjectState>((ref) => ProjectNotifier());