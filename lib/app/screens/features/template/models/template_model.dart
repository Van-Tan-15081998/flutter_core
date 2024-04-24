import 'dart:convert';

class TemplateModel {
  final int? id;
  final String title;
  final String description;
  final String? labels; // label id list
  final int? subjectId;
  int? isFavourite;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;

  TemplateModel(
      {required this.title,
      required this.description,
      required this.createdAt,
      this.labels,
      this.subjectId,
      this.isFavourite,
      this.updatedAt,
      this.deletedAt,
      this.id});

  factory TemplateModel.fromJson(Map<String, dynamic> json) => TemplateModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      labels: json['labels'],
      subjectId: json['subjectId'],
      isFavourite: json['isFavourite'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'labels': labels,
        'subjectId': subjectId,
        'isFavourite': isFavourite,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
