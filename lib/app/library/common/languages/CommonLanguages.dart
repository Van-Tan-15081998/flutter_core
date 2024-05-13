class CommonLanguages {
  static List<String> languageStringList() {
    List<String> languageStringList = [
      'English',
      'Russian',
      'Vietnamese',
      'Portuguese',
      'Spanish',
      'Chinese',
      'Japanese',
      'Indonesian',
      'French',
      'Korean'
    ];

    return languageStringList;
  }

  static String languageStringDefault() {
    String languageStringDefault = 'English';

    return languageStringDefault;
  }

  /*
  CommonLanguages.flagLanguageSourceString()
   */
  static String flagLanguageSourceString(String languageStr) {
    String flagLanguageSourceString = 'assets/images/flags/english.jpg';

    switch (languageStr) {
      case 'English':
        {
          flagLanguageSourceString = 'assets/images/flags/english.jpg';
          break;
        }
      case 'Russian':
        {
          flagLanguageSourceString = 'assets/images/flags/russian.jpg';
          break;
        }
      case 'Vietnamese':
        {
          flagLanguageSourceString = 'assets/images/flags/vietnamese.jpg';
          break;
        }
      case 'Portuguese':
        {
          flagLanguageSourceString = 'assets/images/flags/portuguese.jpg';
          break;
        }
      case 'Spanish':
        {
          flagLanguageSourceString = 'assets/images/flags/spanish.jpg';
          break;
        }
      case 'Chinese':
        {
          flagLanguageSourceString = 'assets/images/flags/chinese.jpg';
          break;
        }
      case 'Japanese':
        {
          flagLanguageSourceString = 'assets/images/flags/japanese.jpg';
          break;
        }
      case 'Indonesian':
        {
          flagLanguageSourceString = 'assets/images/flags/indonesian.jpg';
          break;
        }
      case 'French':
        {
          flagLanguageSourceString = 'assets/images/flags/french.jpg';
          break;
        }
      case 'Korean':
        {
          flagLanguageSourceString = 'assets/images/flags/korean.jpg';
          break;
        }
    }

    return flagLanguageSourceString;
  }

  /*
  CommonLanguages.convert(lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(),word: '')
   */
  static Map<String, String> englishWords = {
    "screen.title.notes": "Notes",
    "screen.title.subjects": "Topics",
    "screen.title.subSubjects": "Subtopics",
    "screen.title.labels": "Labels",
    "screen.title.templates": "Templates",
    "screen.title.advertisements": "Advertisements",
    "screen.title.settings": "Settings",
    "screen.title.settings.display": "Display",
    "screen.title.settings.languages": "Languages",
    "screen.title.settings.backgroundMusic": "Background music",
    "screen.title.settings.colorThemes": "Color themes",
    "screen.title.selectedDate": "Selected date",
    "screen.title.content": "Content",
    "screen.title.titleNotSet": "Title not set",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "Set the background color for the note title (the background color of the note's topic)",
    "screen.title.settings.setNoteContentExpanded":
        "The content of the note has been expanded",
    "screen.title.settings.setTemplateContentExpanded":
        "The content of the note template has been expanded",
    "screen.title.settings.setSubjectActionsExpanded":
        "The list of actions for the Topic (List view mode) has been expanded",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "Stick note title when scrolling note list",
    "screen.title.settings.setBackgroundImage": "Set background image",
    "screen.title.settings.opacityNumber": "Transparency level",
    "screen.title.viewImage": "View image",

    ///
    "screen.title.create": "Create new",
    "screen.title.update": "Update",
    "screen.title.detail": "Details",

    "screen.title.create.note": "Create note",
    "screen.title.update.note": "Update note",
    "screen.title.detail.note": "Note details",
    //
    "screen.title.create.subject": "Create a topic",
    "screen.title.update.subject": "Update topic",
    "screen.title.detail.subject": "Topic details",
    //
    "screen.title.create.label": "Create label",
    "screen.title.update.label": "Update label",
    "screen.title.detail.label": "Label details",
    //
    "screen.title.create.template": "Create template",
    "screen.title.update.template": "Update template",
    "screen.title.detail.template": "Template details",

    ///
    "button.title.all": "All",
    "button.title.open": "Open",
    "button.title.setting": "Settings",
    "button.title.shortcuts": "Quick accesses",
    "button.title.createShortcut": "Create shortcut",
    "button.title.update": "Update",
    "button.title.delete": "Delete",
    "button.title.iGotIt": "I understand",
    "button.title.accept": "Accept",
    "button.title.cancel": "Cancel",
    "button.title.close": "Close",
    "button.title.createNote": "Create a note",
    "button.title.createNoteForSelectedDay":
        "Create a note for the selected date",
    "button.title.selectLabel": "Select labels",
    "button.title.selectSubject": "Select a topic",
    "button.title.selectPicture": "Select an image",
    "button.title.colorPalette": "Color palette",

    ///
    "card.title.total": "Total",
    "card.title.youWroteAt": "You wrote at",
    //
    "form.field.title.title": "Title",
    "form.field.title.content": "Content",
    "form.field.title.subject": "Topic",
    "form.field.title.parentSubject": "Parent topic",
    "form.field.title.label": "Labels",
    "form.field.title.labelName": "Label name",
    "form.field.title.subjectName": "Topic name",
    "form.field.title.color": "Color",
    "form.field.title.lock": "Lock note",
    "form.field.title.avatar": "Profile picture",
    "form.field.title.images": "Images",
    "form.filter.filter": "Filter",
    "form.filter.subject": "Topic",
    "form.filter.label": "Label",
    "form.filter.rootSubject": "Root topic",
    "form.filter.trash": "Trash bin",
    "form.filter.favourite": "Favorite",
    "form.filter.recentlyUpdated": "Recently updated",
    "form.filter.dueDate": "Due date",
    "form.filter.searchKeyword": "Search keyword",
    "form.filter.creationTime": "Creation time",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "Not select",
    "form.field.enterContentNote": "Enter your note content",
    "form.field.enterTitleNote": "Enter your note title",

    ///
    "notification.noItem.note": "No notes found!",
    "notification.noItem.subject": "No topics found!",
    "notification.noItem.label": "No labels found!",
    "notification.noItem.template": "No note templates found!",
    "notification.action.created": "Successfully created",
    "notification.action.updated": "Successfully updated",
    "notification.action.deleted": "Successfully deleted",
    "notification.action.restored": "Successfully restored",
    "notification.action.unlocked": "Successfully unlocked ",
    "notification.action.titleCompleted": "Completed",
    "notification.action.titleError": "Error",
    "notification.action.titleWarning": "Warning",
    "notification.action.error":
        "An error occurred, please check and try again",
    "notification.action.cannotDelete.subject":
        "You cannot delete because this topic has subtopics or notes! Please delete all subtopics and notes to delete this topic.",
    "notification.action.confirm.exitScreen":
        "Please confirm to exit this screen.",
    "notification.action.confirm.delete": "Please confirm to delete.",
    "notification.action.confirm.unlock": "Please confirm to unlock.",
    "notification.action.updatedSetting": "Settings updated successfully",
    "notification.action.requiredNoteContent":
        "You haven't entered any content.",
    "notification.action.requiredLabelName":
        "You haven't entered the label name.",
    "notification.action.requiredSubjectName":
        "You haven't entered the topic name.",
    "notification.action.requiredSearchKeyWord":
        "You haven't entered a search keyword.",

    ///
    "tooltip.button.notesHome": "Notes",
    "tooltip.button.createNote": "Create note",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "Topics",
    "tooltip.button.createSubject": "Create topic",
    "tooltip.button.createSubSubject": "Create subtopic",
    "tooltip.button.labelsHome": "Labels",
    "tooltip.button.createLabel": "Create label",
    "tooltip.button.templatesHome": "Templates",
    "tooltip.button.createTemplate": "Create template",
    "tooltip.button.rootFolder": "Root folder",
    "tooltip.button.": "",

    "tooltip.button.home": "Homepage",
    "tooltip.button.save": "Save",
    "tooltip.button.update": "Update",
    "tooltip.button.delete": "Delete",
    "tooltip.button.deleteForever": "Permanently delete",
    "tooltip.button.restore": "Restore",
    "tooltip.button.unlock": "Unlock",
    "tooltip.button.filter": "Filter",
    "tooltip.button.reload": "Refresh page",
    "tooltip.button.search": "Search",
    "tooltip.button.calendar": "Calendar",
    "tooltip.button.parentSubject": "Parent topic",
    "tooltip.button.subSubject": "Subtopic",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> russianWords = {
    "screen.title.notes": "Заметки",
    "screen.title.subjects": "Темы",
    "screen.title.subSubjects": "Подтемы",
    "screen.title.labels": "Метки",
    "screen.title.templates": "Шаблоны",
    "screen.title.advertisements": "Рекламы",
    "screen.title.settings": "Настройки",
    "screen.title.settings.display": "Дисплей",
    "screen.title.settings.languages": "Языки",
    "screen.title.settings.backgroundMusic": "Фоновая музыка",
    "screen.title.settings.colorThemes": "Цветовые темы",
    "screen.title.selectedDate": "Выбранная дата",
    "screen.title.content": "Содержание",
    "screen.title.titleNotSet": "Заголовок не установлен",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "Установите цвет фона для заголовка заметки (цвет фона темы заметки)",
    "screen.title.settings.setNoteContentExpanded":
        "Содержимое заметки было расширено",
    "screen.title.settings.setTemplateContentExpanded":
        "Содержимое шаблона заметки было расширено",
    "screen.title.settings.setSubjectActionsExpanded":
        "Список действий для темы (режим просмотра списка) был расширен",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "Закрепить заголовок заметки при прокрутке списка заметок",
    "screen.title.settings.setBackgroundImage":
        "Установить фоновое изображение",
    "screen.title.settings.opacityNumber": "Уровень прозрачности",
    "screen.title.viewImage": "Просмотреть изображение",

    ///
    "screen.title.create": "Создать новый",
    "screen.title.update": "Обновить",
    "screen.title.detail": "Детали",

    "screen.title.create.note": "Создать заметку",
    "screen.title.update.note": "Обновить заметку",
    "screen.title.detail.note": "Детали записи",
    //
    "screen.title.create.subject": "Создать тему",
    "screen.title.update.subject": "Обновить тему",
    "screen.title.detail.subject": "Детали темы",
    //
    "screen.title.create.label": "Создать ярлык",
    "screen.title.update.label": "Обновить ярлык",
    "screen.title.detail.label": "Детали ярлыка",
    //
    "screen.title.create.template": "Создать шаблон",
    "screen.title.update.template": "Обновить шаблон",
    "screen.title.detail.template": "Детали шаблона",

    ///
    "button.title.all": "Все",
    "button.title.open": "Открыть",
    "button.title.setting": "Настройки",
    "button.title.shortcuts": "Быстрый доступ",
    "button.title.createShortcut": "Создать ярлык",
    "button.title.update": "Обновить",
    "button.title.delete": "Удалить",
    "button.title.iGotIt": "Я понял",
    "button.title.accept": "Принять",
    "button.title.cancel": "Отменить",
    "button.title.close": "Закрыть",
    "button.title.createNote": "Создать заметку",
    "button.title.createNoteForSelectedDay":
        "Создать заметку для выбранной даты",
    "button.title.selectLabel": "Выберите ярлыки",
    "button.title.selectSubject": "Выберите тему",
    "button.title.selectPicture": "Выберите изображение",
    "button.title.colorPalette": "Цветовая палитра",

    ///
    "card.title.total": "Общее количество",
    "card.title.youWroteAt": "Вы написали в",
    //
    "form.field.title.title": "Заголовок",
    "form.field.title.content": "Содержание",
    "form.field.title.subject": "Тема",
    "form.field.title.parentSubject": "Родительская тема",
    "form.field.title.label": "Метки",
    "form.field.title.labelName": "Название ярлыка",
    "form.field.title.subjectName": "Название темы",
    "form.field.title.color": "Цвет",
    "form.field.title.lock": "Заблокировать заметку",
    "form.field.title.avatar": "Аватар",
    "form.field.title.images": "Изображения",
    "form.filter.filter": "Фильтровать",
    "form.filter.subject": "Тема",
    "form.filter.label": "Ярлык",
    "form.filter.rootSubject": "Корневая тема",
    "form.filter.trash": "Мусорное ведро",
    "form.filter.favourite": "Избранное",
    "form.filter.recentlyUpdated": "Недавно обновлено",
    "form.filter.dueDate": "Срок",
    "form.filter.searchKeyword": "Ключевое слово для поиска",
    "form.filter.creationTime": "Время создания",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "Не выбирать",
    "form.field.enterContentNote": "Введите содержание вашей заметки",
    "form.field.enterTitleNote": "Введите заголовок вашей заметки",

    ///
    "notification.noItem.note": "Нет заметок!",
    "notification.noItem.subject": "Нет тем!",
    "notification.noItem.label": "Нет ярлыков!",
    "notification.noItem.template": "Нет шаблонов заметок!",
    "notification.action.created": "Успешно создано",
    "notification.action.updated": "Успешно обновлено",
    "notification.action.deleted": "Успешно удалено",
    "notification.action.restored": "Успешно восстановлено",
    "notification.action.unlocked": "Успешно разблокировано",
    "notification.action.titleCompleted": "Завершено",
    "notification.action.titleError": "Ошибка",
    "notification.action.titleWarning": "Предупреждение",
    "notification.action.error":
        "Произошла ошибка, пожалуйста, проверьте и повторите попытку",
    "notification.action.cannotDelete.subject":
        "Вы не можете удалить, так как у этой темы есть подтемы или заметки! Пожалуйста, удалите все подтемы и заметки, чтобы удалить эту тему.",
    "notification.action.confirm.exitScreen":
        "Пожалуйста, подтвердите, чтобы выйти с этого экрана.",
    "notification.action.confirm.delete":
        "Пожалуйста, подтвердите, чтобы удалить.",
    "notification.action.confirm.unlock":
        "Пожалуйста, подтвердите, чтобы разблокировать.",
    "notification.action.updatedSetting": "Настройки успешно обновлены",
    "notification.action.requiredNoteContent": "Вы не ввели содержание.",
    "notification.action.requiredLabelName": "Вы не ввели название метки.",
    "notification.action.requiredSubjectName": "Вы не ввели название темы.",
    "notification.action.requiredSearchKeyWord":
        "Вы не ввели ключевое слово для поиска.",

    ///
    "tooltip.button.notesHome": "Заметки",
    "tooltip.button.createNote": "Создать заметку",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "Темы",
    "tooltip.button.createSubject": "Создать тему",
    "tooltip.button.createSubSubject": "Создать подтему",
    "tooltip.button.labelsHome": "Метки",
    "tooltip.button.createLabel": "Создать ярлык",
    "tooltip.button.templatesHome": "Шаблоны",
    "tooltip.button.createTemplate": "Создать шаблон",
    "tooltip.button.rootFolder": "Корневая папка",
    "tooltip.button.": "",

    "tooltip.button.home": "Домашняя страница",
    "tooltip.button.save": "Сохранить",
    "tooltip.button.update": "Обновить",
    "tooltip.button.delete": "Удалить",
    "tooltip.button.deleteForever": "Полностью удалить",
    "tooltip.button.restore": "Восстановить",
    "tooltip.button.unlock": "Разблокировать",
    "tooltip.button.filter": "Фильтр",
    "tooltip.button.reload": "Обновить страницу",
    "tooltip.button.search": "Поиск",
    "tooltip.button.calendar": "Календарь",
    "tooltip.button.parentSubject": "Родительская тема",
    "tooltip.button.subSubject": "Подтема",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> vietnameseWords = {
    "screen.title.notes": "Ghi chú",
    "screen.title.subjects": "Chủ đề",
    "screen.title.subSubjects": "Các chủ đề con",
    "screen.title.labels": "Nhãn dán",
    "screen.title.templates": "Mẫu",
    "screen.title.advertisements": "Quảng cáo",
    "screen.title.settings": "Cài đặt",
    "screen.title.settings.display": "Hiển thị",
    "screen.title.settings.languages": "Ngôn ngữ",
    "screen.title.settings.backgroundMusic": "Âm nhạc nền",
    "screen.title.settings.colorThemes": "Các chủ đề màu sắc",
    "screen.title.selectedDate": "Ngày đã chọn",
    "screen.title.content": "Nội dung",
    "screen.title.titleNotSet": "Chưa đặt tiêu đề",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "Đặt màu nền cho tiêu đề của ghi chú (màu nền của chủ đề của ghi chú)",
    "screen.title.settings.setNoteContentExpanded":
        "Nội dung của ghi chú đã được mở rộng",
    "screen.title.settings.setTemplateContentExpanded":
        "Nội dung của mẫu ghi chú đã được mở rộng",
    "screen.title.settings.setSubjectActionsExpanded":
        "Danh sách các thao tác của Chủ đề (Chế độ xem danh sách) đã được mở rộng",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "Ghim tiêu đề ghi chú khi cuộn danh sách ghi chú",
    "screen.title.settings.setBackgroundImage": "Đặt hình nền",
    "screen.title.settings.opacityNumber": "Độ trong suốt",
    "screen.title.viewImage": "Xem ảnh",

    ///
    "screen.title.create": "Tạo mới",
    "screen.title.update": "Cập nhật",
    "screen.title.detail": "Chi tiết",

    "screen.title.create.note": "Tạo ghi chú",
    "screen.title.update.note": "Cập nhật ghi chú",
    "screen.title.detail.note": "Chi tiết của ghi chú",
    //
    "screen.title.create.subject": "Tạo chủ đề",
    "screen.title.update.subject": "Cập nhật chủ đề",
    "screen.title.detail.subject": "Chi tiết của chủ đề",
    //
    "screen.title.create.label": "Tạo nhãn dán",
    "screen.title.update.label": "Cập nhật nhãn dán",
    "screen.title.detail.label": "Chi tiết nhãn dán",
    //
    "screen.title.create.template": "Tạo mẫu ghi chú",
    "screen.title.update.template": "Cập nhật mẫu ghi chú",
    "screen.title.detail.template": "Chi tiết mẫu ghi chú",

    ///
    "button.title.all": "Tất cả",
    "button.title.open": "Mở",
    "button.title.setting": "Cài đặt",
    "button.title.shortcuts": "Truy cập nhanh",
    "button.title.createShortcut": "Tạo lối tắt",
    "button.title.update": "Cập nhật",
    "button.title.delete": "Xóa",
    "button.title.iGotIt": "Tôi đã hiểu",
    "button.title.accept": "Chấp nhận",
    "button.title.cancel": "Hủy",
    "button.title.close": "Đóng",
    "button.title.createNote": "Tạo ghi chú",
    "button.title.createNoteForSelectedDay": "Tạo ghi chú cho ngày đã chọn",
    "button.title.selectLabel": "Chọn các nhãn dán",
    "button.title.selectSubject": "Chọn một chủ đề",
    "button.title.selectPicture": "Chọn một hình ảnh",
    "button.title.colorPalette": "Bảng màu",

    ///
    "card.title.total": "Tổng",
    "card.title.youWroteAt": "Bạn đã viết vào lúc",
    //
    "form.field.title.title": "Tiêu đề",
    "form.field.title.content": "Nội dung",
    "form.field.title.subject": "Chủ đề",
    "form.field.title.parentSubject": "Chủ đề cha",
    "form.field.title.label": "Nhãn dán",
    "form.field.title.labelName": "Tên nhãn dán",
    "form.field.title.subjectName": "Tên chủ đề",
    "form.field.title.color": "Màu sắc",
    "form.field.title.lock": "Khóa ghi chú",
    "form.field.title.avatar": "Ảnh đại diện",
    "form.field.title.images": "Hình ảnh",
    "form.filter.filter": "Bộ lọc",
    "form.filter.subject": "Chủ đề",
    "form.filter.label": "Nhãn dán",
    "form.filter.rootSubject": "Chủ đề gốc",
    "form.filter.trash": "Thùng rác",
    "form.filter.favourite": "Yêu thích",
    "form.filter.recentlyUpdated": "Đã cập nhật gần đây",
    "form.filter.dueDate": "Ngày đến hạn",
    "form.filter.searchKeyword": "Từ khóa tìm kiếm",
    "form.filter.creationTime": "Thời gian tạo",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "Không chọn",
    "form.field.enterContentNote": "Nhập nội dung ghi chú của bạn",
    "form.field.enterTitleNote": "Nhập tiêu đề ghi chú của bạn",
    ///
    "notification.noItem.note": "Không có ghi chú nào!",
    "notification.noItem.subject": "Không có chủ đề nào!",
    "notification.noItem.label": "Không có nhãn dán nào!",
    "notification.noItem.template": "Không có mẫu ghi chú nào!",
    "notification.action.created": "Đã tạo thành công",
    "notification.action.updated": "Đã cập nhật thành công",
    "notification.action.deleted": "Đã xóa thành công",
    "notification.action.restored": "Đã khôi phục thành công",
    "notification.action.unlocked": "Đã mở khóa thành công",
    "notification.action.titleCompleted": "Hoàn tất",
    "notification.action.titleError": "Lỗi",
    "notification.action.titleWarning": "Cảnh báo",
    "notification.action.error": "Đã xảy ra lỗi, vui lòng kiểm tra và thử lại",
    "notification.action.cannotDelete.subject":
        "Bạn không thể xóa vì chủ đề này có các chủ đề con hoặc ghi chú! Vui lòng xóa tất cả các chủ đề con và ghi chú để có thể xóa chủ đề này.",
    "notification.action.confirm.exitScreen":
        "Vui lòng xác nhận để thoát khỏi màn hình này.",
    "notification.action.confirm.delete": "Vui lòng xác nhận để xóa.",
    "notification.action.confirm.unlock": "Vui lòng xác nhận để mở khóa.",
    "notification.action.updatedSetting": "Cập nhật cài đặt thành công",
    "notification.action.requiredNoteContent": "Bạn chưa nhập nội dung.",
    "notification.action.requiredLabelName": "Bạn chưa nhập tên nhãn dán.",
    "notification.action.requiredSubjectName": "Bạn chưa nhập tên chủ đề.",
    "notification.action.requiredSearchKeyWord":
        "Bạn chưa nhập từ khóa tìm kiếm.",

    ///
    "tooltip.button.notesHome": "Ghi chú",
    "tooltip.button.createNote": "Tạo ghi chú",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "Chủ đề",
    "tooltip.button.createSubject": "Tạo chủ đề",
    "tooltip.button.createSubSubject": "Tạo chủ đề con",
    "tooltip.button.labelsHome": "Nhãn dán",
    "tooltip.button.createLabel": "Tạo nhãn dán",
    "tooltip.button.templatesHome": "Mẫu",
    "tooltip.button.createTemplate": "Tạo mẫu",
    "tooltip.button.rootFolder": "Thư mục gốc",
    "tooltip.button.": "",

    "tooltip.button.home": "Trang chủ",
    "tooltip.button.save": "Lưu",
    "tooltip.button.update": "Cập nhật",
    "tooltip.button.delete": "Xóa",
    "tooltip.button.deleteForever": "Xóa vĩnh viễn",
    "tooltip.button.restore": "Khôi phục",
    "tooltip.button.unlock": "Mở khóa",
    "tooltip.button.filter": "Bộ lọc",
    "tooltip.button.reload": "Tải lại trang",
    "tooltip.button.search": "Tìm kiếm",
    "tooltip.button.calendar": "Lịch",
    "tooltip.button.parentSubject": "Chủ đề cha",
    "tooltip.button.subSubject": "Chủ đề con",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> portugueseWords = {
    "screen.title.notes": "Notas",
    "screen.title.subjects": "Tópicos",
    "screen.title.subSubjects": "Subtemas",
    "screen.title.labels": "Etiquetas",
    "screen.title.templates": "Modelos",
    "screen.title.advertisements": "Anúncios",
    "screen.title.settings": "Configurações",
    "screen.title.settings.display": "Exibição",
    "screen.title.settings.languages": "Idiomas",
    "screen.title.settings.backgroundMusic": "Música de fundo",
    "screen.title.settings.colorThemes": "Temas de cores",
    "screen.title.selectedDate": "Data selecionada",
    "screen.title.content": "Conteúdo",
    "screen.title.titleNotSet": "Título não definido",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "Defina a cor de fundo para o título da nota (a cor de fundo do tópico da nota)",
    "screen.title.settings.setNoteContentExpanded":
        "O conteúdo da nota foi expandido",
    "screen.title.settings.setTemplateContentExpanded":
        "O conteúdo do modelo de nota foi expandido",
    "screen.title.settings.setSubjectActionsExpanded":
        "A lista de ações para o Tópico (modo de visualização de lista) foi expandida",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "Fixar o título da nota ao rolar a lista de notas",
    "screen.title.settings.setBackgroundImage": "Definir imagem de fundo",
    "screen.title.settings.opacityNumber": "Nível de transparência",
    "screen.title.viewImage": "Ver imagem",

    ///
    "screen.title.create": "Criar novo",
    "screen.title.update": "Atualizar",
    "screen.title.detail": "Detalhes",

    "screen.title.create.note": "Criar nota",
    "screen.title.update.note": "Atualizar nota",
    "screen.title.detail.note": "Detalhes da nota",
    //
    "screen.title.create.subject": "Criar um tópico",
    "screen.title.update.subject": "Atualizar tópico",
    "screen.title.detail.subject": "Detalhes do tópico",
    //
    "screen.title.create.label": "Criar etiqueta",
    "screen.title.update.label": "Atualizar etiqueta",
    "screen.title.detail.label": "Detalhes da etiqueta",
    //
    "screen.title.create.template": "Criar modelo",
    "screen.title.update.template": "Atualizar modelo",
    "screen.title.detail.template": "Detalhes do modelo",

    ///
    "button.title.all": "Todos",
    "button.title.open": "Abrir",
    "button.title.setting": "Configurações",
    "button.title.shortcuts": "Acessos rápidos",
    "button.title.createShortcut": "Criar atalho",
    "button.title.update": "Atualizar",
    "button.title.delete": "Excluir",
    "button.title.iGotIt": "Eu entendi",
    "button.title.accept": "Aceitar",
    "button.title.cancel": "Cancelar",
    "button.title.close": "Fechar",
    "button.title.createNote": "Criar uma nota",
    "button.title.createNoteForSelectedDay":
        "Criar uma nota para a data selecionada",
    "button.title.selectLabel": "Selecionar etiquetas",
    "button.title.selectSubject": "Selecionar um tópico",
    "button.title.selectPicture": "Selecione uma imagem",
    "button.title.colorPalette": "Paleta de cores",

    ///
    "card.title.total": "Total",
    "card.title.youWroteAt": "Você escreveu às",
    //
    "form.field.title.title": "Título",
    "form.field.title.content": "Conteúdo",
    "form.field.title.subject": "Tópico",
    "form.field.title.parentSubject": "Tópico pai",
    "form.field.title.label": "Etiquetas",
    "form.field.title.labelName": "Nome da etiqueta",
    "form.field.title.subjectName": "Nome do tópico",
    "form.field.title.color": "Cor",
    "form.field.title.lock": "Bloquear nota",
    "form.field.title.avatar": "Foto de perfil",
    "form.field.title.images": "Imagens",
    "form.filter.filter": "Filtrar",
    "form.filter.subject": "Tópico",
    "form.filter.label": "Etiqueta",
    "form.filter.rootSubject": "Tópico raiz",
    "form.filter.trash": "Lixeira",
    "form.filter.favourite": "Favorito",
    "form.filter.recentlyUpdated": "Atualizado recentemente",
    "form.filter.dueDate": "Data de vencimento",
    "form.filter.searchKeyword": "Palavra-chave de pesquisa",
    "form.filter.creationTime": "Hora de criação",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "Não selecionar",
    "form.field.enterContentNote": "Digite o conteúdo da sua nota",
    "form.field.enterTitleNote": "Digite o título da sua nota",

    ///
    "notification.noItem.note": "Sem notas!",
    "notification.noItem.subject": "Sem tópicos!",
    "notification.noItem.label": "Sem etiquetas!",
    "notification.noItem.template": "Não há nenhum modelo de notas!",
    "notification.action.created": "Criado com sucesso",
    "notification.action.updated": "Atualizado com sucesso",
    "notification.action.deleted": "Excluído com sucesso",
    "notification.action.restored": "Restaurado com sucesso",
    "notification.action.unlocked": "Desbloqueado com sucesso",
    "notification.action.titleCompleted": "Concluído",
    "notification.action.titleError": "Erro",
    "notification.action.titleWarning": "Aviso",
    "notification.action.error":
        "Ocorreu um erro, por favor, verifique e tente novamente",
    "notification.action.cannotDelete.subject":
        "Você não pode excluir porque este tópico possui sub-tópicos ou notas! Por favor, exclua todos os sub-tópicos e notas para excluir este tópico.",
    "notification.action.confirm.exitScreen":
        "Por favor, confirme para sair desta tela.",
    "notification.action.confirm.delete": "Por favor, confirme para excluir.",
    "notification.action.confirm.unlock":
        "Por favor, confirme para desbloquear.",
    "notification.action.updatedSetting":
        "Configurações atualizadas com sucesso",
    "notification.action.requiredNoteContent":
        "Você não inseriu nenhum conteúdo.",
    "notification.action.requiredLabelName":
        "Você não inseriu o nome da etiqueta.",
    "notification.action.requiredSubjectName":
        "Você não inseriu o nome do tópico.",
    "notification.action.requiredSearchKeyWord":
        "Você não inseriu uma palavra-chave de pesquisa.",

    ///
    "tooltip.button.notesHome": "Notas",
    "tooltip.button.createNote": "Criar nota",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "Tópicos",
    "tooltip.button.createSubject": "Criar tópico",
    "tooltip.button.createSubSubject": "Criar subtema",
    "tooltip.button.labelsHome": "Etiquetas",
    "tooltip.button.createLabel": "Criar etiqueta",
    "tooltip.button.templatesHome": "Modelos",
    "tooltip.button.createTemplate": "Criar modelo",
    "tooltip.button.rootFolder": "Pasta raiz",
    "tooltip.button.": "",

    "tooltip.button.home": "Página inicial",
    "tooltip.button.save": "Salvar",
    "tooltip.button.update": "Atualizar",
    "tooltip.button.delete": "Excluir",
    "tooltip.button.deleteForever": "Excluir permanentemente",
    "tooltip.button.restore": "Restaurar",
    "tooltip.button.unlock": "Desbloquear",
    "tooltip.button.filter": "Filtro",
    "tooltip.button.reload": "Recarregar a página",
    "tooltip.button.search": "Pesquisar",
    "tooltip.button.calendar": "Calendário",
    "tooltip.button.parentSubject": "Tópico pai",
    "tooltip.button.subSubject": "Subtópico",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> spanishWords = {
    "screen.title.notes": "Notas",
    "screen.title.subjects": "Temas",
    "screen.title.subSubjects": "Subtemas",
    "screen.title.labels": "Etiquetas",
    "screen.title.templates": "Plantillas",
    "screen.title.advertisements": "Anuncios",
    "screen.title.settings": "Ajustes",
    "screen.title.settings.display": "Pantalla",
    "screen.title.settings.languages": "Idiomas",
    "screen.title.settings.backgroundMusic": "Música de fondo",
    "screen.title.settings.colorThemes": "Temas de color",
    "screen.title.selectedDate": "Fecha seleccionada",
    "screen.title.content": "Contenido",
    "screen.title.titleNotSet": "Título no establecido",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "Establecer el color de fondo para el título de la nota (el color de fondo del tema de la nota)",
    "screen.title.settings.setNoteContentExpanded":
        "El contenido de la nota ha sido expandido",
    "screen.title.settings.setTemplateContentExpanded":
        "El contenido de la plantilla de la nota ha sido expandido",
    "screen.title.settings.setSubjectActionsExpanded":
        "La lista de acciones para el Tema (modo de vista de lista) ha sido ampliada",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "Fijar el título de la nota al desplazarse por la lista de notas",
    "screen.title.settings.setBackgroundImage": "Establecer imagen de fondo",
    "screen.title.settings.opacityNumber": "Nivel de transparencia",
    "screen.title.viewImage": "Ver imagen",

    ///
    "screen.title.create": "Crear nuevo",
    "screen.title.update": "Actualizar",
    "screen.title.detail": "Detalles",

    "screen.title.create.note": "Crear nota",
    "screen.title.update.note": "Actualizar nota",
    "screen.title.detail.note": "Detalles de la nota",
    //
    "screen.title.create.subject": "Crear un tema",
    "screen.title.update.subject": "Actualizar tema",
    "screen.title.detail.subject": "Detalles del tema",
    //
    "screen.title.create.label": "Crear etiqueta",
    "screen.title.update.label": "Actualizar etiqueta",
    "screen.title.detail.label": "Detalles de la etiqueta",
    //
    "screen.title.create.template": "Crear plantilla",
    "screen.title.update.template": "Actualizar plantilla",
    "screen.title.detail.template": "Detalles de la plantilla",

    ///
    "button.title.all": "Todos",
    "button.title.open": "Abrir",
    "button.title.setting": "Ajustes",
    "button.title.shortcuts": "Accesos rápidos",
    "button.title.createShortcut": "Crear acceso directo",
    "button.title.update": "Actualizar",
    "button.title.delete": "Eliminar",
    "button.title.iGotIt": "Entiendo",
    "button.title.accept": "Aceptar",
    "button.title.cancel": "Cancelar",
    "button.title.close": "Cerrar",
    "button.title.createNote": "Crear una nota",
    "button.title.createNoteForSelectedDay":
        "Crear una nota para la fecha seleccionada",
    "button.title.selectLabel": "Seleccionar etiquetas",
    "button.title.selectSubject": "Seleccionar un tema",
    "button.title.selectPicture": "Seleccionar una imagen",
    "button.title.colorPalette": "Paleta de colores",

    ///
    "card.title.total": "Total",
    "card.title.youWroteAt": "Usted escribió a las",
    //
    "form.field.title.title": "Título",
    "form.field.title.content": "Contenido",
    "form.field.title.subject": "Tema",
    "form.field.title.parentSubject": "Tema padre",
    "form.field.title.label": "Etiquetas",
    "form.field.title.labelName": "Nombre de la etiqueta",
    "form.field.title.subjectName": "Nombre del tema",
    "form.field.title.color": "Color",
    "form.field.title.lock": "Bloquear nota",
    "form.field.title.avatar": "Foto de perfil",
    "form.field.title.images": "Imágenes",
    "form.filter.filter": "Filtrar",
    "form.filter.subject": "Tema",
    "form.filter.label": "Etiqueta",
    "form.filter.rootSubject": "Tema raíz",
    "form.filter.trash": "Papelera",
    "form.filter.favourite": "Favorito",
    "form.filter.recentlyUpdated": "Recientemente actualizado",
    "form.filter.dueDate": "Fecha de vencimiento",
    "form.filter.searchKeyword": "Palabra clave de búsqueda",
    "form.filter.creationTime": "Tiempo de creación",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "No seleccionar",
    "form.field.enterContentNote": "Ingrese el contenido de su nota",
    "form.field.enterTitleNote": "Ingrese el título de su nota",

    ///
    "notification.noItem.note": "¡No hay notas!",
    "notification.noItem.subject": "¡No hay temas!",
    "notification.noItem.label": "¡No hay etiquetas!",
    "notification.noItem.template": "¡No hay plantillas de notas!",
    "notification.action.created": "Creado exitosamente",
    "notification.action.updated": "Actualización exitosa",
    "notification.action.deleted": "Eliminación exitosa",
    "notification.action.restored": "Restauración exitosa",
    "notification.action.unlocked": "Desbloqueado exitosamente",
    "notification.action.titleCompleted": "Completado",
    "notification.action.titleError": "Error",
    "notification.action.titleWarning": "Advertencia",
    "notification.action.error":
        "Se ha producido un error, por favor, compruebe e inténtelo de nuevo",
    "notification.action.cannotDelete.subject":
        "¡No puedes eliminar porque este tema tiene subtemas o notas! Por favor, elimina todos los subtemas y notas para eliminar este tema.",
    "notification.action.confirm.exitScreen":
        "Por favor, confirme para salir de esta pantalla.",
    "notification.action.confirm.delete": "Por favor, confirme para eliminar.",
    "notification.action.confirm.unlock":
        "Por favor, confirme para desbloquear.",
    "notification.action.updatedSetting": "Ajustes actualizados correctamente",
    "notification.action.requiredNoteContent":
        "No has introducido ningún contenido.",
    "notification.action.requiredLabelName":
        "No has introducido el nombre de la etiqueta.",
    "notification.action.requiredSubjectName":
        "No has introducido el nombre del tema.",
    "notification.action.requiredSearchKeyWord":
        "No has ingresado una palabra clave de búsqueda.",

    ///
    "tooltip.button.notesHome": "Notas",
    "tooltip.button.createNote": "Crear nota",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "Temas",
    "tooltip.button.createSubject": "Crear tema",
    "tooltip.button.createSubSubject": "Crear subtema",
    "tooltip.button.labelsHome": "Etiquetas",
    "tooltip.button.createLabel": "Crear etiqueta",
    "tooltip.button.templatesHome": "Plantillas",
    "tooltip.button.createTemplate": "Crear plantilla",
    "tooltip.button.rootFolder": "Carpeta raíz",
    "tooltip.button.": "",

    "tooltip.button.home": "Página principal",
    "tooltip.button.save": "Guardar",
    "tooltip.button.update": "Actualizar",
    "tooltip.button.delete": "Borrar",
    "tooltip.button.deleteForever": "Borrar permanentemente",
    "tooltip.button.restore": "Restaurar",
    "tooltip.button.unlock": "Desbloquear",
    "tooltip.button.filter": "Filtro",
    "tooltip.button.reload": "Actualizar página",
    "tooltip.button.search": "Buscar",
    "tooltip.button.calendar": "Calendario",
    "tooltip.button.parentSubject": "Tema padre",
    "tooltip.button.subSubject": "Subtema",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> chineseWords = {
    "screen.title.notes": "笔记",
    "screen.title.subjects": "主题",
    "screen.title.subSubjects": "子主题",
    "screen.title.labels": "标签",
    "screen.title.templates": "模板",
    "screen.title.advertisements": "广告",
    "screen.title.settings": "设置",
    "screen.title.settings.display": "显示",
    "screen.title.settings.languages": "语言",
    "screen.title.settings.backgroundMusic": "背景音乐",
    "screen.title.settings.colorThemes": "颜色主题",
    "screen.title.selectedDate": "已选择日期",
    "screen.title.content": "内容",
    "screen.title.titleNotSet": "标题未设置",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "设置便签标题的背景色（便签主题的背景色）",
    "screen.title.settings.setNoteContentExpanded": "笔记的内容已经扩展了",
    "screen.title.settings.setTemplateContentExpanded": "笔记模板的内容已经扩展了",
    "screen.title.settings.setSubjectActionsExpanded": "主题的操作列表（列表视图模式）已经扩展了",
    "screen.title.settings.setStickTitleOfNoteWhenScroll": "滚动笔记列表时固定笔记标题",
    "screen.title.settings.setBackgroundImage": "设置背景图片",
    "screen.title.settings.opacityNumber": "透明度水平",
    "screen.title.viewImage": "查看图片",

    ///
    "screen.title.create": "创建新的",
    "screen.title.update": "更新",
    "screen.title.detail": "详细信息",

    "screen.title.create.note": "创建笔记",
    "screen.title.update.note": "更新笔记",
    "screen.title.detail.note": "笔记详情",
    //
    "screen.title.create.subject": "创建主题",
    "screen.title.update.subject": "更新主题",
    "screen.title.detail.subject": "主题细节",
    //
    "screen.title.create.label": "创建标签",
    "screen.title.update.label": "更新标签",
    "screen.title.detail.label": "标签详情",
    //
    "screen.title.create.template": "创建模板",
    "screen.title.update.template": "更新模板",
    "screen.title.detail.template": "模板详情",

    ///
    "button.title.all": "全部",
    "button.title.open": "打开",
    "button.title.setting": "设置",
    "button.title.shortcuts": "快速访问",
    "button.title.createShortcut": "创建快捷方式",
    "button.title.update": "更新",
    "button.title.delete": "删除",
    "button.title.iGotIt": "我明白了",
    "button.title.accept": "接受",
    "button.title.cancel": "取消",
    "button.title.close": "关闭",
    "button.title.createNote": "创建备忘录",
    "button.title.createNoteForSelectedDay": "为选定日期创建备忘录",
    "button.title.selectLabel": "选择标签",
    "button.title.selectSubject": "选择一个主题",
    "button.title.selectPicture": "选择一张图片",
    "button.title.colorPalette": "调色板",

    ///
    "card.title.total": "总数",
    "card.title.youWroteAt": "您在以下时间写下",
    //
    "form.field.title.title": "标题",
    "form.field.title.content": "内容",
    "form.field.title.subject": "主题",
    "form.field.title.parentSubject": "父主题",
    "form.field.title.label": "标签",
    "form.field.title.labelName": "标签名称",
    "form.field.title.subjectName": "主题名称",
    "form.field.title.color": "颜色",
    "form.field.title.lock": "锁定笔记",
    "form.field.title.avatar": "头像",
    "form.field.title.images": "图片",
    "form.filter.filter": "过滤",
    "form.filter.subject": "主题",
    "form.filter.label": "标签",
    "form.filter.rootSubject": "根主题",
    "form.filter.trash": "垃圾桶",
    "form.filter.favourite": "收藏",
    "form.filter.recentlyUpdated": "最近更新",
    "form.filter.dueDate": "到期日",
    "form.filter.searchKeyword": "搜索关键词",
    "form.filter.creationTime": "创建时间",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "不选择",
    "form.field.enterContentNote": "输入您的笔记内容。",
    "form.field.enterTitleNote": "输入您的笔记标题。",

    ///
    "notification.noItem.note": "没有笔记！",
    "notification.noItem.subject": "没有主题！",
    "notification.noItem.label": "没有标签！",
    "notification.noItem.template": "没有任何笔记模板！",
    "notification.action.created": "创建成功",
    "notification.action.updated": "成功更新",
    "notification.action.deleted": "成功删除",
    "notification.action.restored": "成功恢复",
    "notification.action.unlocked": "成功解锁",
    "notification.action.titleCompleted": "完成",
    "notification.action.titleError": "错误",
    "notification.action.titleWarning": "警告",
    "notification.action.error": "发生错误，请检查并重试",
    "notification.action.cannotDelete.subject":
        "您不能删除，因为此主题具有子主题或笔记！ 请删除所有子主题和笔记以删除此主题。",
    "notification.action.confirm.exitScreen": "请确认退出此屏幕。",
    "notification.action.confirm.delete": "请确认删除。",
    "notification.action.confirm.unlock": "请确认以解锁。",
    "notification.action.updatedSetting": "设置更新成功",
    "notification.action.requiredNoteContent": "您还没有输入任何内容。",
    "notification.action.requiredLabelName": "您还没有输入标签名称。",
    "notification.action.requiredSubjectName": "您还没有输入主题名称。",
    "notification.action.requiredSearchKeyWord": "您还没有输入搜索关键字。",

    ///
    "tooltip.button.notesHome": "笔记",
    "tooltip.button.createNote": "创建笔记",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "主题",
    "tooltip.button.createSubject": "创建主题",
    "tooltip.button.createSubSubject": "创建子主题",
    "tooltip.button.labelsHome": "标签",
    "tooltip.button.createLabel": "创建标签",
    "tooltip.button.templatesHome": "模板",
    "tooltip.button.createTemplate": "创建模板",
    "tooltip.button.rootFolder": "根目录",
    "tooltip.button.": "",

    "tooltip.button.home": "主页",
    "tooltip.button.save": "保存",
    "tooltip.button.update": "更新",
    "tooltip.button.delete": "删除",
    "tooltip.button.deleteForever": "永久删除",
    "tooltip.button.restore": "恢复",
    "tooltip.button.unlock": "解锁",
    "tooltip.button.filter": "过滤器",
    "tooltip.button.reload": "刷新页面",
    "tooltip.button.search": "搜索",
    "tooltip.button.calendar": "日历",
    "tooltip.button.parentSubject": "父母主题",
    "tooltip.button.subSubject": "子主题",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> japaneseWords = {
    "screen.title.notes": "ノート",
    "screen.title.subjects": "トピックス",
    "screen.title.subSubjects": "サブトピックス",
    "screen.title.labels": "ラベル",
    "screen.title.templates": "テンプレート",
    "screen.title.advertisements": "広告",
    "screen.title.settings": "設定",
    "screen.title.settings.display": "表示",
    "screen.title.settings.languages": "言語",
    "screen.title.settings.backgroundMusic": "バックグラウンドミュージック",
    "screen.title.settings.colorThemes": "カラーテーマ",
    "screen.title.selectedDate": "選択した日付",
    "screen.title.content": "コンテンツ",
    "screen.title.titleNotSet": "タイトルが設定されていません",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "メモのタイトルの背景色を設定する（メモのトピックの背景色）",
    "screen.title.settings.setNoteContentExpanded": "ノートの内容が拡張されました",
    "screen.title.settings.setTemplateContentExpanded": "ノートのテンプレートの内容が拡張されました",
    "screen.title.settings.setSubjectActionsExpanded":
        "トピックのアクションリスト（リストビューモード）が拡張されました",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "ノートリストをスクロールするときにノートのタイトルを固定する",
    "screen.title.settings.setBackgroundImage": "背景画像を設定する",
    "screen.title.settings.opacityNumber": "透明度レベル",
    "screen.title.viewImage": "画像を見る",

    ///
    "screen.title.create": "新規作成",
    "screen.title.update": "更新",
    "screen.title.detail": "詳細",

    "screen.title.create.note": "ノートを作成する",
    "screen.title.update.note": "ノートを更新する",
    "screen.title.detail.note": "メモの詳細",
    //
    "screen.title.create.subject": "トピックを作成する",
    "screen.title.update.subject": "トピックを更新する",
    "screen.title.detail.subject": "トピックの詳細",
    //
    "screen.title.create.label": "ラベルを作成する",
    "screen.title.update.label": "ラベルを更新する",
    "screen.title.detail.label": "ラベルの詳細",
    //
    "screen.title.create.template": "テンプレートを作成する",
    "screen.title.update.template": "テンプレートを更新する",
    "screen.title.detail.template": "テンプレートの詳細",

    ///
    "button.title.all": "すべて",
    "button.title.open": "開く",
    "button.title.setting": "設定",
    "button.title.shortcuts": "クイックアクセス",
    "button.title.createShortcut": "ショートカットを作成する",
    "button.title.update": "更新する",
    "button.title.delete": "削除する",
    "button.title.iGotIt": "私は理解しました",
    "button.title.accept": "受け入れる",
    "button.title.cancel": "キャンセルする",
    "button.title.close": "閉じる",
    "button.title.createNote": "メモを作成する",
    "button.title.createNoteForSelectedDay": "選択した日付にメモを作成する",
    "button.title.selectLabel": "ラベルを選択する",
    "button.title.selectSubject": "トピックを選択する",
    "button.title.selectPicture": "画像を選択する",
    "button.title.colorPalette": "カラーパレット",

    ///
    "card.title.total": "合計",
    "card.title.youWroteAt": "あなたが書いたのは",
    //
    "form.field.title.title": "タイトル",
    "form.field.title.content": "コンテンツ",
    "form.field.title.subject": "トピック",
    "form.field.title.parentSubject": "親トピック",
    "form.field.title.label": "ラベル",
    "form.field.title.labelName": "ラベル名",
    "form.field.title.subjectName": "トピック名",
    "form.field.title.color": "色",
    "form.field.title.lock": "メモをロックする",
    "form.field.title.avatar": "プロフィール画像",
    "form.field.title.images": "画像",
    "form.filter.filter": "フィルターする",
    "form.filter.subject": "トピック",
    "form.filter.label": "ラベル",
    "form.filter.rootSubject": "ルートトピック",
    "form.filter.trash": "ごみ箱",
    "form.filter.favourite": "お気に入り",
    "form.filter.recentlyUpdated": "最近更新された",
    "form.filter.dueDate": "期日",
    "form.filter.searchKeyword": "検索キーワード",
    "form.filter.creationTime": "作成時間",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "選択しない",
    "form.field.enterContentNote": "ノートの内容を入力してください。",
    "form.field.enterTitleNote": "ノートのタイトルを入力してください。",

    ///
    "notification.noItem.note": "ノートは見つかりません！",
    "notification.noItem.subject": "トピックは見つかりません！",
    "notification.noItem.label": "ラベルは見つかりません！",
    "notification.noItem.template": "ノートのテンプレートが見つかりません！",
    "notification.action.created": "作成に成功しました",
    "notification.action.updated": "更新に成功しました",
    "notification.action.deleted": "削除が成功しました",
    "notification.action.restored": "復元が成功しました",
    "notification.action.unlocked": "ロックが成功裏に解除されました",
    "notification.action.titleCompleted": "完了しました",
    "notification.action.titleError": "エラー",
    "notification.action.titleWarning": "警告",
    "notification.action.error": "エラーが発生しました、確認して再度実行してください",
    "notification.action.cannotDelete.subject":
        "このトピックにはサブトピックやノートがあるため、削除できません！ このトピックを削除するには、すべてのサブトピックとノートを削除してください。",
    "notification.action.confirm.exitScreen": "この画面を終了するには確認してください。",
    "notification.action.confirm.delete": "削除するには確認してください。",
    "notification.action.confirm.unlock": "ロックを解除するには確認してください。",
    "notification.action.updatedSetting": "設定が更新されました",
    "notification.action.requiredNoteContent": "コンテンツが入力されていません。",
    "notification.action.requiredLabelName": "ラベル名が入力されていません。",
    "notification.action.requiredSubjectName": "トピック名が入力されていません。",
    "notification.action.requiredSearchKeyWord": "検索キーワードを入力していません。",

    ///
    "tooltip.button.notesHome": "ノート",
    "tooltip.button.createNote": "メモを作成する",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "トピックス",
    "tooltip.button.createSubject": "トピックを作成する",
    "tooltip.button.createSubSubject": "サブトピックを作成する",
    "tooltip.button.labelsHome": "ラベル",
    "tooltip.button.createLabel": "ラベルを作成する",
    "tooltip.button.templatesHome": "テンプレート",
    "tooltip.button.createTemplate": "テンプレートを作成する",
    "tooltip.button.rootFolder": "ルートフォルダ",
    "tooltip.button.": "",

    "tooltip.button.home": "ホームページ",
    "tooltip.button.save": "保存する",
    "tooltip.button.update": "更新",
    "tooltip.button.delete": "削除する",
    "tooltip.button.deleteForever": "永久削除する",
    "tooltip.button.restore": "復元する",
    "tooltip.button.unlock": "アンロック",
    "tooltip.button.filter": "フィルター",
    "tooltip.button.reload": "ページを更新する",
    "tooltip.button.search": "検索する",
    "tooltip.button.calendar": "カレンダー",
    "tooltip.button.parentSubject": "親トピック",
    "tooltip.button.subSubject": "サブトピック",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> indonesianWords = {
    "screen.title.notes": "Catatan",
    "screen.title.subjects": "Topik",
    "screen.title.subSubjects": "Subtopik",
    "screen.title.labels": "Label",
    "screen.title.templates": "Templat",
    "screen.title.advertisements": "Iklan",
    "screen.title.settings": "Pengaturan",
    "screen.title.settings.display": "Tampilan",
    "screen.title.settings.languages": "Bahasa",
    "screen.title.settings.backgroundMusic": "Musik latar belakang",
    "screen.title.settings.colorThemes": "Tema warna",
    "screen.title.selectedDate": "Tanggal yang dipilih",
    "screen.title.content": "Konten",
    "screen.title.titleNotSet": "Judul belum ditetapkan",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "Atur warna latar belakang untuk judul catatan (warna latar belakang topik catatan)",
    "screen.title.settings.setNoteContentExpanded":
        "Konten catatan telah diperluas",
    "screen.title.settings.setTemplateContentExpanded":
        "Konten templat catatan telah diperluas",
    "screen.title.settings.setSubjectActionsExpanded":
        "Daftar tindakan untuk Topik (mode tampilan daftar) telah diperluas",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "Tetapkan judul catatan saat menggulir daftar catatan",
    "screen.title.settings.setBackgroundImage": "Atur gambar latar belakang",
    "screen.title.settings.opacityNumber": "Tingkat transparansi",
    "screen.title.viewImage": "Lihat gambar",

    ///
    "screen.title.create": "Buat baru",
    "screen.title.update": "Perbarui",
    "screen.title.detail": "Detail",

    "screen.title.create.note": "Buat catatan",
    "screen.title.update.note": "Perbarui catatan",
    "screen.title.detail.note": "Detail catatan",
    //
    "screen.title.create.subject": "Buat topik",
    "screen.title.update.subject": "Perbarui topik",
    "screen.title.detail.subject": "Detail Topik",
    //
    "screen.title.create.label": "Membuat label",
    "screen.title.update.label": "Memperbarui label",
    "screen.title.detail.label": "Detail label",
    //
    "screen.title.create.template": "Membuat templat",
    "screen.title.update.template": "Memperbarui templat",
    "screen.title.detail.template": "Detail templat",

    ///
    "button.title.all": "Semua",
    "button.title.open": "Membuka",
    "button.title.setting": "Pengaturan",
    "button.title.shortcuts": "Akses cepat",
    "button.title.createShortcut": "Membuat pintasan",
    "button.title.update": "Memperbarui",
    "button.title.delete": "Menghapus",
    "button.title.iGotIt": "Saya mengerti",
    "button.title.accept": "Menerima",
    "button.title.cancel": "Membatalkan",
    "button.title.close": "Tutup",
    "button.title.createNote": "Buat catatan",
    "button.title.createNoteForSelectedDay":
        "Buat catatan untuk tanggal yang dipilih",
    "button.title.selectLabel": "Pilih label",
    "button.title.selectSubject": "Pilih sebuah topik",
    "button.title.selectPicture": "Pilih gambar",
    "button.title.colorPalette": "Palet warna",

    ///
    "card.title.total": "Total",
    "card.title.youWroteAt": "Anda menulis pada pukul",
    //
    "form.field.title.title": "Judul",
    "form.field.title.content": "Isi",
    "form.field.title.subject": "Topik",
    "form.field.title.parentSubject": "Topik induk",
    "form.field.title.label": "Label",
    "form.field.title.labelName": "Nama label",
    "form.field.title.subjectName": "Nama topik",
    "form.field.title.color": "Warna",
    "form.field.title.lock": "Kunci catatan",
    "form.field.title.avatar": "Foto profil",
    "form.field.title.images": "Gambar",
    "form.filter.filter": "Menyaring",
    "form.filter.subject": "Topik",
    "form.filter.label": "Label",
    "form.filter.rootSubject": "Tema akar",
    "form.filter.trash": "Tempat sampah",
    "form.filter.favourite": "Favorit",
    "form.filter.recentlyUpdated": "Baru saja diperbarui",
    "form.filter.dueDate": "Tanggal jatuh tempo",
    "form.filter.searchKeyword": "Kata kunci pencarian",
    "form.filter.creationTime": "Waktu pembuatan",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "Tidak memilih",
    "form.field.enterContentNote": "Masukkan konten catatan Anda",
    "form.field.enterTitleNote": "Masukkan judul catatan Anda",

    ///
    "notification.noItem.note": "Tidak ada catatan!",
    "notification.noItem.subject": "Tidak ada topik!",
    "notification.noItem.label": "Tidak ada label!",
    "notification.noItem.template": "Tidak ada template catatan!",
    "notification.action.created": "Berhasil dibuat",
    "notification.action.updated": "Berhasil diperbarui",
    "notification.action.deleted": "Berhasil dihapus",
    "notification.action.restored": "Berhasil dipulihkan",
    "notification.action.unlocked": "Berhasil membuka kunci",
    "notification.action.titleCompleted": "Selesai",
    "notification.action.titleError": "Kesalahan",
    "notification.action.titleWarning": "Peringatan",
    "notification.action.error":
        "Terjadi kesalahan, harap periksa dan coba lagi",
    "notification.action.cannotDelete.subject":
        "Anda tidak dapat menghapus karena topik ini memiliki subtopik atau catatan! Harap hapus semua subtopik dan catatan untuk menghapus topik ini.",
    "notification.action.confirm.exitScreen":
        "Mohon konfirmasi untuk keluar dari layar ini.",
    "notification.action.confirm.delete": "Mohon konfirmasi untuk menghapus.",
    "notification.action.confirm.unlock":
        "Mohon konfirmasi untuk membuka kunci.",
    "notification.action.updatedSetting": "Pengaturan berhasil diperbarui",
    "notification.action.requiredNoteContent": "Anda belum memasukkan konten.",
    "notification.action.requiredLabelName":
        "Anda belum memasukkan nama label.",
    "notification.action.requiredSubjectName":
        "Anda belum memasukkan nama topik.",
    "notification.action.requiredSearchKeyWord":
        "Anda belum memasukkan kata kunci pencarian.",

    ///
    "tooltip.button.notesHome": "Catatan",
    "tooltip.button.createNote": "Buat catatan",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "Topik",
    "tooltip.button.createSubject": "Buat topik",
    "tooltip.button.createSubSubject": "Buat subtopik",
    "tooltip.button.labelsHome": "Label",
    "tooltip.button.createLabel": "Buat label",
    "tooltip.button.templatesHome": "Templat",
    "tooltip.button.createTemplate": "Membuat template",
    "tooltip.button.rootFolder": "Folder akar",
    "tooltip.button.": "",

    "tooltip.button.home": "Halaman utama",
    "tooltip.button.save": "Simpan",
    "tooltip.button.update": "Perbarui",
    "tooltip.button.delete": "Hapus",
    "tooltip.button.deleteForever": "Menghapus secara permanen",
    "tooltip.button.restore": "Mengembalikan",
    "tooltip.button.unlock": "Membuka kunci",
    "tooltip.button.filter": "Filter",
    "tooltip.button.reload": "Segarkan halaman",
    "tooltip.button.search": "Cari",
    "tooltip.button.calendar": "Kalender",
    "tooltip.button.parentSubject": "Topik induk",
    "tooltip.button.subSubject": "Subtopik",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> frenchWords = {
    "screen.title.notes": "Notes",
    "screen.title.subjects": "Thèmes",
    "screen.title.subSubjects": "Sous-thèmes",
    "screen.title.labels": "Étiquettes",
    "screen.title.templates": "Modèles",
    "screen.title.advertisements": "Publicités",
    "screen.title.settings": "Paramètres",
    "screen.title.settings.display": "Affichage",
    "screen.title.settings.languages": "Langues",
    "screen.title.settings.backgroundMusic": "Musique de fond",
    "screen.title.settings.colorThemes": "Thèmes de couleur",
    "screen.title.selectedDate": "Date sélectionnée",
    "screen.title.content": "Contenu",
    "screen.title.titleNotSet": "Titre non défini",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "Définir la couleur de fond pour le titre de la note (la couleur de fond du sujet de la note)",
    "screen.title.settings.setNoteContentExpanded":
        "Le contenu de la note a été étendu",
    "screen.title.settings.setTemplateContentExpanded":
        "Le contenu du modèle de note a été étendu",
    "screen.title.settings.setSubjectActionsExpanded":
        "La liste des actions pour le sujet (mode liste) a été élargie",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "Fixer le titre de la note lors du défilement de la liste des notes",
    "screen.title.settings.setBackgroundImage": "Définir l'image de fond",
    "screen.title.settings.opacityNumber": "Niveau de transparence",
    "screen.title.viewImage": "Voir l'image",

    ///
    "screen.title.create": "Créer un nouveau",
    "screen.title.update": "Mettre à jour",
    "screen.title.detail": "Détails",

    "screen.title.create.note": "Créer une note",
    "screen.title.update.note": "Mettre à jour la note",
    "screen.title.detail.note": "Détails de la note",
    //
    "screen.title.create.subject": "Créer un sujet",
    "screen.title.update.subject": "Mettre à jour le sujet",
    "screen.title.detail.subject": "Détails du sujet",
    //
    "screen.title.create.label": "Créer une étiquette",
    "screen.title.update.label": "Mettre à jour l'étiquette",
    "screen.title.detail.label": "Détails de l'étiquette",
    //
    "screen.title.create.template": "Créer un modèle",
    "screen.title.update.template": "Mettre à jour le modèle",
    "screen.title.detail.template": "Détails du modèle",

    ///
    "button.title.all": "Tous",
    "button.title.open": "Ouvrir",
    "button.title.setting": "Paramètres",
    "button.title.shortcuts": "Accès rapides",
    "button.title.createShortcut": "Créer un raccourci",
    "button.title.update": "Mettre à jour",
    "button.title.delete": "Supprimer",
    "button.title.iGotIt": "J'ai compris",
    "button.title.accept": "Accepter",
    "button.title.cancel": "Annuler",
    "button.title.close": "Fermer",
    "button.title.createNote": "Créer une note",
    "button.title.createNoteForSelectedDay":
        "Créer une note pour la date sélectionnée",
    "button.title.selectLabel": "Sélectionner des étiquettes",
    "button.title.selectSubject": "Sélectionner un sujet",
    "button.title.selectPicture": "Sélectionner une image",
    "button.title.colorPalette": "Palette de couleurs",

    ///
    "form.field.title.title": "Titre",
    "form.field.title.content": "Contenu",
    "form.field.title.subject": "Sujet",
    "form.field.title.parentSubject": "Sujet parent",
    "form.field.title.label": "Étiquettes",
    "form.field.title.labelName": "Nom de l'étiquette",
    "form.field.title.subjectName": "Nom du sujet",
    "form.field.title.color": "Couleur",
    "form.field.title.lock": "Verrouiller la note",
    "form.field.title.avatar": "Photo de profil",
    "form.field.title.images": "Images",
    "form.filter.filter": "Filtrer",
    "form.filter.subject": "Sujet",
    "form.filter.label": "Étiquette",
    "form.filter.rootSubject": "Sujet principal",
    "form.filter.trash": "Poubelle",
    "form.filter.favourite": "Favori",
    "form.filter.recentlyUpdated": "Récemment mis à jour",
    "form.filter.dueDate": "Date d'échéance",
    "form.filter.searchKeyword": "Mot-clé de recherche",
    "form.filter.creationTime": "Heure de création",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "Ne pas sélectionner",
    "form.field.enterContentNote": "Entrez le contenu de votre note",
    "form.field.enterTitleNote": "Entrez le titre de votre note",
    //
    "card.title.total": "Total",
    "card.title.youWroteAt": "Vous avez écrit à",

    ///
    "notification.noItem.note": "Aucune note trouvée!",
    "notification.noItem.subject": "Aucun sujet trouvé!",
    "notification.noItem.label": "Aucune étiquette trouvée!",
    "notification.noItem.template": "Aucun modèle de notes trouvé !",
    "notification.action.created": "Créé avec succès",
    "notification.action.updated": "Mise à jour réussie",
    "notification.action.deleted": "Suppression réussie",
    "notification.action.restored": "Restauration réussie",
    "notification.action.unlocked": "Déverrouillé avec succès",
    "notification.action.titleCompleted": "Terminé",
    "notification.action.titleError": "Erreur",
    "notification.action.titleWarning": "Avertissement",
    "notification.action.error":
        "Une erreur s'est produite, veuillez vérifier et réessayer",
    "notification.action.cannotDelete.subject":
        "Vous ne pouvez pas supprimer car ce sujet contient des sous-sujets ou des notes ! Veuillez supprimer tous les sous-sujets et les notes pour supprimer ce sujet.",
    "notification.action.confirm.exitScreen":
        "Veuillez confirmer pour quitter cet écran.",
    "notification.action.confirm.delete": "Veuillez confirmer pour supprimer.",
    "notification.action.confirm.unlock":
        "Veuillez confirmer pour déverrouiller.",
    "notification.action.updatedSetting": "Paramètres mis à jour avec succès",
    "notification.action.requiredNoteContent":
        "Vous n'avez saisi aucun contenu.",
    "notification.action.requiredLabelName":
        "Vous n'avez pas saisi le nom de l'étiquette.",
    "notification.action.requiredSubjectName":
        "Vous n'avez pas saisi le nom du sujet.",
    "notification.action.requiredSearchKeyWord":
        "Vous n'avez pas saisi de mot-clé de recherche.",

    ///
    "tooltip.button.notesHome": "Notes",
    "tooltip.button.createNote": "Créer une note",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "Thèmes",
    "tooltip.button.createSubject": "Créer un sujet",
    "tooltip.button.createSubSubject": "Créer un sous-thème",
    "tooltip.button.labelsHome": "Étiquettes",
    "tooltip.button.createLabel": "Créer une étiquette",
    "tooltip.button.templatesHome": "Modèles",
    "tooltip.button.createTemplate": "Créer un modèle",
    "tooltip.button.rootFolder": "Dossier racine",
    "tooltip.button.": "Calendrier",

    "tooltip.button.home": "Page d'accueil",
    "tooltip.button.save": "Sauvegarder",
    "tooltip.button.update": "Mettre à jour",
    "tooltip.button.delete": "Supprimer",
    "tooltip.button.deleteForever": "Supprimer définitivement",
    "tooltip.button.restore": "Restaurer",
    "tooltip.button.unlock": "Déverrouiller",
    "tooltip.button.filter": "Filtre",
    "tooltip.button.reload": "Rafraîchir la page",
    "tooltip.button.search": "Rechercher",
    "tooltip.button.calendar": "Calendrier",
    "tooltip.button.parentSubject": "Sujet parent",
    "tooltip.button.subSubject": "Sous-thème",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  static Map<String, String> koreanWords = {
    "screen.title.notes": "메모",
    "screen.title.subjects": "주제",
    "screen.title.subSubjects": "하위 주제",
    "screen.title.labels": "라벨",
    "screen.title.templates": "템플릿",
    "screen.title.advertisements": "광고",
    "screen.title.settings": "설정",
    "screen.title.settings.display": "디스플레이",
    "screen.title.settings.languages": "언어들",
    "screen.title.settings.backgroundMusic": "배경 음악",
    "screen.title.settings.colorThemes": "색상 테마",
    "screen.title.selectedDate": "선택한 날짜",
    "screen.title.content": "콘텐츠",
    "screen.title.titleNotSet": "제목이 설정되지 않았습니다",
    "screen.title.settings.setBackgroundColorIsSubjectColor":
        "노트 제목의 배경색을 설정하세요 (노트의 주제 배경색)",
    "screen.title.settings.setNoteContentExpanded": "노트의 내용이 확장되었습니다",
    "screen.title.settings.setTemplateContentExpanded": "노트 템플릿의 내용이 확장되었습니다",
    "screen.title.settings.setSubjectActionsExpanded":
        "주제의 작업 목록 (목록 보기 모드)이 확장되었습니다",
    "screen.title.settings.setStickTitleOfNoteWhenScroll":
        "노트 목록을 스크롤할 때 노트 제목을 고정합니다",
    "screen.title.settings.setBackgroundImage": "배경 이미지 설정",
    "screen.title.settings.opacityNumber": "투명도 수준",
    "screen.title.viewImage": "이미지 보기",

    ///
    "screen.title.create": "새로 만들기",
    "screen.title.update": "업데이트",
    "screen.title.detail": "세부 사항",

    "screen.title.create.note": "메모 만들기",
    "screen.title.update.note": "메모 업데이트",
    "screen.title.detail.note": "메모 세부 정보",
    //
    "screen.title.create.subject": "주제 만들기",
    "screen.title.update.subject": "주제 업데이트하기",
    "screen.title.detail.subject": "주제 세부사항",
    //
    "screen.title.create.label": "라벨 만들기",
    "screen.title.update.label": "라벨 업데이트하기",
    "screen.title.detail.label": "라벨 세부정보",
    //
    "screen.title.create.template": "템플릿 만들기",
    "screen.title.update.template": "템플릿 업데이트하기",
    "screen.title.detail.template": "템플릿 세부정보",

    ///
    "button.title.all": "모두",
    "button.title.open": "열다",
    "button.title.setting": "설정",
    "button.title.shortcuts": "빠른 접근",
    "button.title.createShortcut": "바로 가기 만들기",
    "button.title.update": "업데이트",
    "button.title.delete": "삭제",
    "button.title.iGotIt": "이해했습니다",
    "button.title.accept": "수락하다",
    "button.title.cancel": "취소",
    "button.title.close": "닫기",
    "button.title.createNote": "메모 작성하기",
    "button.title.createNoteForSelectedDay": "선택한 날짜에 메모 작성하기",
    "button.title.selectLabel": "레이블 선택하기",
    "button.title.selectSubject": "주제를 선택하세요",
    "button.title.selectPicture": "이미지 선택",
    "button.title.colorPalette": "색 팔레트",

    ///
    "card.title.total": "총액",
    "card.title.youWroteAt": "당신은 다음 시간에 썼습니다",
    //
    "form.field.title.title": "제목",
    "form.field.title.content": "내용",
    "form.field.title.subject": "주제",
    "form.field.title.parentSubject": "상위 주제",
    "form.field.title.label": "라벨",
    "form.field.title.labelName": "라벨 이름",
    "form.field.title.subjectName": "주제 이름",
    "form.field.title.color": "색깔",
    "form.field.title.lock": "노트 잠금",
    "form.field.title.avatar": "프로필 사진",
    "form.field.title.images": "이미지들",
    "form.filter.filter": "필터링하다",
    "form.filter.subject": "주제",
    "form.filter.label": "레이블",
    "form.filter.rootSubject": "루트 주제",
    "form.filter.trash": "휴지통",
    "form.filter.favourite": "좋아요",
    "form.filter.recentlyUpdated": "최근 업데이트됨",
    "form.filter.dueDate": "만료일",
    "form.filter.searchKeyword": "검색 키워드",
    "form.filter.creationTime": "생성 시간",
    "form.filter.from": "From",
    "form.filter.to": "To",
    "form.field.dropdown.notSelect": "선택하지 않음",
    "form.field.enterContentNote": "노트 내용을 입력하세요",
    "form.field.enterTitleNote": "노트 제목을 입력하세요",

    ///
    "notification.noItem.note": "노트가 없습니다!",
    "notification.noItem.subject": "주제가 없습니다!",
    "notification.noItem.label": "라벨이 없습니다!",
    "notification.noItem.template": "노트 템플릿이 없습니다!",
    "notification.action.created": "성공적으로 생성됨",
    "notification.action.updated": "성공적으로 업데이트됨",
    "notification.action.deleted": "성공적으로 삭제됨",
    "notification.action.restored": "성공적으로 복원됨",
    "notification.action.unlocked": "성공적으로 잠금 해제됨",
    "notification.action.titleCompleted": "완료",
    "notification.action.titleError": "오류",
    "notification.action.titleWarning": "경고",
    "notification.action.error": "오류가 발생했습니다. 확인 후 다시 시도하세요",
    "notification.action.cannotDelete.subject":
        "이 주제에는 하위 주제 또는 노트가 있기 때문에 삭제할 수 없습니다! 이 주제를 삭제하려면 모든 하위 주제와 노트를 삭제하십시오.",
    "notification.action.confirm.exitScreen": "이 화면을 나가시려면 확인하세요.",
    "notification.action.confirm.delete": "삭제하려면 확인하세요.",
    "notification.action.confirm.unlock": "잠금 해제하려면 확인하세요.",
    "notification.action.updatedSetting": "설정이 성공적으로 업데이트되었습니다",
    "notification.action.requiredNoteContent": "내용을 입력하지 않았습니다.",
    "notification.action.requiredLabelName": "라벨 이름을 입력하지 않았습니다.",
    "notification.action.requiredSubjectName": "주제 이름을 입력하지 않았습니다.",
    "notification.action.requiredSearchKeyWord": "검색 키워드를 입력하지 않았습니다.",

    ///
    "tooltip.button.notesHome": "메모",
    "tooltip.button.createNote": "메모 만들기",
    "tooltip.button.createNoteForSelectedDay": "",
    "tooltip.button.subjectsHome": "주제",
    "tooltip.button.createSubject": "주제 만들기",
    "tooltip.button.createSubSubject": "하위 주제 생성",
    "tooltip.button.labelsHome": "라벨",
    "tooltip.button.createLabel": "라벨 만들기",
    "tooltip.button.templatesHome": "템플릿",
    "tooltip.button.createTemplate": "템플릿 만들기",
    "tooltip.button.rootFolder": "루트 폴더",
    "tooltip.button.": "",

    "tooltip.button.home": "홈페이지",
    "tooltip.button.save": "저장",
    "tooltip.button.update": "업데이트",
    "tooltip.button.delete": "삭제",
    "tooltip.button.deleteForever": "영구 삭제",
    "tooltip.button.restore": "복원하다",
    "tooltip.button.unlock": "터놓다",
    "tooltip.button.filter": "필터",
    "tooltip.button.reload": "페이지 새로 고침",
    "tooltip.button.search": "검색하다",
    "tooltip.button.calendar": "달력",
    "tooltip.button.parentSubject": "부모 주제",
    "tooltip.button.subSubject": "하위 주제",
    "tooltip.button.createdTime": "",
    "tooltip.button.updatedTime": "",
    "tooltip.button.deletedTime": "",
  };

  /*
  CommonLanguages.convert(lang: , word: )
   */
  static String convert({required String lang, required String word}) {
    String convertedWord = '';

    switch (lang) {
      case 'English':
        {
          convertedWord = englishWords[word] ?? '';
          break;
        }
      case 'Russian':
        {
          convertedWord = russianWords[word] ?? '';
          break;
        }
      case 'Vietnamese':
        {
          convertedWord = vietnameseWords[word] ?? '';
          break;
        }
      case 'Portuguese':
        {
          convertedWord = portugueseWords[word] ?? '';
          break;
        }
      case 'Spanish':
        {
          convertedWord = spanishWords[word] ?? '';
          break;
        }
      case 'Chinese':
        {
          convertedWord = chineseWords[word] ?? '';
          break;
        }
      case 'Japanese':
        {
          convertedWord = japaneseWords[word] ?? '';
          break;
        }
      case 'Indonesian':
        {
          convertedWord = indonesianWords[word] ?? '';
          break;
        }
      case 'French':
        {
          convertedWord = frenchWords[word] ?? '';
          break;
        }
      case 'Korean':
        {
          convertedWord = koreanWords[word] ?? '';
          break;
        }
    }

    return convertedWord;
  }
}
