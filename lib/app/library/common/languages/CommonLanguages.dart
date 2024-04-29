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
    //
    "screen.title.create": "Create new",
    "screen.title.update": "Update",
    "screen.title.detail": "Details",
    //
    "button.title.open": "Open",
    //
    "card.title.total": "Total",
    //
    "form.field.title.title" : "Title",
    "form.field.title.content" : "Content",
    "form.field.title.subject" : "Topic",
    "form.field.title.parentSubject" : "Parent topic",
    "form.field.title.label" : "Labels",
    "form.field.title.color" : "Color",
  };

  static Map<String, String> russianWords = {
    "screen.title.notes": "Заметки",
    "screen.title.subjects": "Темы",
    "screen.title.labels": "Метки",
    "screen.title.templates": "Шаблоны",
    "screen.title.advertisements": "Рекламы",
    //
    "screen.title.create": "Создать новый",
    "screen.title.update": "Обновить",
    "screen.title.detail": "Детали",
    //
    "button.title.open": "Открыть",
    //
    "card.title.total": "Общее количество",
    //
    "form.field.title.title" : "Заголовок",
    "form.field.title.content" : "Содержание",
    "form.field.title.subject" : "Тема",
    "form.field.title.parentSubject" : "Родительская тема",
    "form.field.title.label" : "Метки",
    "form.field.title.color" : "Цвет",
  };

  static Map<String, String> vietnameseWords = {
    "screen.title.notes": "Ghi chú",
    "screen.title.subjects": "Chủ đề",
    "screen.title.labels": "Nhãn dán",
    "screen.title.templates": "Mẫu",
    "screen.title.advertisements": "Quảng cáo",
    //
    "screen.title.create": "Tạo mới",
    "screen.title.update": "Cập nhật",
    "screen.title.detail": "Chi tiết",
    //
    "button.title.open": "Mở",
    //
    "card.title.total": "Tổng",
    //
    "form.field.title.title" : "Tiêu đề",
    "form.field.title.content" : "Nội dung",
    "form.field.title.subject" : "Chủ đề",
    "form.field.title.parentSubject" : "Chủ đề cha",
    "form.field.title.label" : "Nhãn dán",
    "form.field.title.color" : "Màu sắc",
  };

  static Map<String, String> portugueseWords = {
    "screen.title.notes": "Notas",
    "screen.title.subjects": "Tópicos",
    "screen.title.labels": "Etiquetas",
    "screen.title.templates": "Modelos",
    "screen.title.advertisements": "Anúncios",
    //
    "screen.title.create": "Criar novo",
    "screen.title.update": "Atualizar",
    "screen.title.detail": "Detalhes",
    //
    "button.title.open": "Abrir",
    //
    "card.title.total": "Total",
    //
    "form.field.title.title" : "Título",
    "form.field.title.content" : "Conteúdo",
    "form.field.title.subject" : "Tópico",
    "form.field.title.parentSubject" : "Tópico pai",
    "form.field.title.label" : "Etiquetas",
    "form.field.title.color" : "Cor",
  };

  static Map<String, String> spanishWords = {
    "screen.title.notes": "Notas",
    "screen.title.subjects": "Temas",
    "screen.title.labels": "Etiquetas",
    "screen.title.templates": "Plantillas",
    "screen.title.advertisements": "Anuncios",
    //
    "screen.title.create": "Crear nuevo",
    "screen.title.update": "Actualizar",
    "screen.title.detail": "Detalles",
    //
    "button.title.open": "Abrir",
    "card.title.total": "Total",
    //
    "form.field.title.title" : "Título",
    "form.field.title.content" : "Contenido",
    "form.field.title.subject" : "Tema",
    "form.field.title.parentSubject" : "Tema padre",
    "form.field.title.label" : "Etiquetas",
    "form.field.title.color" : "Color",
  };

  static Map<String, String> chineseWords = {
    "screen.title.notes": "笔记",
    "screen.title.subjects": "主题",
    "screen.title.labels": "标签",
    "screen.title.templates": "模板",
    "screen.title.advertisements": "广告",
    //
    "screen.title.create": "创建新的",
    "screen.title.update": "更新",
    "screen.title.detail": "详细信息",
    //
    "button.title.open": "打开",
    //
    "card.title.total": "总数",
    //
    "form.field.title.title" : "标题",
    "form.field.title.content" : "内容",
    "form.field.title.subject" : "主题",
    "form.field.title.parentSubject" : "父主题",
    "form.field.title.label" : "标签",
    "form.field.title.color" : "颜色",
  };

  static Map<String, String> japaneseWords = {
    "screen.title.notes": "ノート",
    "screen.title.subjects": "トピックス",
    "screen.title.labels": "ラベル",
    "screen.title.templates": "テンプレート",
    "screen.title.advertisements": "広告",
    //
    "screen.title.create": "新規作成",
    "screen.title.update": "更新",
    "screen.title.detail": "詳細",
    //
    "button.title.open": "開く",
    //
    "card.title.total": "合計",
    //
    "form.field.title.title" : "タイトル",
    "form.field.title.content" : "コンテンツ",
    "form.field.title.subject" : "トピック",
    "form.field.title.parentSubject" : "親トピック",
    "form.field.title.label" : "ラベル",
    "form.field.title.color" : "色",
  };

  static Map<String, String> indonesianWords = {
    "screen.title.notes": "Catatan",
    "screen.title.subjects": "Topik",
    "screen.title.labels": "Label",
    "screen.title.templates": "Templat",
    "screen.title.advertisements": "Iklan",
    //
    "screen.title.create": "Buat baru",
    "screen.title.update": "Perbarui",
    "screen.title.detail": "Detail",
    //
    "button.title.open": "Membuka",
    //
    "card.title.total": "Total",
    //
    "form.field.title.title" : "Judul",
    "form.field.title.content" : "Isi",
    "form.field.title.subject" : "Topik",
    "form.field.title.parentSubject" : "Topik induk",
    "form.field.title.label" : "Label",
    "form.field.title.color" : "Warna",
  };

  static Map<String, String> frenchWords = {
    "screen.title.notes": "Notes",
    "screen.title.subjects": "Thèmes",
    "screen.title.labels": "Étiquettes",
    "screen.title.templates": "Modèles",
    "screen.title.advertisements": "Publicités",
    //
    "screen.title.create": "Créer un nouveau",
    "screen.title.update": "Mettre à jour",
    "screen.title.detail": "Détails",
    //
    "button.title.open": "Ouvrir",
    //
    "form.field.title.title" : "Titre",
    "form.field.title.content" : "Contenu",
    "form.field.title.subject" : "Sujet",
    "form.field.title.parentSubject" : "Sujet parent",
    "form.field.title.label" : "Étiquettes",
    "form.field.title.color" : "Couleur",
    //
    "card.title.total": "Total",
  };

  static Map<String, String> koreanWords = {
    "screen.title.notes": "메모",
    "screen.title.subjects": "주제",
    "screen.title.labels": "라벨",
    "screen.title.templates": "템플릿",
    "screen.title.advertisements": "광고",
    //
    "screen.title.create": "새로 만들기",
    "screen.title.update": "업데이트",
    "screen.title.detail": "세부 사항",
    //
    "button.title.open": "열다",
    //
    "card.title.total": "총액",
    //
    "form.field.title.title" : "제목",
    "form.field.title.content" : "내용",
    "form.field.title.subject" : "주제",
    "form.field.title.parentSubject" : "상위 주제",
    "form.field.title.label" : "라벨",
    "form.field.title.color" : "색깔",
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
