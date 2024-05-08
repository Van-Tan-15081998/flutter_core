class NoteConditionModel {
  String? title;
  String? description;
  int? createdAtStartOfDay;
  int? createdAtEndOfDay;
  int? labelId;
  int? subjectId;
  bool? onlyNoneSubject;
  String? searchText;
  bool? isDeleted;
  bool? recentlyUpdated;
  bool? favourite;
  bool? createdForDay;

  NoteConditionModel(
      {this.title,
      this.description,
      this.createdAtStartOfDay,
      this.createdAtEndOfDay,
      this.labelId,
      this.subjectId,
      this.onlyNoneSubject,
      this.searchText,
      this.isDeleted,
      this.recentlyUpdated,
      this.favourite,
      this.createdForDay});
}
