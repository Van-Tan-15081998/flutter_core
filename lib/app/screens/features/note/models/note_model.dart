class NoteModel {
  final int? id;
  final String title;
  final String description;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;

  const NoteModel(
      {required this.title,
      required this.description,
      required this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.id});

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
