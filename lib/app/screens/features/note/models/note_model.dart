import 'dart:convert';

class NoteModel {
  final int? id;
  final String? title;
  final String? description;
  final String? labels; // label id list
  final int? subjectId;
  int? isFavourite;
  final int? createdAt;
  final int? createdAtDayFormat;
  final int? createdForDay;
  final int? updatedAt;
  final int? deletedAt;

  NoteModel(
      {required this.title,
      required this.description,
      required this.createdAt,
      this.labels,
      this.subjectId,
      this.isFavourite,
      this.createdAtDayFormat,
      this.createdForDay,
      this.updatedAt,
      this.deletedAt,
      this.id});

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      labels: json['labels'],
      subjectId: json['subjectId'],
      isFavourite: json['isFavourite'],
      createdAt: json['createdAt'],
      createdAtDayFormat: json['createdAtDayFormat'],
      createdForDay: json['createdForDay'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt']);

  // factory NoteModel.fromJsonDistinctCreatedAt(Map<String, dynamic> json) => NoteModel(
  //     id: json['id'],
  //     title: json['title'],
  //     description: json['description'],
  //     labels: json['labels'],
  //     subjectId: json['subjectId'],
  //     isFavourite: json['isFavourite'],
  //     createdAt: json['createdAt'],
  //     createdAtDayFormat: json['createdAtDayFormat'],
  //     createdForDay: json['createdForDay'],
  //     updatedAt: json['updatedAt'],
  //     deletedAt: json['deletedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'labels': labels,
        'subjectId': subjectId,
        'isFavourite': isFavourite,
        'createdAt': createdAt,
        'createdAtDayFormat': createdAtDayFormat,
        'createdForDay': createdForDay,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
