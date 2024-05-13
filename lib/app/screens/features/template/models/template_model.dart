import 'dart:convert';

class TemplateModel {
  final int? id;
  final String title;
  final String description;
  final String? labels; // label id list
  final int? subjectId;
  int? isFavourite;
  int? isPinned;

  final int? label01Id;
  final int? label02Id;
  final int? label03Id;
  final int? label04Id;
  final int? label05Id;

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
      this.isPinned,
      this.label01Id,
      this.label02Id,
      this.label03Id,
      this.label04Id,
      this.label05Id,
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
      isPinned: json['isPinned'],
      label01Id: json['label01Id'],
      label02Id: json['label02Id'],
      label03Id: json['label03Id'],
      label04Id: json['label04Id'],
      label05Id: json['label05Id'],
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
        'isPinned': isPinned,
        'label01Id': label01Id,
        'label02Id': label02Id,
        'label03Id': label03Id,
        'label04Id': label04Id,
        'label05Id': label05Id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
