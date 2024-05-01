class SubjectConditionModel {
  int? id;
  String? title;
  String? searchText;
  bool? isDeleted;
  int? parentId;
  int? onlyParentId;
  bool? isRootSubject;

  SubjectConditionModel({
    this.id,
    this.title,
    this.searchText,
    this.isDeleted,
    this.parentId,
    this.onlyParentId,
    this.isRootSubject
  });
}
