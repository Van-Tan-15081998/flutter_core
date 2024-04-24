import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
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
import '../note/models/note_model.dart';
import '../note/note_create_screen.dart';
import '../subjects/databases/subject_db_manager.dart';
import '../subjects/models/subject_model.dart';
import 'databases/template_db_manager.dart';
import 'models/template_condition_model.dart';
import 'models/template_model.dart';
import 'providers/template_notifier.dart';
import 'template_create_screen.dart';
import 'widgets/template_widget.dart';

class TemplateListScreen extends StatefulWidget {
  final TemplateConditionModel? templateConditionModel;

  const TemplateListScreen({super.key, required this.templateConditionModel});

  @override
  State<TemplateListScreen> createState() => _TemplateListScreenState();
}

class _TemplateListScreenState extends State<TemplateListScreen> {
  final ScrollController _scrollController = ScrollController();

  /*
   Parameters For Search & Filter
   */
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchText = "";
  bool _filterByDeleted = false;
  bool _filterByRecentlyUpdated = false;
  bool _filterByFavourite = false;

  List<LabelModel>? labelList = [];
  List<SubjectModel>? subjectList = [];

  /*
   Parameters For Pagination
   */
  static const _pageSize = 10;
  final PagingController<int, TemplateModel> _pagingController =
      PagingController(firstPageKey: 0);

  final CorePaginationModel _corePaginationModel =
      CorePaginationModel(currentPageIndex: 0, itemPerPage: _pageSize);
  TemplateConditionModel _templateConditionModel = TemplateConditionModel();

  /*
  Function fetch page data
   */
  Future<List<TemplateModel>> _onFetchPage(int pageKey) async {
    try {
      List<TemplateModel>? result = [];
      result = await TemplateDatabaseManager.onGetTemplatePagination(
          _corePaginationModel, _templateConditionModel);

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
    if (widget.templateConditionModel != null) {
      _templateConditionModel = widget.templateConditionModel!;
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
  Get template's labels
   */
  List<LabelModel>? _getTemplateLabels(String jsonLabelIds) {
    List<LabelModel>? templateLabels = [];
    List<dynamic> labelIds = jsonDecode(jsonLabelIds);

    // templateLabels = context
    //     .watch<LabelNotifier>()
    //     .labels!
    //     .where((model) => labelIds.contains(model.id))
    //     .toList();

    if (labelList != null && labelList!.isNotEmpty) {
      templateLabels =
          labelList!.where((model) => labelIds.contains(model.id)).toList();
    }

    return templateLabels;
  }

  /*
    Get template's subject
   */
  SubjectModel? _getTemplateSubject(int? subjectId) {
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
  Reset conditions - TemplateConditionModel templateConditionModel
   */
  _resetConditions() {
    setState(() {
      _searchText = "";
      _searchController.text = "";
      _filterByDeleted = false;
      _filterByFavourite = false;
      _filterByRecentlyUpdated = false;

      _templateConditionModel.searchText = null;
      _templateConditionModel.isDeleted = null;
      _templateConditionModel.recentlyUpdated = null;
      _templateConditionModel.subjectId = null;
      _templateConditionModel.favourite = null;

      _reloadPage();
    });
  }

  /*
  Check is filtering
   */
  bool _isFiltering() {
    if ((_templateConditionModel.searchText != null &&
            _templateConditionModel.searchText != "") ||
        _templateConditionModel.isDeleted == true ||
        _templateConditionModel.recentlyUpdated == true ||
        _templateConditionModel.subjectId != null ||
        _templateConditionModel.favourite == true) {
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

  _onUpdateTemplate(BuildContext context, TemplateModel template) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TemplateCreateScreen(
                  template: template,
                  subject: null,
                  actionMode: ActionModeEnum.update,
                )));
  }

  _onCreateNoteFromTemplate(
      BuildContext context, TemplateModel template) async {
    NoteModel noteFromTemplate = NoteModel.fromJson(template.toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteCreateScreen(
                  note: null,
                  copyNote: noteFromTemplate,
                  subject: null,
                  actionMode: ActionModeEnum.copy,
                )));
  }

  Future<bool> _onDeleteTemplate(
      BuildContext context, TemplateModel template) async {
    return await TemplateDatabaseManager.delete(
        template, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteTemplateForever(
      BuildContext context, TemplateModel template) async {
    return await TemplateDatabaseManager.deleteForever(template);
  }

  Future<bool> _onRestoreTemplateFromTrash(
      BuildContext context, TemplateModel template) async {
    return await TemplateDatabaseManager.restoreFromTrash(
        template, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onFavouriteTemplate(
      BuildContext context, TemplateModel template) async {
    return await TemplateDatabaseManager.favourite(
        template,
        template.isFavourite == null
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
    final templateNotifier = Provider.of<TemplateNotifier>(context);

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
          'Templates',
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
      body: Stack(children: [
        PagedListView<int, TemplateModel>(
          scrollController: _scrollController,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<TemplateModel>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 500),
            itemBuilder: (context, item, index) => TemplateWidget(
              index: index + 1,
              template: item,
              labels: _getTemplateLabels(item.labels!),
              subject: _getTemplateSubject(item.subjectId),
              onUpdate: () {
                _onUpdateTemplate(context, item);
              },
              onDelete: () {
                _onDeleteTemplate(context, item).then((result) {
                  if (result) {
                    templateNotifier.onCountAll();

                    setState(() {
                      _pagingController.itemList!.remove(item);
                    });

                    CoreNotification.show(
                        context,
                        CoreNotificationStatus.success,
                        CoreNotificationAction.delete,
                        'Template');
                  } else {
                    CoreNotification.show(context, CoreNotificationStatus.error,
                        CoreNotificationAction.delete, 'Template');
                  }
                });
              },
              onDeleteForever: () async {
                if (await CoreHelperWidget.confirmFunction(context)) {
                  _onDeleteTemplateForever(context, item).then((result) {
                    if (result) {
                      templateNotifier.onCountAll();

                      setState(() {
                        _pagingController.itemList!.remove(item);
                      });

                      CoreNotification.show(
                          context,
                          CoreNotificationStatus.success,
                          CoreNotificationAction.delete,
                          'Template');
                    } else {
                      CoreNotification.show(
                          context,
                          CoreNotificationStatus.error,
                          CoreNotificationAction.delete,
                          'Template');
                    }
                  });
                }
              },
              onRestoreFromTrash: () {
                _onRestoreTemplateFromTrash(context, item).then((result) {
                  if (result) {
                    templateNotifier.onCountAll();

                    setState(() {
                      _pagingController.itemList!.remove(item);
                    });

                    CoreNotification.show(
                        context,
                        CoreNotificationStatus.success,
                        CoreNotificationAction.restore,
                        'Template');
                  } else {
                    CoreNotification.show(context, CoreNotificationStatus.error,
                        CoreNotificationAction.restore, 'Template');
                  }
                });
              },
              onFavourite: () {
                _onFavouriteTemplate(context, item).then((result) {
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
                    //     'Template');
                    CommonAudioOnPressButton audio = CommonAudioOnPressButton();
                    audio.playAudioOnFavourite();
                  } else {
                    CoreNotification.show(context, CoreNotificationStatus.error,
                        CoreNotificationAction.update, 'Template');
                  }
                });
              },
              onCreateNoteFromTemplate: () {
                _onCreateNoteFromTemplate(context, item);
              },
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Text('Error loading data!',
                  style: TextStyle(
                      color: ThemeDataCenter.getAloneTextColorStyle(context))),
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text('No items found.',
                  style: TextStyle(
                      color: ThemeDataCenter.getAloneTextColorStyle(context))),
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
                            ThemeDataCenter.getFilteringLabelStyle(context),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text('Filtering...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: ThemeDataCenter
                                        .getFilteringTextColorStyle(context),
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
                                            placeholder: 'Search on templates',
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
                                                  _templateConditionModel
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
                                          icon:
                                              const Icon(Icons.search_rounded),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                // Set Condition
                                                if (_searchController
                                                    .text.isNotEmpty) {
                                                  _templateConditionModel
                                                      .searchText = _searchText;

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
                                                  context),
                                        ),
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
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                  'Templates in the trash',
                                                  style: CommonStyles
                                                      .buttonTextStyle),
                                            ),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByDeleted,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByDeleted = value!;
                                                  if (_filterByDeleted) {
                                                    _templateConditionModel
                                                            .isDeleted =
                                                        _filterByDeleted;
                                                  } else {
                                                    _templateConditionModel
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
                                            Flexible(
                                              child: Text('Favourite templates',
                                                  style: CommonStyles
                                                      .buttonTextStyle),
                                            ),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByFavourite,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByFavourite = value!;
                                                  if (_filterByFavourite) {
                                                    _templateConditionModel
                                                            .favourite =
                                                        _filterByFavourite;
                                                  } else {
                                                    _templateConditionModel
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
                                            Flexible(
                                              child: Text('Recently Updated',
                                                  style: CommonStyles
                                                      .buttonTextStyle),
                                            ),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByRecentlyUpdated,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByRecentlyUpdated =
                                                      value!;
                                                  if (_filterByRecentlyUpdated) {
                                                    _templateConditionModel
                                                            .recentlyUpdated =
                                                        _filterByRecentlyUpdated;
                                                  } else {
                                                    _templateConditionModel
                                                        .recentlyUpdated = null;
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                    }),
                                    const SizedBox(height: 20.0),
                                    CoreElevatedButton.iconOnly(
                                        icon: const FaIcon(
                                            FontAwesomeIcons.check,
                                            size: 25.0),
                                        onPressed: () {
                                          setState(() {
                                            /// Reload Data
                                            _reloadPage();

                                            /// Close Dialog
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        coreButtonStyle: ThemeDataCenter
                                            .getCoreScreenButtonStyle(context)),
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
                        builder: (context) => const TemplateCreateScreen(
                            subject: null, actionMode: ActionModeEnum.create)),
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
