enum ActionModeEnum { create, update, delete, copy }

enum ActionCreateNoteEnum { create, createForSelectedDay }

enum RedirectFromEnum {
  home,
  labels,
  labelDetail,
  labelCreate,
  labelUpdate,
  notes,
  noteDetail,
  noteCreate,
  noteUpdate,
  subjects,
  subjectCreate,
  subjectUpdate,
  subjectCreateNote,
  subjectDetail,
  templates,
  templateDetail,
  templateCreate,
  templateUpdate,
  templateCreateNote
}

  enum TaskStatusEnum {
  newStatus,
  pendingStatus,
  inProgressStatus,
  completedStatus,
  failedStatus,
  cancelledStatus,
  pausedStatus,
  scheduledStatus,
  overdueStatus
}
