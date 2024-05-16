// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkItem _$WorkItemFromJson(Map<String, dynamic> json) => WorkItem(
      id: json['id'] as String,
      workItemTypeRef: (json['workItemTypeRef'] as num).toInt(),
      workItemTypeName: json['workItemTypeName'] as String,
      workItemStateRef: (json['workItemStateRef'] as num).toInt(),
      workItemStateName: json['workItemStateName'] as String,
      assignee: json['assignee'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: (json['priority'] as num).toInt(),
    );

Map<String, dynamic> _$WorkItemToJson(WorkItem instance) => <String, dynamic>{
      'id': instance.id,
      'workItemTypeRef': instance.workItemTypeRef,
      'workItemTypeName': instance.workItemTypeName,
      'workItemStateRef': instance.workItemStateRef,
      'workItemStateName': instance.workItemStateName,
      'assignee': instance.assignee,
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
    };
