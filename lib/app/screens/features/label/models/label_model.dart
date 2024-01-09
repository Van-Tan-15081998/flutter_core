class LabelModel {
  final int? id;
  final String title;
  final String color;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;

  const LabelModel(
      {required this.title,
        required this.color,
        required this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.id});

  factory LabelModel.fromJson(Map<String, dynamic> json) => LabelModel(
      id: json['id'],
      title: json['title'],
      color: json['color'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'color': color,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'deletedAt': deletedAt
  };
}
