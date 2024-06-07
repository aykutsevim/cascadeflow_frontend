
import 'package:cascade_flow/models/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectProvider extends StateNotifier<List<Project>> {
  ProjectProvider() : super([]);
}

final projectProvider = StateNotifierProvider((ref) => ProjectProvider());