class TaskModel {
  final int? id;
  final String title;
  final String description;
  final String? labels; // label id list
  final int? statusId;

  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;

  const TaskModel(
      {required this.title,
      required this.description,
      this.labels,
      required this.createdAt,
      required this.statusId,
      this.updatedAt,
      this.deletedAt,
      this.id});

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      labels: json['labels'],
      statusId: json['statusId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'labels': labels,
        'statusId': statusId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
