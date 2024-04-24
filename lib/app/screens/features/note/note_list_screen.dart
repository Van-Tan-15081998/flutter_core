import 'dart:convert';
import 'dart:ffi';
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
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/common/themes/ThemeDataCenter.dart';
import '../../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../home/home_screen.dart';
import '../label/databases/label_db_manager.dart';
import '../label/models/label_model.dart';
import '../subjects/databases/subject_db_manager.dart';
import '../subjects/models/subject_model.dart';
import 'databases/note_db_manager.dart';
import 'models/note_condition_model.dart';
import 'models/note_model.dart';
import 'note_create_screen.dart';
import 'providers/note_notifier.dart';
import 'widgets/note_widget.dart';

class NoteListScreen extends StatefulWidget {
  final NoteConditionModel? noteConditionModel;

  const NoteListScreen({super.key, required this.noteConditionModel});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
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
  bool _filterByRecentlyUpdated = false;
  bool _filterByFavourite = false;

  List<LabelModel>? labelList = [];
  List<SubjectModel>? subjectList = [];

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
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longPressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final _today = DateTime.now();
  final _firstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final _lastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

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
    _fetchLabels().then((labels) {
      if (labels != null && labels.isNotEmpty) {
        setState(() {
          labelList = labels;
        });
      }
    });
    _fetchSubjects().then((subjects) {
      if (subjects != null && subjects.isNotEmpty) {
        subjectList = subjects;
      }
    });

    // Init Condition
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
  }

  /*
  Get Labels From DB
   */
  Future<List<LabelModel>?> _fetchLabels() async {
    labelList = await LabelDatabaseManager.all();

    return labelList;
  }

  /*
  Get Subjects From DB
   */
  Future<List<SubjectModel>?> _fetchSubjects() async {
    subjectList = await SubjectDatabaseManager.all();

    return subjectList;
  }

  /*
  Get note's labels
   */
  List<LabelModel>? _getNoteLabels(String jsonLabelIds) {
    List<LabelModel>? noteLabels = [];
    List<dynamic> labelIds = jsonDecode(jsonLabelIds);

    // noteLabels = context
    //     .watch<LabelNotifier>()
    //     .labels!
    //     .where((model) => labelIds.contains(model.id))
    //     .toList();

    if (labelList != null && labelList!.isNotEmpty) {
      noteLabels =
          labelList!.where((model) => labelIds.contains(model.id)).toList();
    }

    return noteLabels;
  }

  /*
    Get note's subject
   */
  SubjectModel? _getNoteSubject(int? subjectId) {
    List<SubjectModel>? subjects = [];

    // if (context.watch<SubjectNotifier>().subjects!.isNotEmpty) {
    //   subjects = context
    //       .watch<SubjectNotifier>()
    //       .subjects!
    //       .where((model) => subjectId == model.id)
    //       .toList();
    // }
    if (subjectList != null && subjectList!.isNotEmpty) {
      subjects = subjectList!.where((model) => subjectId == model.id).toList();
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

      _noteConditionModel.createdAtEndOfDay = null;
      _noteConditionModel.createdAtStartOfDay = null;
      _noteConditionModel.searchText = null;
      _noteConditionModel.isDeleted = null;
      _noteConditionModel.recentlyUpdated = null;
      _noteConditionModel.subjectId = null;
      _noteConditionModel.favourite = null;

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
        _noteConditionModel.favourite == true) {
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
                )));
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteNotifier = Provider.of<NoteNotifier>(context);

    return Scaffold(
      backgroundColor: ThemeDataCenter.getBackgroundColor(context),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.iconOnly(
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
                  ThemeDataCenter.getCoreScreenButtonStyle(context),
            ),
          )
        ],
        backgroundColor: ThemeDataCenter.getBackgroundColor(context),
        title: Text(
          'Notes',
          style: GoogleFonts.montserrat(
              fontStyle: FontStyle.italic,
              fontSize: 30,
              color: const Color(0xFF404040),
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF404040),
        ),
      ),
      body: Column(
        children: [
          _filterByDate
              ? Container(
                  color:
                      ThemeDataCenter.getTableCalendarBackgroundColor(context),
                  child: TableCalendar(
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                  ),
                )
              : Container(),
          Expanded(
            child: Stack(children: [
              PagedListView<int, NoteModel>(
                scrollController: _scrollController,
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<NoteModel>(
                  animateTransitions: true,
                  transitionDuration: const Duration(milliseconds: 500),
                  itemBuilder: (context, item, index) => NoteWidget(
                      index: index + 1,
                      note: item,
                      labels: _getNoteLabels(item.labels!),
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

                            CoreNotification.show(
                                context,
                                CoreNotificationStatus.success,
                                CoreNotificationAction.delete,
                                'Note');
                          } else {
                            CoreNotification.show(
                                context,
                                CoreNotificationStatus.error,
                                CoreNotificationAction.delete,
                                'Note');
                          }
                        });
                      },
                      onDeleteForever: () async {
                        if (await CoreHelperWidget.confirmFunction(context)) {
                          _onDeleteNoteForever(context, item).then((result) {
                            if (result) {
                              noteNotifier.onCountAll();

                              setState(() {
                                _pagingController.itemList!.remove(item);
                              });

                              CoreNotification.show(
                                  context,
                                  CoreNotificationStatus.success,
                                  CoreNotificationAction.delete,
                                  'Note');
                            } else {
                              CoreNotification.show(
                                  context,
                                  CoreNotificationStatus.error,
                                  CoreNotificationAction.delete,
                                  'Note');
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

                            CoreNotification.show(
                                context,
                                CoreNotificationStatus.success,
                                CoreNotificationAction.restore,
                                'Note');
                          } else {
                            CoreNotification.show(
                                context,
                                CoreNotificationStatus.error,
                                CoreNotificationAction.restore,
                                'Note');
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

                            // CoreNotification.show(
                            //     context,
                            //     CoreNotificationStatus.success,
                            //     CoreNotificationAction.update,
                            //     'Note');
                            CommonAudioOnPressButton audio =
                                CommonAudioOnPressButton();
                            audio.playAudioOnFavourite();
                          } else {
                            CoreNotification.show(
                                context,
                                CoreNotificationStatus.error,
                                CoreNotificationAction.update,
                                'Note');
                          }
                        });
                      },
                    onFilterBySubject: () {
                        if (item.subjectId != null) {
                          setState(() {
                            _noteConditionModel.subjectId = item.subjectId;
                          });

                          _reloadPage();
                        }
                    },
                  ),
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Text('Error loading data!',
                        style: TextStyle(
                            color: ThemeDataCenter.getAloneTextColorStyle(
                                context))),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text('No items found.',
                        style: TextStyle(
                            color: ThemeDataCenter.getAloneTextColorStyle(
                                context))),
                  ),
                ),
              ),
              _isFiltering()
                  ? Positioned(
                      top: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          BounceInLeft(
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 180.0,
                              decoration:
                                  ThemeDataCenter.getFilteringLabelStyle(
                                      context),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: Text('Filtering...',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: ThemeDataCenter
                                              .getFilteringTextColorStyle(
                                                  context),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: CoreBottomNavigationBar(
        backgroundColor: ThemeDataCenter.getBackgroundColor(context),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CoreElevatedButton(
                onPressed: () {
                  _resetConditions();
                },
                coreButtonStyle:
                    ThemeDataCenter.getCoreScreenButtonStyle(context),
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CoreTextFormField(
                                            style: TextStyle(
                                                color: ThemeDataCenter
                                                    .getAloneTextColorStyle(
                                                        context)),
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
                                            icon: Icon(Icons.edit,
                                                color: ThemeDataCenter
                                                    .getFormFieldLabelColorStyle(
                                                        context)),
                                            label: 'Search',
                                            labelColor: ThemeDataCenter
                                                .getFormFieldLabelColorStyle(
                                                    context),
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
                                            icon:
                                                const Icon(Icons.close_rounded),
                                            onPressed: () {
                                              if (_searchController
                                                  .text.isNotEmpty) {
                                                setState(() {
                                                  _searchController.text = "";
                                                  _searchText = "";
                                                  _noteConditionModel
                                                      .searchText = _searchText;
                                                });
                                                // Reload Page
                                                _reloadPage();
                                              }
                                            },
                                            coreButtonStyle: ThemeDataCenter
                                                .getCoreScreenButtonStyle(
                                                    context)),
                                        CoreElevatedButton.iconOnly(
                                            icon: const Icon(
                                                Icons.search_rounded),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  // Set Condition
                                                  if (_searchController
                                                      .text.isNotEmpty) {
                                                    _noteConditionModel
                                                            .searchText =
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
                                                .getCoreScreenButtonStyle(
                                                    context)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                coreButtonStyle:
                    ThemeDataCenter.getCoreScreenButtonStyle(context),
                child: const Icon(
                  Icons.search,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () async {
                  await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => Form(
                            child: CoreBasicDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text('Date created',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByDate,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByDate = value!;

                                                  if (!_filterByDate) {
                                                    _noteConditionModel
                                                            .createdAtStartOfDay =
                                                        null;
                                                    _noteConditionModel
                                                            .createdAtEndOfDay =
                                                        null;
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                    }),
                                    const SizedBox(height: 20.0),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text('Notes in the trash',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByDeleted,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByDeleted = value!;
                                                  if (_filterByDeleted) {
                                                    _noteConditionModel
                                                            .isDeleted =
                                                        _filterByDeleted;
                                                  } else {
                                                    _noteConditionModel
                                                        .isDeleted = null;
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                    }),
                                    const SizedBox(height: 20.0),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text('Favourite notes',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByFavourite,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByFavourite = value!;
                                                  if (_filterByFavourite) {
                                                    _noteConditionModel
                                                            .favourite =
                                                        _filterByFavourite;
                                                  } else {
                                                    _noteConditionModel
                                                        .favourite = null;
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                    }),
                                    const SizedBox(height: 20.0),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text('Recently Updated',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByRecentlyUpdated,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByRecentlyUpdated =
                                                      value!;
                                                  if (_filterByRecentlyUpdated) {
                                                    _noteConditionModel
                                                            .recentlyUpdated =
                                                        _filterByRecentlyUpdated;
                                                  } else {
                                                    _noteConditionModel
                                                        .recentlyUpdated = null;
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                    }),
                                    const SizedBox(height: 20.0),
                                    CoreElevatedButton.iconOnly(
                                      onPressed: () {
                                        setState(() {
                                          /// Reload Data
                                          _reloadPage();

                                          /// Close Dialog
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      coreButtonStyle: ThemeDataCenter
                                          .getCoreScreenButtonStyle(context),
                                      icon: const Icon(Icons.check_rounded,
                                          size: 25.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                coreButtonStyle:
                    ThemeDataCenter.getCoreScreenButtonStyle(context),
                child: const Icon(
                  Icons.filter_list_alt,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NoteCreateScreen(
                            note: null,
                            copyNote: null,
                            subject: null,
                            actionMode: ActionModeEnum.create)),
                  );
                },
                coreButtonStyle:
                    ThemeDataCenter.getCoreScreenButtonStyle(context),
                child: const Icon(
                  Icons.add,
                  size: 25.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
