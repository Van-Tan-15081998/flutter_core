class SubjectConditionModel {
  int? id;
  String? title;
  String? searchText;
  bool? isDeleted;
  int? parentId;
  bool? isRootSubject;

  SubjectConditionModel({
    this.id,
    this.title,
    this.searchText,
    this.isDeleted,
    this.parentId,
    this.isRootSubject
  });
}
