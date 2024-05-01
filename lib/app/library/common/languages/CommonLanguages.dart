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
    "screen.title.labels": "Labels",
    "screen.title.templates": "Templates",
    "screen.title.advertisements": "Advertisements",
    "screen.title.setting": "Settings",
    "screen.title.setting.display": "Display",
    "screen.title.setting.languages": "Languages",
    "screen.title.setting.colorThemes": "Color themes",
    //
    "screen.title.create": "Create new",
    "screen.title.update": "Update",
    "screen.title.detail": "Details",
    //
    "button.title.open": "Open",
    "button.title.setting": "Settings",
    //
    "card.title.total": "Total",
    "card.title.youWroteAt" : "You wrote at",
    //
    "form.field.title.title" : "Title",
    "form.field.title.content" : "Content",
    "form.field.title.subject" : "Topic",
    "form.field.title.parentSubject" : "Parent topic",
    "form.field.title.label" : "Labels",
    "form.field.title.color" : "Color",
    //
    "notification.noItem.note" : "No notes found!",
    "notification.noItem.subject" : "No topics found!",
    "notification.noItem.label" : "No labels found!",
    "notification.noItem.template" : "No note templates found!",
    //
    "tooltip.button.notesHome" : "Notes",
    "tooltip.button.createNote" : "Create note",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "Topics",
    "tooltip.button.createSubject" : "Create topic",
    "tooltip.button.labelsHome" : "Labels",
    "tooltip.button.createLabel" : "Create label",
    "tooltip.button.templatesHome" : "Templates",
    "tooltip.button.createTemplate" : "Create template",
    "tooltip.button." : "",

    "tooltip.button.home" : "Homepage",
    "tooltip.button.save" : "Save",
    "tooltip.button.update" : "Update",
    "tooltip.button.delete" : "Delete",
    "tooltip.button.deleteForever" : "Permanently delete",
    "tooltip.button.restore" : "Restore",
    "tooltip.button.filter" : "Filter",
    "tooltip.button.reload" : "Refresh page",
    "tooltip.button.search" : "Search",
    "tooltip.button.calendar" : "Calendar",
  };

  static Map<String, String> russianWords = {
    "screen.title.notes": "Заметки",
    "screen.title.subjects": "Темы",
    "screen.title.labels": "Метки",
    "screen.title.templates": "Шаблоны",
    "screen.title.advertisements": "Рекламы",
    "screen.title.setting": "Настройки",
    "screen.title.setting.display": "Дисплей",
    "screen.title.setting.languages": "Языки",
    "screen.title.setting.colorThemes": "Цветовые темы",
    //
    "screen.title.create": "Создать новый",
    "screen.title.update": "Обновить",
    "screen.title.detail": "Детали",
    //
    "button.title.open": "Открыть",
    "button.title.setting": "Настройки",
    //
    "card.title.total": "Общее количество",
    "card.title.youWroteAt" : "Вы написали в",
    //
    "form.field.title.title" : "Заголовок",
    "form.field.title.content" : "Содержание",
    "form.field.title.subject" : "Тема",
    "form.field.title.parentSubject" : "Родительская тема",
    "form.field.title.label" : "Метки",
    "form.field.title.color" : "Цвет",
    //
    "notification.noItem.note" : "Нет заметок!",
    "notification.noItem.subject" : "Нет тем!",
    "notification.noItem.label" : "Нет ярлыков!",
    "notification.noItem.template" : "Нет шаблонов заметок!",
    //
    "tooltip.button.notesHome" : "Заметки",
    "tooltip.button.createNote" : "Создать заметку",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "Темы",
    "tooltip.button.createSubject" : "Создать тему",
    "tooltip.button.labelsHome" : "Метки",
    "tooltip.button.createLabel" : "Создать ярлык",
    "tooltip.button.templatesHome" : "Шаблоны",
    "tooltip.button.createTemplate" : "Создать шаблон",
    "tooltip.button." : "",

    "tooltip.button.home" : "Домашняя страница",
    "tooltip.button.save" : "Сохранить",
    "tooltip.button.update" : "Обновить",
    "tooltip.button.delete" : "Удалить",
    "tooltip.button.deleteForever" : "Полностью удалить",
    "tooltip.button.restore" : "Восстановить",
    "tooltip.button.filter" : "Фильтр",
    "tooltip.button.reload" : "Обновить страницу",
    "tooltip.button.search" : "Поиск",
    "tooltip.button.calendar" : "Календарь",
  };

  static Map<String, String> vietnameseWords = {
    "screen.title.notes": "Ghi chú",
    "screen.title.subjects": "Chủ đề",
    "screen.title.labels": "Nhãn dán",
    "screen.title.templates": "Mẫu",
    "screen.title.advertisements": "Quảng cáo",
    "screen.title.setting": "Cài đặt",
    "screen.title.setting.display": "Hiển thị",
    "screen.title.setting.languages": "Ngôn ngữ",
    "screen.title.setting.colorThemes": "Các chủ đề màu sắc",
    //
    "screen.title.create": "Tạo mới",
    "screen.title.update": "Cập nhật",
    "screen.title.detail": "Chi tiết",
    //
    "button.title.open": "Mở",
    "button.title.setting": "Cài đặt",
    //
    "card.title.total": "Tổng",
    "card.title.youWroteAt" : "Bạn đã viết vào lúc",
    //
    "form.field.title.title" : "Tiêu đề",
    "form.field.title.content" : "Nội dung",
    "form.field.title.subject" : "Chủ đề",
    "form.field.title.parentSubject" : "Chủ đề cha",
    "form.field.title.label" : "Nhãn dán",
    "form.field.title.color" : "Màu sắc",
    //
    "notification.noItem.note" : "Không có ghi chú nào!",
    "notification.noItem.subject" : "Không có chủ đề nào!",
    "notification.noItem.label" : "Không có nhãn dán nào!",
    "notification.noItem.template" : "Không có mẫu ghi chú nào!",
    //
    "tooltip.button.notesHome" : "Ghi chú",
    "tooltip.button.createNote" : "Tạo ghi chú",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "Chủ đề",
    "tooltip.button.createSubject" : "Tạo chủ đề",
    "tooltip.button.labelsHome" : "Nhãn dán",
    "tooltip.button.createLabel" : "Tạo nhãn dán",
    "tooltip.button.templatesHome" : "Mẫu",
    "tooltip.button.createTemplate" : "Tạo mẫu",
    "tooltip.button." : "",

    "tooltip.button.home" : "Trang chủ",
    "tooltip.button.save" : "Lưu",
    "tooltip.button.update" : "Cập nhật",
    "tooltip.button.delete" : "Xóa",
    "tooltip.button.deleteForever" : "Xóa vĩnh viễn",
    "tooltip.button.restore" : "Khôi phục",
    "tooltip.button.filter" : "Bộ lọc",
    "tooltip.button.reload" : "Tải lại trang",
    "tooltip.button.search" : "Tìm kiếm",
    "tooltip.button.calendar" : "Lịch",
  };

  static Map<String, String> portugueseWords = {
    "screen.title.notes": "Notas",
    "screen.title.subjects": "Tópicos",
    "screen.title.labels": "Etiquetas",
    "screen.title.templates": "Modelos",
    "screen.title.advertisements": "Anúncios",
    "screen.title.setting": "Configurações",
    "screen.title.setting.display": "Exibição",
    "screen.title.setting.languages": "Idiomas",
    "screen.title.setting.colorThemes": "Temas de cores",
    //
    "screen.title.create": "Criar novo",
    "screen.title.update": "Atualizar",
    "screen.title.detail": "Detalhes",
    //
    "button.title.open": "Abrir",
    "button.title.setting": "Configurações",
    //
    "card.title.total": "Total",
    "card.title.youWroteAt" : "Você escreveu às",
    //
    "form.field.title.title" : "Título",
    "form.field.title.content" : "Conteúdo",
    "form.field.title.subject" : "Tópico",
    "form.field.title.parentSubject" : "Tópico pai",
    "form.field.title.label" : "Etiquetas",
    "form.field.title.color" : "Cor",
    //
    "notification.noItem.note" : "Sem notas!",
    "notification.noItem.subject" : "Sem tópicos!",
    "notification.noItem.label" : "Sem etiquetas!",
    "notification.noItem.template" : "Não há nenhum modelo de notas!",
    //
    "tooltip.button.notesHome" : "Notas",
    "tooltip.button.createNote" : "Criar nota",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "Tópicos",
    "tooltip.button.createSubject" : "Criar tópico",
    "tooltip.button.labelsHome" : "Etiquetas",
    "tooltip.button.createLabel" : "Criar etiqueta",
    "tooltip.button.templatesHome" : "Modelos",
    "tooltip.button.createTemplate" : "Criar modelo",
    "tooltip.button." : "",

    "tooltip.button.home" : "Página inicial",
    "tooltip.button.save" : "Salvar",
    "tooltip.button.update" : "Atualizar",
    "tooltip.button.delete" : "Excluir",
    "tooltip.button.deleteForever" : "Excluir permanentemente",
    "tooltip.button.restore" : "Restaurar",
    "tooltip.button.filter" : "Filtro",
    "tooltip.button.reload" : "Recarregar a página",
    "tooltip.button.search" : "Pesquisar",
    "tooltip.button.calendar" : "Calendário",
  };

  static Map<String, String> spanishWords = {
    "screen.title.notes": "Notas",
    "screen.title.subjects": "Temas",
    "screen.title.labels": "Etiquetas",
    "screen.title.templates": "Plantillas",
    "screen.title.advertisements": "Anuncios",
    "screen.title.setting": "Ajustes",
    "screen.title.setting.display": "Pantalla",
    "screen.title.setting.languages": "Idiomas",
    "screen.title.setting.colorThemes": "Temas de color",
    //
    "screen.title.create": "Crear nuevo",
    "screen.title.update": "Actualizar",
    "screen.title.detail": "Detalles",
    //
    "button.title.open": "Abrir",
    "button.title.setting": "Ajustes",
    //
    "card.title.total": "Total",
    "card.title.youWroteAt" : "Usted escribió a las",
    //
    "form.field.title.title" : "Título",
    "form.field.title.content" : "Contenido",
    "form.field.title.subject" : "Tema",
    "form.field.title.parentSubject" : "Tema padre",
    "form.field.title.label" : "Etiquetas",
    "form.field.title.color" : "Color",
    //
    "notification.noItem.note" : "¡No hay notas!",
    "notification.noItem.subject" : "¡No hay temas!",
    "notification.noItem.label" : "¡No hay etiquetas!",
    "notification.noItem.template" : "¡No hay plantillas de notas!",
    //
    "tooltip.button.notesHome" : "Notas",
    "tooltip.button.createNote" : "Crear nota",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "Temas",
    "tooltip.button.createSubject" : "Crear tema",
    "tooltip.button.labelsHome" : "Etiquetas",
    "tooltip.button.createLabel" : "Crear etiqueta",
    "tooltip.button.templatesHome" : "Plantillas",
    "tooltip.button.createTemplate" : "Crear plantilla",
    "tooltip.button." : "",

    "tooltip.button.home" : "Página principal",
    "tooltip.button.save" : "Guardar",
    "tooltip.button.update" : "Actualizar",
    "tooltip.button.delete" : "Borrar",
    "tooltip.button.deleteForever" : "Borrar permanentemente",
    "tooltip.button.restore" : "Restaurar",
    "tooltip.button.filter" : "Filtro",
    "tooltip.button.reload" : "Actualizar página",
    "tooltip.button.search" : "Buscar",
    "tooltip.button.calendar" : "Calendario",
  };

  static Map<String, String> chineseWords = {
    "screen.title.notes": "笔记",
    "screen.title.subjects": "主题",
    "screen.title.labels": "标签",
    "screen.title.templates": "模板",
    "screen.title.advertisements": "广告",
    "screen.title.setting": "设置",
    "screen.title.setting.display": "显示",
    "screen.title.setting.languages": "语言",
    "screen.title.setting.colorThemes": "颜色主题",
    //
    "screen.title.create": "创建新的",
    "screen.title.update": "更新",
    "screen.title.detail": "详细信息",
    //
    "button.title.open": "打开",
    "button.title.setting": "设置",
    //
    "card.title.total": "总数",
    "card.title.youWroteAt" : "您在以下时间写下",
    //
    "form.field.title.title" : "标题",
    "form.field.title.content" : "内容",
    "form.field.title.subject" : "主题",
    "form.field.title.parentSubject" : "父主题",
    "form.field.title.label" : "标签",
    "form.field.title.color" : "颜色",
    //
    "notification.noItem.note" : "没有笔记！",
    "notification.noItem.subject" : "没有主题！",
    "notification.noItem.label" : "没有标签！",
    "notification.noItem.template" : "没有任何笔记模板！",
    //
    "tooltip.button.notesHome" : "笔记",
    "tooltip.button.createNote" : "创建笔记",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "主题",
    "tooltip.button.createSubject" : "创建主题",
    "tooltip.button.labelsHome" : "标签",
    "tooltip.button.createLabel" : "创建标签",
    "tooltip.button.templatesHome" : "模板",
    "tooltip.button.createTemplate" : "创建模板",
    "tooltip.button." : "",

    "tooltip.button.home" : "主页",
    "tooltip.button.save" : "保存",
    "tooltip.button.update" : "更新",
    "tooltip.button.delete" : "删除",
    "tooltip.button.deleteForever" : "永久删除",
    "tooltip.button.restore" : "恢复",
    "tooltip.button.filter" : "过滤器",
    "tooltip.button.reload" : "刷新页面",
    "tooltip.button.search" : "搜索",
    "tooltip.button.calendar" : "日历",
  };

  static Map<String, String> japaneseWords = {
    "screen.title.notes": "ノート",
    "screen.title.subjects": "トピックス",
    "screen.title.labels": "ラベル",
    "screen.title.templates": "テンプレート",
    "screen.title.advertisements": "広告",
    "screen.title.setting": "設定",
    "screen.title.setting.display": "表示",
    "screen.title.setting.languages": "言語",
    "screen.title.setting.colorThemes": "カラーテーマ",
    //
    "screen.title.create": "新規作成",
    "screen.title.update": "更新",
    "screen.title.detail": "詳細",
    //
    "button.title.open": "開く",
    "button.title.setting": "設定",
    //
    "card.title.total": "合計",
    "card.title.youWroteAt" : "あなたが書いたのは",
    //
    "form.field.title.title" : "タイトル",
    "form.field.title.content" : "コンテンツ",
    "form.field.title.subject" : "トピック",
    "form.field.title.parentSubject" : "親トピック",
    "form.field.title.label" : "ラベル",
    "form.field.title.color" : "色",
    //
    "notification.noItem.note" : "ノートは見つかりません！",
    "notification.noItem.subject" : "トピックは見つかりません！",
    "notification.noItem.label" : "ラベルは見つかりません！",
    "notification.noItem.template" : "ノートのテンプレートが見つかりません！",
    //
    "tooltip.button.notesHome" : "ノート",
    "tooltip.button.createNote" : "メモを作成する",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "トピックス",
    "tooltip.button.createSubject" : "トピックを作成する",
    "tooltip.button.labelsHome" : "ラベル",
    "tooltip.button.createLabel" : "ラベルを作成する",
    "tooltip.button.templatesHome" : "テンプレート",
    "tooltip.button.createTemplate" : "テンプレートを作成する",
    "tooltip.button." : "",

    "tooltip.button.home" : "ホームページ",
    "tooltip.button.save" : "保存する",
    "tooltip.button.update" : "更新",
    "tooltip.button.delete" : "削除する",
    "tooltip.button.deleteForever" : "永久削除する",
    "tooltip.button.restore" : "復元する",
    "tooltip.button.filter" : "フィルター",
    "tooltip.button.reload" : "ページを更新する",
    "tooltip.button.search" : "検索する",
    "tooltip.button.calendar" : "カレンダー",
  };

  static Map<String, String> indonesianWords = {
    "screen.title.notes": "Catatan",
    "screen.title.subjects": "Topik",
    "screen.title.labels": "Label",
    "screen.title.templates": "Templat",
    "screen.title.advertisements": "Iklan",
    "screen.title.setting": "Pengaturan",
    "screen.title.setting.display": "Tampilan",
    "screen.title.setting.languages": "Bahasa",
    "screen.title.setting.colorThemes": "Tema warna",
    //
    "screen.title.create": "Buat baru",
    "screen.title.update": "Perbarui",
    "screen.title.detail": "Detail",
    //
    "button.title.open": "Membuka",
    "button.title.setting": "Pengaturan",
    //
    "card.title.total": "Total",
    "card.title.youWroteAt" : "Anda menulis pada pukul",
    //
    "form.field.title.title" : "Judul",
    "form.field.title.content" : "Isi",
    "form.field.title.subject" : "Topik",
    "form.field.title.parentSubject" : "Topik induk",
    "form.field.title.label" : "Label",
    "form.field.title.color" : "Warna",
    //
    "notification.noItem.note" : "Tidak ada catatan!",
    "notification.noItem.subject" : "Tidak ada topik!",
    "notification.noItem.label" : "Tidak ada label!",
    "notification.noItem.template" : "Tidak ada template catatan!",
    //
    "tooltip.button.notesHome" : "Catatan",
    "tooltip.button.createNote" : "Buat catatan",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "Topik",
    "tooltip.button.createSubject" : "Buat topik",
    "tooltip.button.labelsHome" : "Label",
    "tooltip.button.createLabel" : "Buat label",
    "tooltip.button.templatesHome" : "Templat",
    "tooltip.button.createTemplate" : "Membuat template",
    "tooltip.button." : "",

    "tooltip.button.home" : "Halaman utama",
    "tooltip.button.save" : "Simpan",
    "tooltip.button.update" : "Perbarui",
    "tooltip.button.delete" : "Hapus",
    "tooltip.button.deleteForever" : "Menghapus secara permanen",
    "tooltip.button.restore" : "Mengembalikan",
    "tooltip.button.filter" : "Filter",
    "tooltip.button.reload" : "Segarkan halaman",
    "tooltip.button.search" : "Cari",
    "tooltip.button.calendar" : "Kalender",
  };

  static Map<String, String> frenchWords = {
    "screen.title.notes": "Notes",
    "screen.title.subjects": "Thèmes",
    "screen.title.labels": "Étiquettes",
    "screen.title.templates": "Modèles",
    "screen.title.advertisements": "Publicités",
    "screen.title.setting": "Paramètres",
    "screen.title.setting.display": "Affichage",
    "screen.title.setting.languages": "Langues",
    "screen.title.setting.colorThemes": "Thèmes de couleur",
    //
    "screen.title.create": "Créer un nouveau",
    "screen.title.update": "Mettre à jour",
    "screen.title.detail": "Détails",
    //
    "button.title.open": "Ouvrir",
    "button.title.setting": "Paramètres",
    //
    "form.field.title.title" : "Titre",
    "form.field.title.content" : "Contenu",
    "form.field.title.subject" : "Sujet",
    "form.field.title.parentSubject" : "Sujet parent",
    "form.field.title.label" : "Étiquettes",
    "form.field.title.color" : "Couleur",
    //
    "card.title.total": "Total",
    "card.title.youWroteAt" : "Vous avez écrit à",
    //
    "notification.noItem.note" : "Aucune note trouvée!",
    "notification.noItem.subject" : "Aucun sujet trouvé!",
    "notification.noItem.label" : "Aucune étiquette trouvée!",
    "notification.noItem.template" : "Aucun modèle de notes trouvé !",
    //
    "tooltip.button.notesHome" : "Notes",
    "tooltip.button.createNote" : "Créer une note",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "Thèmes",
    "tooltip.button.createSubject" : "Créer un sujet",
    "tooltip.button.labelsHome" : "Étiquettes",
    "tooltip.button.createLabel" : "Créer une étiquette",
    "tooltip.button.templatesHome" : "Modèles",
    "tooltip.button.createTemplate" : "Créer un modèle",
    "tooltip.button." : "Calendrier",

    "tooltip.button.home" : "Page d'accueil",
    "tooltip.button.save" : "Sauvegarder",
    "tooltip.button.update" : "Mettre à jour",
    "tooltip.button.delete" : "Supprimer",
    "tooltip.button.deleteForever" : "Supprimer définitivement",
    "tooltip.button.restore" : "Restaurer",
    "tooltip.button.filter" : "Filtre",
    "tooltip.button.reload" : "Rafraîchir la page",
    "tooltip.button.search" : "Rechercher",
    "tooltip.button.calendar" : "",
  };

  static Map<String, String> koreanWords = {
    "screen.title.notes": "메모",
    "screen.title.subjects": "주제",
    "screen.title.labels": "라벨",
    "screen.title.templates": "템플릿",
    "screen.title.advertisements": "광고",
    "screen.title.setting": "설정",
    "screen.title.setting.display": "디스플레이",
    "screen.title.setting.languages": "언어들",
    "screen.title.setting.colorThemes": "색상 테마",
    //
    "screen.title.create": "새로 만들기",
    "screen.title.update": "업데이트",
    "screen.title.detail": "세부 사항",
    //
    "button.title.open": "열다",
    "button.title.setting": "설정",
    //
    "card.title.total": "총액",
    "card.title.youWroteAt" : "당신은 다음 시간에 썼습니다",
    //
    "form.field.title.title" : "제목",
    "form.field.title.content" : "내용",
    "form.field.title.subject" : "주제",
    "form.field.title.parentSubject" : "상위 주제",
    "form.field.title.label" : "라벨",
    "form.field.title.color" : "색깔",
    //
    "notification.noItem.note" : "노트가 없습니다!",
    "notification.noItem.subject" : "주제가 없습니다!",
    "notification.noItem.label" : "라벨이 없습니다!",
    "notification.noItem.template" : "노트 템플릿이 없습니다!",
    //
    "tooltip.button.notesHome" : "메모",
    "tooltip.button.createNote" : "메모 만들기",
    "tooltip.button.createNoteForSelectedDay" : "",
    "tooltip.button.subjectsHome" : "주제",
    "tooltip.button.createSubject" : "주제 만들기",
    "tooltip.button.labelsHome" : "라벨",
    "tooltip.button.createLabel" : "라벨 만들기",
    "tooltip.button.templatesHome" : "템플릿",
    "tooltip.button.createTemplate" : "템플릿 만들기",
    "tooltip.button." : "",

    "tooltip.button.home" : "홈페이지",
    "tooltip.button.save" : "저장",
    "tooltip.button.update" : "업데이트",
    "tooltip.button.delete" : "삭제",
    "tooltip.button.deleteForever" : "영구 삭제",
    "tooltip.button.restore" : "복원하다",
    "tooltip.button.filter" : "필터",
    "tooltip.button.reload" : "페이지 새로 고침",
    "tooltip.button.search" : "검색하다",
    "tooltip.button.calendar" : "달력",
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
