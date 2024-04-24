import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../home/home_screen.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'functions/subject_widget.dart';
import 'subject_create_screen.dart';

class SubjectListScreen extends StatefulWidget {
  final SubjectConditionModel? subjectConditionModel;
  const SubjectListScreen({super.key, required this.subjectConditionModel});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  List<SubjectModel> subjects = [];
  final ScrollController _scrollController = ScrollController();

  /*
   Parameters For Search & Filter
   */
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchText = "";
  bool _filterByDeleted = false;
  bool _filterByIsRootSubject = false;

  /*
   Pagination Parameters
   */
  static const _pageSize = 10;
  final PagingController<int, SubjectModel> _pagingController =
      PagingController(firstPageKey: 0);

  final CorePaginationModel _corePaginationModel =
      CorePaginationModel(currentPageIndex: 0, itemPerPage: _pageSize);
  SubjectConditionModel _subjectConditionModel = SubjectConditionModel();

  Future<List<SubjectModel>> _fetchPage(int pageKey) async {
    try {
      List<SubjectModel>? result = [];
      result = await SubjectDatabaseManager.onGetSubjectPagination(
          _corePaginationModel, _subjectConditionModel);

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

  /*
  Reorganize when filter get children by parent
   */
  bool isSubSubject(SubjectModel subject) {
    if (_subjectConditionModel.parentId != null &&
        subject.parentId == _subjectConditionModel.parentId) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.subjectConditionModel != null) {
      _subjectConditionModel = widget.subjectConditionModel!;
    }

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey).then((items) {
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

  _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /*
  Reset conditions - NoteConditionModel noteConditionModel
   */
  _resetConditions() {
    setState(() {
      _searchController.text = "";
      _searchText = "";
      _filterByDeleted = false;
      _filterByIsRootSubject = false;

      _subjectConditionModel.id = null;
      _subjectConditionModel.searchText = null;
      _subjectConditionModel.isDeleted = null;
      _subjectConditionModel.parentId = null;
      _subjectConditionModel.isRootSubject = null;

      _reloadPage();
    });
  }

  /*
  Check is filtering
   */
  bool _isFiltering() {
    if (_subjectConditionModel.id != null ||
        (_subjectConditionModel.searchText != null &&
            _subjectConditionModel.searchText != "") ||
        _subjectConditionModel.isDeleted == true ||
        _subjectConditionModel.parentId != null ||
        _subjectConditionModel.isRootSubject == true) {
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

  _onUpdateSubject(BuildContext context, SubjectModel subject) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubjectCreateScreen(
                  subject: subject,
                  parentSubject: null,
                  actionMode: ActionModeEnum.update,
                )));
  }

  Future<bool> _onDeleteSubject(
      BuildContext context, SubjectModel subject) async {
    return await SubjectDatabaseManager.delete(
        subject, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteSubjectForever(
      BuildContext context, SubjectModel subject) async {
    return await SubjectDatabaseManager.deleteForever(subject);
  }

  Future<bool> _onRestoreSubjectFromTrash(
      BuildContext context, SubjectModel subject) async {
    return await SubjectDatabaseManager.restoreFromTrash(
        subject, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjectNotifier = Provider.of<SubjectNotifier>(context);

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
          'Subjects',
          style: GoogleFonts.montserrat(
              fontStyle: FontStyle.italic,
              fontSize: 30,
              color: const Color(0xFF404040),
              fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF404040), // Set the color you desire
        ),
      ),
      body: Stack(children: [
        PagedListView<int, SubjectModel>(
          scrollController: _scrollController,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<SubjectModel>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 500),
            itemBuilder: (context, item, index) {
              return SubjectWidget(
                  index: index + 1,
                  key: ValueKey<int>(item.id!),
                  subject: item,
                  isSubSubject: isSubSubject(item),
                  onUpdate: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubjectCreateScreen(
                                  subject: item,
                                  parentSubject: null,
                                  actionMode: ActionModeEnum.update,
                                )));
                    setState(() {});
                  },
                  onDelete: () {
                    _onDeleteSubject(context, item).then((result) {
                      if (result) {
                        subjectNotifier.onCountAll();

                        setState(() {
                          _pagingController.itemList!.remove(item);
                        });

                        if (_subjectConditionModel.parentId != null) {
                          _reloadPage();
                        }

                        CoreNotification.show(
                            context,
                            CoreNotificationStatus.success,
                            CoreNotificationAction.delete,
                            'Subject');
                      } else {
                        CoreNotification.show(
                            context,
                            CoreNotificationStatus.error,
                            CoreNotificationAction.delete,
                            'Subject');
                      }
                    });
                  },
                  onDeleteForever: () async {
                    if (await CoreHelperWidget.confirmFunction(context)) {
                      _onDeleteSubjectForever(context, item).then((result) {
                        if (result) {
                          subjectNotifier.onCountAll();

                          setState(() {
                            _pagingController.itemList!.remove(item);
                          });

                          CoreNotification.show(
                              context,
                              CoreNotificationStatus.success,
                              CoreNotificationAction.delete,
                              'Subject');
                        } else {
                          CoreNotification.show(
                              context,
                              CoreNotificationStatus.error,
                              CoreNotificationAction.delete,
                              'Subject');
                        }
                      });
                    }
                  },
                  onRestoreFromTrash: () {
                    _onRestoreSubjectFromTrash(context, item).then((result) {
                      if (result) {
                        subjectNotifier.onCountAll();

                        setState(() {
                          _pagingController.itemList!.remove(item);
                        });

                        CoreNotification.show(
                            context,
                            CoreNotificationStatus.success,
                            CoreNotificationAction.restore,
                            'Subject');
                      } else {
                        CoreNotification.show(
                            context,
                            CoreNotificationStatus.error,
                            CoreNotificationAction.restore,
                            'Subject');
                      }
                    });
                  },
                  onFilterChildren: () {
                    setState(() {
                      _subjectConditionModel.parentId = item.id;
                      _subjectConditionModel.id = null;
                    });
                    _reloadPage();
                  },
                  onFilterParent: () {
                    setState(() {
                      _subjectConditionModel.id = item.parentId;
                      _subjectConditionModel.parentId = null;
                    });
                    _reloadPage();
                  });
            },
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
                  _reloadPage();
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
                                            placeholder: 'Search on subjects',
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
                                          icon: const Icon(Icons.close_rounded),
                                          onPressed: () {
                                            if (_searchController
                                                .text.isNotEmpty) {
                                              setState(() {
                                                _searchController.text = "";
                                                _searchText = "";
                                                _subjectConditionModel
                                                    .searchText = _searchText;
                                              });
                                              // Reload Page
                                              _reloadPage();
                                            }
                                          },
                                          coreButtonStyle: ThemeDataCenter
                                              .getCoreScreenButtonStyle(
                                                  context),
                                        ),
                                        CoreElevatedButton.iconOnly(
                                          icon:
                                              const Icon(Icons.search_rounded),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                if (_searchController
                                                    .text.isNotEmpty) {
                                                  // Set Condition
                                                  _subjectConditionModel
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
              const SizedBox(width: 5.0),
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
                                            Text('Root subjects',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByIsRootSubject,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByIsRootSubject =
                                                      value!;
                                                  if (_filterByIsRootSubject) {
                                                    _subjectConditionModel
                                                            .isRootSubject =
                                                        _filterByIsRootSubject;
                                                  } else {
                                                    _subjectConditionModel
                                                        .isRootSubject = null;
                                                  }
                                                });
                                              },
                                            ),
                                          ]);
                                    }),
                                    StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text('Subjects in the trash',
                                                style: CommonStyles
                                                    .buttonTextStyle),
                                            Checkbox(
                                              checkColor: Colors.white,
                                              value: _filterByDeleted,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  _filterByDeleted = value!;
                                                  if (_filterByDeleted) {
                                                    _subjectConditionModel
                                                            .isDeleted =
                                                        _filterByDeleted;
                                                  } else {
                                                    _subjectConditionModel
                                                        .isDeleted = null;
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
              const SizedBox(width: 5.0),
              CoreElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SubjectCreateScreen(
                            parentSubject: null,
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
