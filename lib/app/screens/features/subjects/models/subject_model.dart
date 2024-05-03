class SubjectModel {
  final int? id;
  final String title;
  final String color;
  final int? parentId;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;

  const SubjectModel(
      {required this.title,
      required this.color,
      required this.parentId,
      required this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.id});

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
      id: json['id'],
      title: json['title'],
      color: json['color'],
      parentId: json['parentId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'color': color,
        'parentId': parentId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
