class NoteConditionModel {
  String? title;
  String? description;
  int? createdAtStartOfDay;
  int? createdAtEndOfDay;
  int? labelId;
  int? subjectId;
  String? searchText;
  bool? isDeleted;
  bool? recentlyUpdated;

  NoteConditionModel({
    this.title,
    this.description,
    this.createdAtStartOfDay,
    this.createdAtEndOfDay,
    this.labelId,
    this.subjectId,
    this.searchText,
    this.isDeleted,
    this.recentlyUpdated
  });
}
