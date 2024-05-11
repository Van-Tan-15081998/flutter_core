import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../core/components/form/CoreTextFormField.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../library/common/dimensions/CommonDimensions.dart';
import '../../../library/common/languages/CommonLanguages.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/common/themes/ThemeDataCenter.dart';
import '../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../home/home_screen.dart';
import '../../setting/providers/setting_notifier.dart';
import '../label/databases/label_db_manager.dart';
import '../label/models/label_model.dart';
import '../subjects/databases/subject_db_manager.dart';
import '../subjects/models/subject_model.dart';
import '../subjects/widgets/subject_create_screen.dart';
import 'databases/note_db_manager.dart';
import 'models/note_condition_model.dart';
import 'models/note_model.dart';
import 'note_create_screen.dart';
import 'providers/note_notifier.dart';
import 'widgets/note_widget.dart';

class NoteListScreen extends StatefulWidget {
  final NoteConditionModel? noteConditionModel;
  final bool? isOpenSubjectsForFilter;
  final RedirectFromEnum? redirectFrom;

  const NoteListScreen(
      {super.key,
      required this.noteConditionModel,
        required this.isOpenSubjectsForFilter,
        required this.redirectFrom
      });

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton = CommonAudioOnPressButton();
  final ScrollController _scrollController = ScrollController();

  /*
   Parameters For Search & Filter
   */
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchText = "";
  bool _filterByDeleted = false;
  bool _filterByDate = false;
  bool _filterBySubject = false;
  bool _filterByLabel = false;
  bool _filterByRecentlyUpdated = false;
  bool _filterByFavourite = false;
  bool _filterByCreatedForDay = false;

  List<LabelModel>? _labelList = [];
  List<SubjectModel>? _subjectList = [];

  SubjectModel? filteredSubject;
  LabelModel? filteredLabel;

  /*
   Parameters For Pagination
   */
  static const _pageSize = 10;
  final PagingController<int, NoteModel> _pagingController =
      PagingController(firstPageKey: 0);

  final CorePaginationModel _corePaginationModel =
      CorePaginationModel(currentPageIndex: 0, itemPerPage: _pageSize);
  NoteConditionModel _noteConditionModel = NoteConditionModel();

  /*
  Table Calendar
   */
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
      // RangeSelectionMode.toggledOn; // Can be toggled on/off by longPressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final _firstDay = DateTime(
      DateTime.now().year - 5, DateTime.now().month, DateTime.now().day);
  final _lastDay = DateTime(
      DateTime.now().year + 5, DateTime.now().month, DateTime.now().day);
  final Map<DateTime, List<dynamic>> _noteEvents = {};

  /*
  Function fetch page data
   */
  Future<List<NoteModel>> _onFetchPage(int pageKey) async {
    try {
      List<NoteModel>? result = [];
      result = await NoteDatabaseManager.onGetNotePagination(
          _corePaginationModel, _noteConditionModel);

      if (result == null) {
        return [];
      }

      return result;
    } catch (error) {
      // Handle error and return an empty list
      _pagingController.error = error;
      return [];
    }
  }

  _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();

    // Fetch Labels and Subjects
    _fetchLabels().then((labelsResult) {
      if (labelsResult != null && labelsResult.isNotEmpty) {
        setState(() {
          _labelList = labelsResult;
        });
      }
    });

    _fetchSubjects().then((subjectsResult) {
      if (subjectsResult != null && subjectsResult.isNotEmpty) {
        _subjectList = subjectsResult;
      }
    });

    _fetchNotesDistinctCreatedAt().then((notesResult) {
      if (notesResult != null && notesResult.isNotEmpty) {
        for (var note in notesResult) {
          DateTime dateTime;
          if (note.createdForDay != null) {
            dateTime =
                DateTime.fromMillisecondsSinceEpoch(note.createdForDay!);
            _noteEvents.addAll({
              DateTime.utc(dateTime.year, dateTime.month, dateTime.day): ['1']
            });
          } else  if (note.createdAtDayFormat != null) {
             dateTime =
            DateTime.fromMillisecondsSinceEpoch(note.createdAtDayFormat!);
             _noteEvents.addAll({
               DateTime.utc(dateTime.year, dateTime.month, dateTime.day): ['1']
             });
          }
        }
      }
    });

    // Init Conditions
    if (widget.noteConditionModel != null) {
      _noteConditionModel = widget.noteConditionModel!;
    }

    // Init For Pagination
    _pagingController.addPageRequestListener((pageKey) {
      _onFetchPage(pageKey).then((items) {
        if (items.isNotEmpty) {
          final isLastPage = items.length < _pageSize;

          if (_corePaginationModel.currentPageIndex == 0) {
            _scrollToTop();
          }

          if (isLastPage) {
            _pagingController.appendLastPage(items);
          } else {
            _pagingController.appendPage(items, pageKey + 1);
            _corePaginationModel.currentPageIndex++;
          }
        } else {
          _pagingController.appendLastPage([]);
        }
      });
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    /*
    Redirect from SubjectCreateScreen
     */
    if ((widget.isOpenSubjectsForFilter != null &&
            widget.isOpenSubjectsForFilter == true) ||
        (widget.noteConditionModel != null &&
            widget.noteConditionModel!.subjectId != null)) {
      _filterBySubject = true;
      _fetchSubjectsForFilter();

      if (widget.noteConditionModel != null &&
          widget.noteConditionModel!.subjectId != null) {
        _getFilteredSubject();
      }
    }
  }

  /*
  Get Labels From DB
   */
  Future<List<LabelModel>?> _fetchLabels() async {
    List<LabelModel>? localLabelList = await LabelDatabaseManager.all();

    return localLabelList;
  }

  /*
  Get Subjects From DB
   */
  Future<List<SubjectModel>?> _fetchSubjects() async {
    List<SubjectModel>? localSubjectList = await SubjectDatabaseManager.all();

    return localSubjectList;
  }

  /*
  Get Notes Distinct CreatedAt From DB
   */
  Future<List<NoteModel>?> _fetchNotesDistinctCreatedAt() async {
    List<NoteModel>? localNoteList =
        await NoteDatabaseManager.getAllNotesDistinctCreatedAt();

    return localNoteList;
  }

  _fetchSubjectsForFilter() {
    if (_filterBySubject) {
      if (_subjectList?.isEmpty ?? true) {
        _fetchSubjects().then((subjectsResult) {
          if (subjectsResult != null && subjectsResult.isNotEmpty) {
            setState(() {
              _subjectList = subjectsResult;
            });
          }
        });
      }
    }
  }

  /*
  Get note's labels
   */
  List<int> _getNoteLabelIds(NoteModel note) {
    List<int> noteLabelIds = [];
    if (note.label01Id != null) {
      noteLabelIds.add(note.label01Id!);
    }
    if (note.label02Id != null) {
      noteLabelIds.add(note.label02Id!);
    }
    if (note.label03Id != null) {
      noteLabelIds.add(note.label03Id!);
    }
    if (note.label04Id != null) {
      noteLabelIds.add(note.label04Id!);
    }
    if (note.label05Id != null) {
      noteLabelIds.add(note.label05Id!);
    }

    return noteLabelIds;
  }
  List<LabelModel>? _getNoteLabels(NoteModel note) {
    List<LabelModel>? noteLabels = [];
    List<dynamic> labelIds = _getNoteLabelIds(note);

    if (_labelList != null && _labelList!.isNotEmpty) {
      noteLabels = _labelList!
              .where((model) => labelIds.contains(model.id))
              .toList();
    }

    return noteLabels;
  }

  /*
    Get note's subject
   */
  SubjectModel? _getNoteSubject(int? subjectId) {
    List<SubjectModel>? subjects = [];

    if (_subjectList != null && _subjectList!.isNotEmpty) {
      subjects = _subjectList!.where((model) => subjectId == model.id).toList();
    }

    return subjects.isNotEmpty ? subjects.first : null;
  }

  /*
  Reset conditions - NoteConditionModel noteConditionModel
   */
  _resetConditions() {
    setState(() {
      _searchText = "";
      _searchController.text = "";
      _filterByDeleted = false;
      _filterByDate = false;
      _filterByFavourite = false;
      _filterByRecentlyUpdated = false;
      _filterByCreatedForDay = false;

      _filterBySubject = false;
      filteredSubject = null;
      _filterByLabel = false;
      filteredLabel = null;
      _selectedDay = null;
      _rangeStart = null;
      _rangeEnd = null;

      _noteConditionModel.createdAtEndOfDay = null;
      _noteConditionModel.createdAtStartOfDay = null;
      _noteConditionModel.searchText = null;
      _noteConditionModel.isDeleted = null;
      _noteConditionModel.recentlyUpdated = null;
      _noteConditionModel.subjectId = null;
      _noteConditionModel.labelId = null;
      _noteConditionModel.favourite = null;
      _noteConditionModel.createdForDay = null;

      _reloadPage();
    });
  }

  /*
  Check is filtering
   */
  bool _isFiltering() {
    if (_noteConditionModel.createdAtEndOfDay != null ||
        _noteConditionModel.createdAtStartOfDay != null ||
        (_noteConditionModel.searchText != null &&
            _noteConditionModel.searchText != "") ||
        _noteConditionModel.isDeleted == true ||
        _noteConditionModel.recentlyUpdated == true ||
        _noteConditionModel.subjectId != null ||
        _noteConditionModel.favourite == true ||
        _noteConditionModel.createdForDay == true ||
        _noteConditionModel.labelId != null) {
      return true;
    }
    return false;
  }

  /*
  Reload Page
   */
  _reloadPage() {
    _corePaginationModel.currentPageIndex = 0;
    _pagingController.refresh();
  }

  _onUpdateNote(BuildContext context, NoteModel note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteCreateScreen(
          note: note,
          copyNote: null,
          subject: null,
          actionMode: ActionModeEnum.update,
          redirectFrom: RedirectFromEnum.notes,
        ),
      ),
    );
  }

  Future<bool> _onDeleteNote(BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.delete(
        note, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteNoteForever(
      BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.deleteForever(note);
  }

  Future<bool> _onRestoreNoteFromTrash(
      BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.restoreFromTrash(
        note, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onFavouriteNote(BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.favourite(
        note,
        note.isFavourite == null
            ? DateTime.now().millisecondsSinceEpoch
            : null);
  }

  Future<bool> _onPinNote(BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.pin(
        note,
        note.isPinned == null
            ? DateTime.now().millisecondsSinceEpoch
            : null);
  }

  Future<bool> _onUnlockNote(BuildContext context, NoteModel note) async {
    return await NoteDatabaseManager.lock(
        note,
        null);
  }

  void _getFilteredSubject() async {
    SubjectModel? localFilteredSubject =
        await SubjectDatabaseManager.getById(_noteConditionModel.subjectId!);

    if (localFilteredSubject != null) {
      setState(() {
        filteredSubject = localFilteredSubject;
      });
    }
  }
  void _getFilteredLabel() async {
    LabelModel? localFilteredLabel =
    await LabelDatabaseManager.getById(_noteConditionModel.labelId!);

    if (localFilteredLabel != null) {
      setState(() {
        filteredLabel = localFilteredLabel;
      });
    }
  }

  Widget _filterPopup(BuildContext context, SettingNotifier settingNotifier) {
    return Form(
      child: CoreBasicDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                filteredSubject != null
                    ? Row(
                        children: [
                          Text(CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'form.filter.subject').addColon(), style: CommonStyles.labelFilterTextStyle),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        2.0, 2.0, 2.0, 2.0),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      color: filteredSubject!.color.toColor(),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        child: Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.palette_rounded,
                                                  color: filteredSubject!.color
                                                      .toColor(),
                                                ),
                                                const SizedBox(width: 6.0),
                                                Flexible(
                                                  child: Text(
                                                    filteredSubject!.title,
                                                    style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Container(),
                filteredLabel != null
                    ? Row(
                  children: [
                    Text(CommonLanguages.convert(
                        lang: settingNotifier.languageString ??
                            CommonLanguages.languageStringDefault(),
                        word: 'form.filter.label').addColon(), style: CommonStyles.labelFilterTextStyle),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  2.0, 2.0, 2.0, 2.0),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(12),
                                color: filteredLabel!.color.toColor(),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.label_important_rounded,
                                            color: filteredLabel!.color
                                                .toColor(),
                                          ),
                                          const SizedBox(width: 6.0),
                                          Flexible(
                                            child: Text(
                                              filteredLabel!.title,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                  FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
                    : Container(),
                _noteConditionModel.createdAtStartOfDay != null &&
                        _noteConditionModel.createdAtEndOfDay != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(CommonLanguages.convert(
                          lang: settingNotifier.languageString ??
                          CommonLanguages.languageStringDefault(),
                              word: 'form.filter.creationTime').addColon(),
                                      style: CommonStyles.labelFilterTextStyle),
                                ),
                                _noteConditionModel.createdAtStartOfDay != null &&
                                        _noteConditionModel.createdAtEndOfDay !=
                                            null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                            Text(
                                                'From: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(_noteConditionModel.createdAtStartOfDay!))}',
                                                style:
                                                    CommonStyles.labelFilterTextStyle),
                                            Text(
                                                'To: ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(_noteConditionModel.createdAtEndOfDay!))}',
                                                style: CommonStyles.labelFilterTextStyle)
                                          ])
                                    : Container(),
                              ]);
                        }),
                      )
                    : Container(),
                _noteConditionModel.searchText != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'form.filter.searchKeyword').addColon(),
                                    style: CommonStyles.labelFilterTextStyle),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '"${_noteConditionModel.searchText!}"',
                                          style: const TextStyle(
                                              color: Color(0xFF1f1f1f),
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : Container(),
                const SizedBox(height: 20.0),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'form.filter.trash').addColon(),
                            style: CommonStyles.labelFilterTextStyle),
                        Checkbox(
                          checkColor: Colors.white,
                          value: _filterByDeleted,
                          onChanged: (bool? value) {
                            setState(() {
                              _filterByDeleted = value!;
                              if (_filterByDeleted) {
                                _noteConditionModel.isDeleted = _filterByDeleted;
                              } else {
                                _noteConditionModel.isDeleted = null;
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'form.filter.favourite').addColon(),
                            style: CommonStyles.labelFilterTextStyle),
                        Checkbox(
                          checkColor: Colors.white,
                          value: _filterByFavourite,
                          onChanged: (bool? value) {
                            setState(() {
                              _filterByFavourite = value!;
                              if (_filterByFavourite) {
                                _noteConditionModel.favourite =
                                    _filterByFavourite;
                              } else {
                                _noteConditionModel.favourite = null;
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'form.filter.recentlyUpdated').addColon(),
                            style: CommonStyles.labelFilterTextStyle),
                        Checkbox(
                          checkColor: Colors.white,
                          value: _filterByRecentlyUpdated,
                          onChanged: (bool? value) {
                            setState(() {
                              _filterByRecentlyUpdated = value!;
                              if (_filterByRecentlyUpdated) {
                                _noteConditionModel.recentlyUpdated =
                                    _filterByRecentlyUpdated;
                              } else {
                                _noteConditionModel.recentlyUpdated = null;
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'form.filter.dueDate').addColon(),
                            style: CommonStyles.labelFilterTextStyle),
                        Checkbox(
                          checkColor: Colors.white,
                          value: _filterByCreatedForDay,
                          onChanged: (bool? value) {
                            setState(() {
                              _filterByCreatedForDay = value!;
                              if (_filterByCreatedForDay) {
                                _noteConditionModel.createdForDay = _filterByCreatedForDay;
                              } else {
                                _noteConditionModel.createdForDay = null;
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                CoreElevatedButton.icon(
                  buttonAudio: commonAudioOnPressButton,
                  icon: const FaIcon(FontAwesomeIcons.check,
                      size: 18.0),
                  label: Text(
                      CommonLanguages.convert(
                          lang: settingNotifier.languageString ??
                              CommonLanguages.languageStringDefault(),
                          word: 'button.title.accept'),
                      style: CommonStyles.labelTextStyle),
                  onPressed: () {
                    setState(() {
                      /// Reload Data
                      _reloadPage();

                      /// Close Dialog
                      Navigator.of(context).pop();
                    });
                  },
                  coreButtonStyle: CoreButtonStyle.options(
                      coreStyle: CoreStyle.filled,
                      coreColor: CoreColor.success,
                      coreRadius: CoreRadius.radius_6,
                      kitBorderColorOption: Colors.black,
                      kitForegroundColorOption: Colors.black,
                      coreFixedSizeButton:
                      CoreFixedSizeButton.medium_48),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NoteNotifier noteNotifier, SettingNotifier settingNotifier) {
    return Column(
      children: [
        settingNotifier.isSetBackgroundImage == true ? SizedBox(height:  CommonDimensions.scaffoldAppBarHeight(context)) : Container(),
        Expanded(
          child: Column(
            children: [
              _filterBySubject
                  ? Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: settingNotifier.isSetBackgroundImage == true
                          ? Colors.white.withOpacity(0.65)
                          : Colors.transparent
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Tooltip(
                                message: 'Create subject',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_rounded,
                                    color: ThemeDataCenter.getAloneTextColorStyle(
                                        context),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const SubjectCreateScreen(
                                          parentSubject: null,
                                          actionMode: ActionModeEnum.create,
                                          redirectFrom: RedirectFromEnum.notes,
                                        breadcrumb: null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () {
                                  setState(() {
                                    filteredSubject = null;
                                    _noteConditionModel.subjectId = null;
                                  });

                                  _reloadPage();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: ((filteredSubject == null &&
                                        widget.noteConditionModel?.subjectId ==
                                            null))
                                        ? ThemeDataCenter
                                        .getActiveBackgroundColorStyle(context)
                                        : Colors.transparent,
                                    border: Border(
                                      top: BorderSide(
                                        color: ThemeDataCenter.getAloneTextColorStyle(
                                            context),
                                        width: 1.0,
                                      ),
                                      right: BorderSide(
                                        color: ThemeDataCenter.getAloneTextColorStyle(
                                            context),
                                        width: 1.0,
                                      ),
                                      left: BorderSide(
                                        color: ThemeDataCenter.getAloneTextColorStyle(
                                            context),
                                        width: 1.0,
                                      ),
                                      bottom: BorderSide(
                                        color: ThemeDataCenter.getAloneTextColorStyle(
                                            context),
                                        width: 1.0,
                                      ),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 4.0, 10.0, 4.0),
                                    child: Text(
                                      CommonLanguages.convert(
                                          lang: settingNotifier
                                              .languageString ??
                                              CommonLanguages
                                                  .languageStringDefault(),
                                          word:
                                          'button.title.all'),
                                      style: TextStyle(
                                          color: ((filteredSubject == null &&
                                              widget.noteConditionModel
                                                  ?.subjectId ==
                                                  null))
                                              ? ThemeDataCenter
                                              .getTextOnActiveBackgroundColorStyle(
                                              context)
                                              : ThemeDataCenter
                                              .getAloneTextColorStyle(context),
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  _subjectList!.length,
                                      (index) => InkWell(
                                    borderRadius: BorderRadius.circular(16.0),
                                    onTap: () {
                                      filteredSubject = null;
                                      _noteConditionModel.subjectId =
                                          _subjectList![index].id;

                                      /*
                                        Get subject
                                         */
                                      _getFilteredSubject();

                                      _reloadPage();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: ((filteredSubject != null &&
                                            filteredSubject!.id ==
                                                _subjectList![index].id) ||
                                            (widget.noteConditionModel != null &&
                                                widget.noteConditionModel!
                                                    .subjectId ==
                                                    _subjectList![index].id))
                                            ? ThemeDataCenter
                                            .getActiveBackgroundColorStyle(
                                            context)
                                            : Colors.transparent,
                                        border: Border(
                                          top: BorderSide(
                                            color: ThemeDataCenter
                                                .getAloneTextColorStyle(context),
                                            width: 1.0,
                                          ),
                                          right: BorderSide(
                                            color: ThemeDataCenter
                                                .getAloneTextColorStyle(context),
                                            width: 1.0,
                                          ),
                                          left: BorderSide(
                                            color: ThemeDataCenter
                                                .getAloneTextColorStyle(context),
                                            width: 1.0,
                                          ),
                                          bottom: BorderSide(
                                            color: ThemeDataCenter
                                                .getAloneTextColorStyle(context),
                                            width: 1.0,
                                          ),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 4.0, 10.0, 4.0),
                                        child: Text(
                                          _subjectList![index].title,
                                          style: TextStyle(
                                              color: ((filteredSubject != null &&
                                                  filteredSubject!.id ==
                                                      _subjectList![index]
                                                          .id) ||
                                                  (widget.noteConditionModel !=
                                                      null &&
                                                      widget.noteConditionModel!
                                                          .subjectId ==
                                                          _subjectList![index]
                                                              .id))
                                                  ? ThemeDataCenter
                                                  .getTextOnActiveBackgroundColorStyle(
                                                  context)
                                                  : ThemeDataCenter
                                                  .getAloneTextColorStyle(
                                                  context),
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      _buildSubjectListPopup(context, settingNotifier)
                    ],
                  ),
                ),
              )
                  : Container(),
              _filterByDate
                  ? FadeIn(
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: settingNotifier.isSetBackgroundImage == true
                        ? Colors.white.withOpacity(0.85)
                        : ThemeDataCenter.getTableCalendarBackgroundColor(
                        context),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    boxShadow: settingNotifier.isSetBackgroundImage == true
                        ? null
                        : [
                      BoxShadow(
                        color: const Color(0xFF1f1f1f).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TableCalendar(

                    eventLoader: (date) {
                      return _noteEvents[date] ?? [];
                    },
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          _rangeStart = null; // Important to clean those
                          _rangeEnd = null;
                          _rangeSelectionMode = RangeSelectionMode.toggledOff;
                        });

                        if (_selectedDay != null) {
                          /*
                            Update Condition
                             */
                          _noteConditionModel.createdAtStartOfDay = DateTime(
                              _selectedDay!.year,
                              _selectedDay!.month,
                              _selectedDay!.day)
                              .millisecondsSinceEpoch;
                          _noteConditionModel.createdAtEndOfDay = DateTime(
                              _selectedDay!.year,
                              _selectedDay!.month,
                              _selectedDay!.day,
                              23,
                              59,
                              59,
                              999)
                              .millisecondsSinceEpoch;
                          /*
                            Reload Page
                             */
                          _reloadPage();
                        }
                      }
                    },
                    onRangeSelected: (start, end, focusedDay) {
                      setState(() {
                        _selectedDay = null;
                        _focusedDay = focusedDay;
                        _rangeStart = start;
                        _rangeEnd = end;
                        _rangeSelectionMode = RangeSelectionMode.toggledOn;
                      });

                      if (_rangeStart != null && _rangeEnd != null) {
                        /*
                          Update Condition
                           */
                        _noteConditionModel.createdAtStartOfDay = DateTime(
                            _rangeStart!.year,
                            _rangeStart!.month,
                            _rangeStart!.day)
                            .millisecondsSinceEpoch;
                        _noteConditionModel.createdAtEndOfDay = DateTime(
                            _rangeEnd!.year,
                            _rangeEnd!.month,
                            _rangeEnd!.day,
                            23,
                            59,
                            59,
                            999)
                            .millisecondsSinceEpoch;
                        /*
                            Reload Page
                             */
                        _reloadPage();
                      } else {
                        _noteConditionModel.createdAtStartOfDay = null;
                        _noteConditionModel.createdAtEndOfDay = null;
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                          color: Color(0xFF1f1f1f)
                      ),
                      weekendStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                          color: Colors.red
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                        defaultTextStyle:  TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1f1f1f)
                        ),
                    weekendTextStyle:  TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                        color: Color(0xFF1f1f1f)
                    ),
                      outsideTextStyle:  TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
                  : Container(),
              Expanded(
                child: PagedListView<int, NoteModel>(
                  padding: EdgeInsets.only(top: CommonDimensions.scaffoldAppBarHeight(context)/10,
                 bottom: 150.0),
                  scrollController: _scrollController,
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<NoteModel>(
                    animateTransitions: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    itemBuilder: (context, item, index) => NoteWidget(
                      key: ValueKey<int>(item.id!),
                      index: index + 1,
                      note: item,
                      labels: _getNoteLabels(item),
                      subject: _getNoteSubject(item.subjectId),
                      onUpdate: () {
                        _onUpdateNote(context, item);
                      },
                      onDelete: () {
                        _onDeleteNote(context, item).then((result) {
                          if (result) {
                            noteNotifier.onCountAll();

                            setState(() {
                              _pagingController.itemList!.remove(item);
                            });

                            CoreNotification.showMessage(
                                context, settingNotifier,
                                CoreNotificationStatus.success,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.deleted'));
                          } else {
                            CoreNotification.showMessage(
                                context, settingNotifier,
                                CoreNotificationStatus.error,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.error'));
                          }
                        });
                      },
                      onDeleteForever: () async {
                        if (await CoreHelperWidget.confirmFunction(context: context, settingNotifier: settingNotifier, confirmDelete: true)) {
                          _onDeleteNoteForever(context, item).then((result) {
                            if (result) {
                              noteNotifier.onCountAll();

                              setState(() {
                                _pagingController.itemList!.remove(item);
                              });

                              CoreNotification.showMessage(
                                  context, settingNotifier,
                                  CoreNotificationStatus.success,
                                  CommonLanguages.convert(
                                      lang: settingNotifier.languageString ??
                                          CommonLanguages.languageStringDefault(),
                                      word: 'notification.action.deleted'));
                            } else {
                              CoreNotification.showMessage(
                                  context, settingNotifier,
                                  CoreNotificationStatus.error,
                                  CommonLanguages.convert(
                                      lang: settingNotifier.languageString ??
                                          CommonLanguages.languageStringDefault(),
                                      word: 'notification.action.error'));
                            }
                          });
                        }
                      },
                      onRestoreFromTrash: () {
                        _onRestoreNoteFromTrash(context, item).then((result) {
                          if (result) {
                            noteNotifier.onCountAll();

                            setState(() {
                              _pagingController.itemList!.remove(item);
                            });

                            CoreNotification.showMessage(
                                context, settingNotifier,
                                CoreNotificationStatus.success,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.restored'));
                          } else {
                            CoreNotification.showMessage(
                                context, settingNotifier,
                                CoreNotificationStatus.error,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.error'));
                          }
                        });
                      },
                      onFavourite: () {
                        _onFavouriteNote(context, item).then((result) {
                          if (result) {
                            setState(() {
                              item.isFavourite = item.isFavourite == null
                                  ? DateTime.now().millisecondsSinceEpoch
                                  : null;
                            });

                            commonAudioOnPressButton.playAudioOnFavourite();
                          } else {
                            CoreNotification.showMessage(
                                context, settingNotifier,
                                CoreNotificationStatus.error,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.error'));
                          }
                        });
                      },
                      onPin: () {
                        _onPinNote(context, item).then((result) {
                          if (result) {
                            setState(() {
                              item.isPinned = item.isPinned == null
                                  ? DateTime.now().millisecondsSinceEpoch
                                  : null;
                            });

                            commonAudioOnPressButton.playAudioOnFavourite();
                          } else {
                            CoreNotification.showMessage(
                                context, settingNotifier,
                                CoreNotificationStatus.error,
                                CommonLanguages.convert(
                                    lang: settingNotifier.languageString ??
                                        CommonLanguages.languageStringDefault(),
                                    word: 'notification.action.error'));
                          }
                        });
                      },
                      onUnlock: () async {
                           if (await CoreHelperWidget.confirmFunction(context: context, settingNotifier: settingNotifier, confirmUnlock: true)) {
                             _onUnlockNote(context, item).then((result) {
                               if (result) {
                                 setState(() {
                                   item.isLocked = item.isLocked == null
                                    ? DateTime.now().millisecondsSinceEpoch
                                        : null;
                                    });

                              CoreNotification.showMessage(
                                  context, settingNotifier,
                                  CoreNotificationStatus.success,
                                  CommonLanguages.convert(
                                      lang: settingNotifier.languageString ??
                                          CommonLanguages.languageStringDefault(),
                                      word: 'notification.action.unlocked'));
                              } else {
                                CoreNotification.showMessage(
                                    context, settingNotifier,
                                    CoreNotificationStatus.error,
                                    CommonLanguages.convert(
                                        lang: settingNotifier.languageString ??
                                            CommonLanguages.languageStringDefault(),
                                        word: 'notification.action.error'));
                              }
                              });
                        }
                      },
                      onFilterBySubject: () {
                        if (item.subjectId != null) {
                          setState(() {
                            _filterBySubject = true;
                            _noteConditionModel.subjectId = item.subjectId;
                          });

                          /*
                              Get subject
                               */
                          _getFilteredSubject();

                          _reloadPage();
                        }
                      },
                      onFilterByLabel: (int? labelId) {
                        if (labelId != null) {
                          setState(() {
                            _filterByLabel = true;
                            _noteConditionModel.labelId = labelId;
                          });

                          /*
                              Get label
                               */
                          _getFilteredLabel();

                          _reloadPage();
                        }
                      },
                    ),
                    firstPageErrorIndicatorBuilder: (context) => Center(
                      child: Text(
                        'Error loading data!',
                        style: TextStyle(
                          color: ThemeDataCenter.getAloneTextColorStyle(context),
                        ),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                color: settingNotifier
                                    .isSetBackgroundImage ==
                                    true
                                    ? Colors.white.withOpacity(0.65)
                                    : Colors.transparent),
                            child: Row(
                              children: [
                                BounceInLeft(
                                  child: FaIcon(FontAwesomeIcons.waze,
                                      size: 30.0,
                                      color: ThemeDataCenter.getAloneTextColorStyle(
                                          context)),
                                ),
                                const SizedBox(width: 5),
                                BounceInRight(
                                  child: Text(
                                      CommonLanguages.convert(lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(), word: 'notification.noItem.note'),
                                    style: GoogleFonts.montserrat(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16.0,
                                      color: ThemeDataCenter.getAloneTextColorStyle(context),
                                      fontWeight: FontWeight.w500)
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectListPopup(BuildContext context, SettingNotifier settingNotifier) {
    return Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0, 2.0, 0),
                    child: Tooltip(
                      message: CommonLanguages.convert(
                          lang: settingNotifier
                              .languageString ??
                              CommonLanguages
                                  .languageStringDefault(),
                          word:
                          'button.title.selectSubject'),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeDataCenter.getFilteringTextColorStyle(context),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.list_rounded,
                              size: 22,
                              color:
                              ThemeDataCenter.getFilteringTextColorStyle(context),
                            ),
                          ),
                        ),
                        onTap: () async {
                          await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => CoreBasicDialog(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: SizedBox(
                                  height: CommonDimensions.maxHeightScreen(context)/2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: ListView.builder(
                                      itemCount: _subjectList!.length,
                                      itemBuilder: (context, index) {
                                        return  Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(10.0),
                                            onTap: () {
                                              filteredSubject = null;
                                              _noteConditionModel.subjectId =
                                                  _subjectList![index].id;

                                              /*
                                        Get subject
                                         */
                                              _getFilteredSubject();

                                              if (Navigator.canPop(context)) {
                                                Navigator.pop(context);
                                              }

                                              _reloadPage();
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: DottedBorder(
                                                                  borderType: BorderType.RRect,
                                                                  radius: const Radius.circular(12),
                                                                  color: _subjectList![index].color.toColor(),
                                                                  child: ClipRRect(
                                                                    borderRadius: const BorderRadius.all(
                                                                        Radius.circular(12)),
                                                                    child: Container(
                                                                        color: Colors.white,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(6.0),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.palette_rounded,
                                                                                color: _subjectList![index].color
                                                                                    .toColor(),
                                                                              ),
                                                                              const SizedBox(width: 6.0),
                                                                              Flexible(
                                                                                child: Text(
                                                                                    _subjectList![index].title,
                                                                                    maxLines: 1,
                                                                                    overflow:
                                                                                    TextOverflow.ellipsis),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                    ),
                                                                  ),
                                                              ),
                                                            ),
                                                          ],
                                                          ),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ),
                                ),
                              ),);
                        },
                      ),
                    ),
                  );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    commonAudioOnPressButton.dispose();
    super.dispose();
  }

  void _onPopAction(BuildContext context) {
    if (widget.redirectFrom == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen(
              title: 'Hi Notes',
            )),
            (route) => false,
      );
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Widget? _buildAppbarLeading(BuildContext context, SettingNotifier settingNotifier) {
    return
      IconButton(
        style: CommonStyles.appbarLeadingBackButtonStyle(whiteBlur: settingNotifier.isSetBackgroundImage == true ? true : false),
      icon: const FaIcon(FontAwesomeIcons.chevronLeft),
      onPressed: () {
        _onPopAction(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteNotifier = Provider.of<NoteNotifier>(context);
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return WillPopScope(
      onWillPop: () async {
        _onPopAction(context);
        return Navigator.canPop(context);
      },
      child: Scaffold(
        extendBodyBehindAppBar: settingNotifier.isSetBackgroundImage == true ? true : false,
        backgroundColor: settingNotifier.isSetBackgroundImage == true  ? Colors.transparent : ThemeDataCenter.getBackgroundColor(context),
        appBar: _buildAppBar(context, settingNotifier),
        body: settingNotifier.isSetBackgroundImage == true ? DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(settingNotifier.backgroundImageSourceString ?? CommonStyles.backgroundImageSourceStringDefault()), fit: BoxFit.cover),
          ),
          child: _buildBody(context, noteNotifier, settingNotifier),
        ) : _buildBody(context, noteNotifier, settingNotifier),
        bottomNavigationBar: settingNotifier.isSetBackgroundImage == true ? null : _buildBottomNavigationBar(context, settingNotifier),
      floatingActionButton: settingNotifier.isSetBackgroundImage == true ? _buildBottomNavigationBarActionList(context, settingNotifier) : null,
        floatingActionButtonLocation:
        FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }

  CoreBottomNavigationBar _buildBottomNavigationBar(BuildContext context, SettingNotifier settingNotifier) {
    return CoreBottomNavigationBar(
      backgroundColor: ThemeDataCenter.getBackgroundColor(context),
      child: IconTheme(
        data: const IconThemeData(color: Colors.white),
        child: _buildBottomNavigationBarActionList(context, settingNotifier),
      ),
    );
  }

  Widget _buildBottomNavigationBarActionList(BuildContext context, SettingNotifier settingNotifier) {
    return Row(
      mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Tooltip(
            message: CommonLanguages.convert(
                lang: settingNotifier
                    .languageString ??
                    CommonLanguages
                        .languageStringDefault(),
                word:
                'tooltip.button.reload'),
            child: CoreElevatedButton(
              buttonAudio: commonAudioOnPressButton,
              onPressed: () {
                _resetConditions();
              },
              coreButtonStyle:
                  ThemeDataCenter.getCoreScreenButtonStyle(context: context),
              child: const Icon(
                Icons.refresh_rounded,
                size: 25.0,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Tooltip(
            message: CommonLanguages.convert(
                lang: settingNotifier
                    .languageString ??
                    CommonLanguages
                        .languageStringDefault(),
                word:
                'tooltip.button.search'),
            child: CoreElevatedButton(
              buttonAudio: commonAudioOnPressButton,
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => Form(
                    child: CoreBasicDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CoreTextFormField(
                                    style: TextStyle(
                                      color: ThemeDataCenter
                                          .getAloneTextColorStyle(context),
                                    ),
                                    onChanged: (String value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          _searchText = value.trim();
                                        });
                                      }
                                    },
                                    controller: _searchController,
                                    focusNode: _searchFocusNode,
                                    validateString:
                                        'Please enter search string!',
                                    maxLength: 60,
                                    icon: Icon(
                                      Icons.edit,
                                      color: ThemeDataCenter
                                          .getFormFieldLabelColorStyle(
                                              context),
                                    ),
                                    label: 'Search',
                                    labelColor: ThemeDataCenter
                                        .getFormFieldLabelColorStyle(context),
                                    placeholder: 'Search on notes',
                                    helper: '',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                CoreElevatedButton.iconOnly(
                                    buttonAudio: commonAudioOnPressButton,
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () {
                                      if (_searchController.text.isNotEmpty) {
                                        setState(() {
                                          _searchController.text = "";
                                          _searchText = "";
                                          _noteConditionModel.searchText =
                                              _searchText;
                                        });
                                        // Reload Page
                                        _reloadPage();
                                      }
                                    },
                                    coreButtonStyle: ThemeDataCenter
                                        .getCoreScreenButtonStyle(context: context)),
                                CoreElevatedButton.iconOnly(
                                  buttonAudio: commonAudioOnPressButton,
                                  icon: const Icon(Icons.search_rounded),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        // Set Condition
                                        if (_searchController
                                            .text.isNotEmpty) {
                                          _noteConditionModel.searchText =
                                              _searchText;

                                          // Reload Data
                                          _reloadPage();

                                          // Close Dialog
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    }
                                  },
                                  coreButtonStyle: ThemeDataCenter
                                      .getCoreScreenButtonStyle(context: context),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              coreButtonStyle:
                  ThemeDataCenter.getCoreScreenButtonStyle(context: context),
              child: const Icon(
                Icons.search,
                size: 25.0,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Tooltip(
            message: CommonLanguages.convert(
                lang: settingNotifier
                    .languageString ??
                    CommonLanguages
                        .languageStringDefault(),
                word:
                'tooltip.button.filter'),
            child: CoreElevatedButton(
              buttonAudio: commonAudioOnPressButton,
              onPressed: () async {
                await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => _filterPopup(context, settingNotifier));
              },
              coreButtonStyle:
                  ThemeDataCenter.getCoreScreenButtonStyle(context: context),
              child: const Icon(
                Icons.filter_list_alt,
                size: 25.0,
              ),
            ),
          ),
          const SizedBox(width: 5),
          _selectedDay == null
              ? Tooltip(
            message: CommonLanguages.convert(
                lang: settingNotifier
                    .languageString ??
                    CommonLanguages
                        .languageStringDefault(),
                word:
                'tooltip.button.createNote'),
                child: CoreElevatedButton(
            buttonAudio: commonAudioOnPressButton,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteCreateScreen(
                              note: null,
                              copyNote: null,
                              subject: filteredSubject,
                              actionMode: ActionModeEnum.create,
                            redirectFrom: RedirectFromEnum.notes,
                          ),
                        ),
                      );
                    },
                    coreButtonStyle:
                        ThemeDataCenter.getCoreScreenButtonStyle(context: context),
                    child: const Icon(
                      Icons.add,
                      size: 25.0,
                    ),
                  ),
              )
              : PopupMenuButton<ActionCreateNoteEnum>(
                  icon: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color?>(ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitForegroundColor),
                        backgroundColor: MaterialStateProperty.all<Color?>(ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitBackgroundColor),
                        overlayColor: MaterialStateProperty.all<Color?>(ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitOverlayColor),
                        shadowColor: MaterialStateProperty.all<Color?>(ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitShadowColor),
                        elevation: MaterialStateProperty.all(ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitElevation),
                        // padding: MaterialStateProperty.all(ThemeDataCenter.getCoreScreenButtonStyle(context).kitPaddingLTRB),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitFontSize),
                        ),
                        fixedSize: MaterialStateProperty.all(Size.fromHeight(ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitHeight)),

                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitRadius)),
                            side: BorderSide(color: ThemeDataCenter.getCoreScreenButtonStyle(context: context).kitBorderColor))
                        )
                    ),
                    child: const Icon(Icons.add_rounded, size: 25,)
                  ),
                  onSelected: (ActionCreateNoteEnum action) {
                    if  (action == ActionCreateNoteEnum.createForSelectedDay) {
                      if (_selectedDay != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteCreateScreen(
                              note: null,
                              copyNote: null,
                              subject: filteredSubject,
                              actionMode: ActionModeEnum.create,
                              actionCreateNoteEnum: ActionCreateNoteEnum.createForSelectedDay,
                              createdForDay: DateTime(_selectedDay!.year,
                                  _selectedDay!.month, _selectedDay!.day)
                                  .millisecondsSinceEpoch,
                              redirectFrom: RedirectFromEnum.notes,
                            ),
                          ),
                        );
                      }
                    } else if (action  == ActionCreateNoteEnum.create) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteCreateScreen(
                              note: null,
                              copyNote: null,
                              subject: filteredSubject,
                              actionMode: ActionModeEnum.create,
                            redirectFrom: RedirectFromEnum.notes,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<ActionCreateNoteEnum>>[
                    PopupMenuItem<ActionCreateNoteEnum>(
                      value: ActionCreateNoteEnum.createForSelectedDay,
                      child: ListTile(
                        leading: const FaIcon(FontAwesomeIcons.calendarPlus),
                        title: Text(CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'button.title.createNoteForSelectedDay'), style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                     PopupMenuItem<ActionCreateNoteEnum>(
                      value: ActionCreateNoteEnum.create,
                      child: ListTile(
                        leading: const FaIcon(FontAwesomeIcons.plus),
                        title: Text(CommonLanguages.convert(
                            lang: settingNotifier.languageString ??
                                CommonLanguages.languageStringDefault(),
                            word: 'button.title.createNote'), style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
        ],
      );
  }

  AppBar _buildAppBar(BuildContext context, SettingNotifier settingNotifier) {
    return AppBar(
      iconTheme: IconThemeData(
        color: ThemeDataCenter.getScreenTitleTextColor(context),
        size: 26,
      ),
      leading: _buildAppbarLeading(context, settingNotifier),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CoreElevatedButton.iconOnly(
            buttonAudio: commonAudioOnPressButton,
            icon: const Icon(Icons.home_rounded, size: 25.0),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(
                          title: 'Hi Notes',
                        )),
                (route) => false,
              );
            },
            coreButtonStyle:
                ThemeDataCenter.getCoreScreenButtonStyle(context: context),
          ),
        )
      ],
      backgroundColor: settingNotifier.isSetBackgroundImage == true  ? Colors.transparent : ThemeDataCenter.getBackgroundColor(context),
      title: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: CommonStyles.titleScreenDecorationStyle(settingNotifier.isSetBackgroundImage),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                          CommonLanguages.convert(lang: settingNotifier.languageString ?? CommonLanguages.languageStringDefault(), word: 'screen.title.notes'),
                        style: CommonStyles.screenTitleTextStyle(
                          fontSize: 20.0,
                            color: ThemeDataCenter.getScreenTitleTextColor(context))
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Tooltip(
              message: CommonLanguages.convert(
                  lang: settingNotifier
                      .languageString ??
                      CommonLanguages
                          .languageStringDefault(),
                  word:
                  'tooltip.button.calendar'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: settingNotifier.isSetBackgroundImage == true
                      ? Colors.white.withOpacity(0.65)
                          : Colors.transparent,
                      border: Border.all(
                        color: ThemeDataCenter.getFilteringTextColorStyle(context),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        size: 22,
                        color:
                            ThemeDataCenter.getFilteringTextColorStyle(context),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _filterByDate = !_filterByDate;

                      if (!_filterByDate) {
                        if  (_noteConditionModel.createdAtStartOfDay != null && _noteConditionModel.createdAtEndOfDay != null) {
                          _noteConditionModel.createdAtStartOfDay = null;
                          _noteConditionModel.createdAtEndOfDay = null;

                          /*
                        Reset Table Calendar
                         */
                          _selectedDay = null;
                          _focusedDay = DateTime.now();
                          _rangeStart = null;
                          _rangeEnd = null;

                          _reloadPage();
                        }
                      }
                    });
                  },
                ),
              ),
            ),
            Tooltip(
              message: CommonLanguages.convert(
                  lang: settingNotifier
                      .languageString ??
                      CommonLanguages
                          .languageStringDefault(),
                  word:
                  'tooltip.button.subjectsHome'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: settingNotifier.isSetBackgroundImage == true
                      ? Colors.white.withOpacity(0.65)
                          : Colors.transparent,
                      border: Border.all(
                        color: ThemeDataCenter.getFilteringTextColorStyle(context),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.color_lens_rounded,
                        size: 22,
                        color:
                            ThemeDataCenter.getFilteringTextColorStyle(context),
                      ),
                    ),
                  ),
                  onTap: () {
                    try {
                      setState(() {
                        _filterBySubject = !_filterBySubject;

                        if (!_filterBySubject) {
                          if (filteredSubject != null && _noteConditionModel.subjectId != null) {
                            filteredSubject = null;
                            _noteConditionModel.subjectId = null;

                            _reloadPage();
                          }
                        }
                      });
                    } catch (exception) {
                      CoreNotification.showMessage(context, settingNotifier,
                          CoreNotificationStatus.warning, 'System error!');
                    }
                  },
                ),
              ),
            ),
            _isFiltering()
                ? Tooltip(
                    message: CommonLanguages.convert(
                        lang: settingNotifier
                            .languageString ??
                            CommonLanguages
                                .languageStringDefault(),
                        word:
                        'tooltip.button.filter'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          child: AvatarGlow(
                            glowRadiusFactor: 0.5,
                            curve: Curves.linearToEaseOut,
                            child: Icon(
                              Icons.filter_alt_rounded,
                              size: 22,
                              color: ThemeDataCenter.getFilteringTextColorStyle(
                                  context),
                            ),
                          ),
                          onTap: () async {
                            await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) =>
                                    _filterPopup(context, settingNotifier));
                          },
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
      titleSpacing: 0,
    );
  }
}
