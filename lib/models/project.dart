import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'projectName')
  final String projectName;

  @JsonKey(name: 'tenantRef')
  final int tenantRef;

  Project({
    required this.id,
    required this.projectName,
    required this.tenantRef,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}