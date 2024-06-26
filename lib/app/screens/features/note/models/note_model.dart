import 'dart:convert';

class NoteModel {
  final int? id;
  final String? title;
  final String? description;
  final String? images; // label id list
  final int? subjectId;
  int? isFavourite;
  int? isPinned;
  int? isLocked;

  final int? label01Id;
  final int? label02Id;
  final int? label03Id;
  final int? label04Id;
  final int? label05Id;

  final int? createdAt;
  final int? createdAtDayFormat;
  final int? createdForDay;
  final int? updatedAt;
  final int? deletedAt;

  NoteModel(
      {required this.title,
      required this.description,
      required this.createdAt,
      this.images,
      this.subjectId,
      this.isFavourite,
      this.isPinned,
      this.isLocked,
      this.label01Id,
      this.label02Id,
      this.label03Id,
      this.label04Id,
      this.label05Id,
      this.createdAtDayFormat,
      this.createdForDay,
      this.updatedAt,
      this.deletedAt,
      this.id});

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      images: json['images'],
      subjectId: json['subjectId'],
      isFavourite: json['isFavourite'],
      isPinned: json['isPinned'],
      isLocked: json['isLocked'],
      label01Id: json['label01Id'],
      label02Id: json['label02Id'],
      label03Id: json['label03Id'],
      label04Id: json['label04Id'],
      label05Id: json['label05Id'],
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
        'images': images,
        'subjectId': subjectId,
        'isFavourite': isFavourite,
        'isPinned': isPinned,
        'isLocked': isLocked,
        'label01Id': label01Id,
        'label02Id': label02Id,
        'label03Id': label03Id,
        'label04Id': label04Id,
        'label05Id': label05Id,
        'createdAt': createdAt,
        'createdAtDayFormat': createdAtDayFormat,
        'createdForDay': createdForDay,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
