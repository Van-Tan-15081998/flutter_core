class TemplateConditionModel {
  String? title;
  String? description;
  int? labelId;
  int? subjectId;
  String? searchText;
  bool? isDeleted;
  bool? recentlyUpdated;
  bool? favourite;

  TemplateConditionModel({
    this.title,
    this.description,
    this.labelId,
    this.subjectId,
    this.searchText,
    this.isDeleted,
    this.recentlyUpdated,
    this.favourite
  });
}
