import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/models/note_model.dart';
import 'package:flutter_core_v3/app/screens/features/note/widgets/note_widget.dart';
import 'package:flutter_core_v3/app/screens/features/subjects/models/subject_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../core/components/containment/dialogs/CoreConfirmDialog.dart';
import '../../../../core/components/form/CoreTextFormField.dart';
import '../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../core/components/notifications/CoreNotification.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../home/home_screen.dart';
import '../label/models/label_model.dart';
import '../label/providers/label_notifier.dart';
import '../subjects/providers/subject_notifier.dart';
import 'databases/note_db_manager.dart';
import 'models/note_condition_model.dart';
import 'note_create_screen.dart';
import 'providers/note_notifier.dart';
import 'package:intl/intl.dart';

class NoteListScreen extends StatefulWidget {
  final NoteConditionModel? noteConditionModel;

  const NoteListScreen({super.key, required this.noteConditionModel});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> with RestorationMixin {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myFocusNode = FocusNode();
  String searchText = "";
  bool filterByDeleted = false;
  bool filterByDate = false;
  bool filterByRecentlyUpdated = false;

  // pagination
  static const _pageSize = 10;
  final PagingController<int, NoteModel> _pagingController =
      PagingController(firstPageKey: 0);

  CorePaginationModel corePaginationModel =
      CorePaginationModel(currentPageIndex: 0, itemPerPage: _pageSize);
  NoteConditionModel noteConditionModel = NoteConditionModel();

  Future<List<NoteModel>> _fetchPage(int pageKey) async {
    try {
      List<NoteModel>? result = [];
      result = await NoteDatabaseManager.onGetNotePagination(
          corePaginationModel, noteConditionModel);

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

  List<NoteModel> notes = [];
  List<LabelModel> labels = [];

  // Date picker for filter
  @override
  // TODO: implement restorationId
  String? get restorationId => 'main';
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  // Label dropdown for filter
  int? _selectedLabelId;

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.noteConditionModel != null) {
      noteConditionModel = widget.noteConditionModel!;
    }

    // pagination
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey).then((items) {
        if (items.isNotEmpty) {
          final isLastPage = items.length < _pageSize;
          if (isLastPage) {
            _pagingController.appendLastPage(items);
          } else {
            _pagingController.appendPage(items, pageKey + 1);
            corePaginationModel.currentPageIndex++;
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

  getNoteLabels(String jsonLabelIds) {
    List<LabelModel>? noteLabels = [];
    List<dynamic> labelIds = jsonDecode(jsonLabelIds);

    noteLabels = context
        .watch<LabelNotifier>()
        .labels!
        .where((model) => labelIds.contains(model.id))
        .toList();
    return noteLabels;
  }

  getNoteSubject(int? subjectId) {
    List<SubjectModel>? subjects = [];

    if (context.watch<SubjectNotifier>().subjects!.isNotEmpty) {
      subjects = context
          .watch<SubjectNotifier>()
          .subjects!
          .where((model) => subjectId == model.id)
          .toList();
    }

    return subjects.isNotEmpty ? subjects.first : null;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.house, size: 18.0),
              label: Text('Home', style: CommonStyles.buttonTextStyle),
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
              coreButtonStyle: CoreButtonStyle.options(
                  coreStyle: CoreStyle.outlined,
                  coreColor: CoreColor.dark,
                  coreRadius: CoreRadius.radius_6,
                  kitBackgroundColorOption: Colors.white70,
                  kitForegroundColorOption: const Color(0xFF404040),
                  coreFixedSizeButton: CoreFixedSizeButton.medium_40),
            ),
          )
        ],
        backgroundColor: const Color(0xFF202124),
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
      body: PagedListView<int, NoteModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<NoteModel>(
          animateTransitions: true,
          transitionDuration: const Duration(milliseconds: 500),
          itemBuilder: (context, item, index) => NoteWidget(
            note: item,
            labels: getNoteLabels(item.labels!),
            subject: getNoteSubject(item.subjectId),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteCreateScreen(
                            note: item,
                            actionMode: ActionModeEnum.update,
                          )));
              setState(() {});
            },
            onDelete: () async {
              if (await NoteDatabaseManager.delete(
                  item, DateTime.now().millisecondsSinceEpoch)) {
                Provider.of<NoteNotifier>(context, listen: false).onCountAll();

                setState(() {
                  _pagingController.itemList!.remove(item);
                });

                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.delete, 'Note');
              }
            },
            onDeleteForever: () async {
              if (await CoreHelperWidget.confirmFunction(context)) {
                if (await NoteDatabaseManager.deleteForever(
                    item)) {
                  Provider.of<NoteNotifier>(context, listen: false).onCountAll();

                  setState(() {
                    _pagingController.itemList!.remove(item);
                  });

                  CoreNotification.show(context, CoreNotificationStatus.success,
                      CoreNotificationAction.delete, 'Note');
                }
              }
            },
            onRestoreFromTrash: () async {
              if (await NoteDatabaseManager.restoreFromTrash(
                  item, DateTime.now().millisecondsSinceEpoch)) {
                Provider.of<NoteNotifier>(context, listen: false).onCountAll();

                setState(() {
                  _pagingController.itemList!.remove(item);
                });

                CoreNotification.show(context, CoreNotificationStatus.success,
                    CoreNotificationAction.restore, 'Note');
              }
            },
          ),
          firstPageErrorIndicatorBuilder: (context) => const Center(
            child: Text('Error loading data!',
                style: TextStyle(color: Colors.white54)),
          ),
          noItemsFoundIndicatorBuilder: (context) => const Center(
            child: Text('No items found.',
                style: TextStyle(color: Colors.white54)),
          ),
        ),
      ),
      bottomNavigationBar: CoreBottomNavigationBar(
        backgroundColor: const Color(0xFF202124),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CoreElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const NoteListScreen(noteConditionModel: null)),
                        (route) => false,
                  );
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.home_rounded,
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
                                            onChanged: (String value) {
                                              setState(() {
                                                searchText = value.trim();
                                              });
                                            },
                                            controller: myController,
                                            focusNode: myFocusNode,
                                            onValidator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return const Text(
                                                    'Please enter your search string',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent));
                                              }
                                              return null;
                                            },
                                            maxLength: null,
                                            icon: const Icon(Icons.edit,
                                                color: Colors.black54),
                                            label: 'Search',
                                            labelColor: Colors.black54,
                                            placeholder: 'Search on notes',
                                            helper: 'Enter your search string',
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
                                          icon: const FaIcon(
                                              FontAwesomeIcons.xmark,
                                              color: Color(0xFF404040),
                                              size: 24.0),
                                          onPressed: () {
                                            setState(() {
                                              searchText = "";
                                              myController.text = searchText;
                                              noteConditionModel.searchText =
                                                  searchText;
                                            });
                                          },
                                          coreButtonStyle:
                                              CoreButtonStyle.options(
                                                  coreStyle: CoreStyle.filled,
                                                  coreColor: CoreColor.stormi,
                                                  coreRadius:
                                                      CoreRadius.radius_6,
                                                  kitForegroundColorOption:
                                                      Colors.black,
                                                  coreFixedSizeButton:
                                                      CoreFixedSizeButton
                                                          .medium_48),
                                        ),
                                        CoreElevatedButton.iconOnly(
                                          icon: const FaIcon(
                                              FontAwesomeIcons.magnifyingGlass,
                                              color: Color(0xFF404040),
                                              size: 24.0),
                                          onPressed: () {
                                            setState(() {
                                              // Set Condition
                                              noteConditionModel.searchText =
                                                  searchText;

                                              // Reload Data
                                              corePaginationModel
                                                  .currentPageIndex = 0;
                                              _pagingController.refresh();

                                              // Close Dialog
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          coreButtonStyle:
                                              CoreButtonStyle.options(
                                                  coreStyle: CoreStyle.filled,
                                                  coreColor: CoreColor.success,
                                                  coreRadius:
                                                      CoreRadius.radius_6,
                                                  kitForegroundColorOption:
                                                      Colors.black,
                                                  coreFixedSizeButton:
                                                      CoreFixedSizeButton
                                                          .medium_48),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
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
                                            CoreElevatedButton.icon(
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.calendarDay,
                                                  size: 18.0),
                                              label: Text('Date',
                                                  style: CommonStyles
                                                      .buttonTextStyle),
                                              onPressed: () {
                                                _restorableDatePickerRouteFuture
                                                    .present();
                                              },
                                              coreButtonStyle:
                                                  CoreButtonStyle.options(
                                                coreStyle: CoreStyle.filled,
                                                coreColor: CoreColor.info,
                                                coreRadius: CoreRadius.radius_6,
                                                kitForegroundColorOption:
                                                    Colors.black,
                                                coreFixedSizeButton:
                                                    CoreFixedSizeButton
                                                        .medium_48,
                                              ),
                                            ),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: filterByDate,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  filterByDate = value!;
                                                  if (filterByDate) {
                                                    noteConditionModel
                                                        .createdAtStartOfDay = DateTime(
                                                            _selectedDate
                                                                .value.year,
                                                            _selectedDate
                                                                .value.month,
                                                            _selectedDate
                                                                .value.day)
                                                        .millisecondsSinceEpoch;
                                                    noteConditionModel
                                                        .createdAtEndOfDay = DateTime(
                                                            _selectedDate
                                                                .value.year,
                                                            _selectedDate
                                                                .value.month,
                                                            _selectedDate
                                                                .value.day,
                                                            23,
                                                            59,
                                                            59,
                                                            999)
                                                        .millisecondsSinceEpoch;
                                                    noteConditionModel.labelId =
                                                        _selectedLabelId;
                                                  } else {
                                                    noteConditionModel
                                                            .createdAtStartOfDay =
                                                        null;
                                                    noteConditionModel
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
                                            Text('Deleted',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: filterByDeleted,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  filterByDeleted = value!;
                                                  if (filterByDeleted) {
                                                    noteConditionModel.isDeleted =
                                                        filterByDeleted;
                                                  } else {
                                                    noteConditionModel.isDeleted =
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
                                            Text('Recently Updated',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: filterByRecentlyUpdated,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  filterByRecentlyUpdated = value!;
                                                  if (filterByRecentlyUpdated) {
                                                    noteConditionModel.recentlyUpdated =
                                                        filterByRecentlyUpdated;
                                                  } else {
                                                    noteConditionModel.recentlyUpdated =
                                                        null;
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                    }),
                                    const SizedBox(height: 20.0),
                                    CoreElevatedButton.icon(
                                      icon: const FaIcon(FontAwesomeIcons.check,
                                          size: 18.0),
                                      label: Text('OK',
                                          style: CommonStyles.buttonTextStyle),
                                      onPressed: () {
                                        setState(() {
                                          // Reload Data
                                          corePaginationModel.currentPageIndex =
                                              0;
                                          _pagingController.refresh();

                                          // Close Dialog
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      coreButtonStyle: CoreButtonStyle.options(
                                          coreStyle: CoreStyle.filled,
                                          coreColor: CoreColor.success,
                                          coreRadius: CoreRadius.radius_6,
                                          kitForegroundColorOption:
                                              Colors.black,
                                          coreFixedSizeButton:
                                              CoreFixedSizeButton.medium_48),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
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
                            actionMode: ActionModeEnum.create)),
                  );
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
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
