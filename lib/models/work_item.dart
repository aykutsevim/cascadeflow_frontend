import 'package:json_annotation/json_annotation.dart';

part 'work_item.g.dart';

@JsonSerializable()
class WorkItem {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'workItemTypeRef')
  final int workItemTypeRef;

  @JsonKey(name: 'workItemTypeName')
  final String workItemTypeName;

  @JsonKey(name: 'workItemStateRef')
  final int workItemStateRef;

  @JsonKey(name: 'workItemStateName')
  final String workItemStateName;

  @JsonKey(name: 'assignee')
  final String? assignee;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'priority')
  final int priority;

  WorkItem({
    required this.id,
    required this.workItemTypeRef,
    required this.workItemTypeName,
    required this.workItemStateRef,
    required this.workItemStateName,
    required this.assignee,
    required this.title,
    required this.description,
    required this.priority,
  });

  factory WorkItem.fromJson(Map<String, dynamic> json) =>
      _$WorkItemFromJson(json);

  Map<String, dynamic> toJson() => _$WorkItemToJson(this);
}