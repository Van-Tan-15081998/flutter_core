import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
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
import '../../../../library/common/dimensions/CommonDimensions.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../home/home_screen.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'functions/subject_widget.dart';
import 'subject_create_screen.dart';

class SubjectListScreen extends StatefulWidget {
  final SubjectConditionModel? subjectConditionModel;
  final RedirectFromEnum? redirectFrom;
  const SubjectListScreen(
      {super.key,
      required this.subjectConditionModel,
      required this.redirectFrom});

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
                  redirectFromEnum: null,
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

  Widget _filterPopup(BuildContext context) {
    return Form(
      child: CoreBasicDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _subjectConditionModel.searchText != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Search keywords: ',
                                  style: CommonStyles.buttonTextStyle),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                          '"${_subjectConditionModel.searchText!}"',
                                          style: const TextStyle(
                                              color: Color(0xFF1f1f1f),
                                              fontSize: 16.0)),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                      }),
                    )
                  : Container(),
              const SizedBox(height: 20.0),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Root subjects',
                          style: CommonStyles.buttonTextStyle),
                      Checkbox(
                        checkColor: Colors.white,
                        value: _filterByIsRootSubject,
                        onChanged: (bool? value) {
                          setState(() {
                            _filterByIsRootSubject = value!;
                            if (_filterByIsRootSubject) {
                              _subjectConditionModel.isRootSubject =
                                  _filterByIsRootSubject;
                            } else {
                              _subjectConditionModel.isRootSubject = null;
                            }
                          });
                        },
                      ),
                    ]);
              }),
              const SizedBox(height: 20.0),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Subjects in the trash',
                          style: CommonStyles.buttonTextStyle),
                      Checkbox(
                        checkColor: Colors.white,
                        value: _filterByDeleted,
                        onChanged: (bool? value) {
                          setState(() {
                            _filterByDeleted = value!;
                            if (_filterByDeleted) {
                              _subjectConditionModel.isDeleted =
                                  _filterByDeleted;
                            } else {
                              _subjectConditionModel.isDeleted = null;
                            }
                          });
                        },
                      ),
                    ]);
              }),
              const SizedBox(height: 20.0),
              CoreElevatedButton.iconOnly(
                  icon: const FaIcon(FontAwesomeIcons.check, size: 25.0),
                  onPressed: () {
                    setState(() {
                      /// Reload Data
                      _reloadPage();

                      /// Close Dialog
                      Navigator.of(context).pop();
                    });
                  },
                  coreButtonStyle: ThemeDataCenter.getCoreScreenButtonStyle(
                      context: context)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _onPopAction(BuildContext context) {
    if (widget.redirectFrom == RedirectFromEnum.notes) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else if (widget.redirectFrom == null) {
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
    return IconButton(
      style: CommonStyles.appbarLeadingBackButtonStyle(whiteBlur: settingNotifier.isSetBackgroundImage == true ? true : false),
      icon: const FaIcon(FontAwesomeIcons.chevronLeft),
      onPressed: () {
        _onPopAction(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectNotifier = Provider.of<SubjectNotifier>(context);
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return WillPopScope(
      onWillPop: () async {
        _onPopAction(context);
        return Navigator.canPop(context);
      },
      child: Scaffold(
        extendBodyBehindAppBar:
            settingNotifier.isSetBackgroundImage == true ? true : false,
        backgroundColor: settingNotifier.isSetBackgroundImage == true
            ? Colors.transparent
            : ThemeDataCenter.getBackgroundColor(context),
        appBar: _buildAppBar(context, settingNotifier),
        body: settingNotifier.isSetBackgroundImage == true
            ? DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          settingNotifier.backgroundImageSourceString ??
                              CommonStyles.backgroundImageSourceStringDefault()),
                      fit: BoxFit.cover),
                ),
                child: _buildBody(subjectNotifier, settingNotifier),
              )
            : _buildBody(subjectNotifier, settingNotifier),
        bottomNavigationBar: settingNotifier.isSetBackgroundImage == true
            ? null
            : _buildBottomNavigationBar(context),
        floatingActionButton: settingNotifier.isSetBackgroundImage == true
            ? _buildBottomNavigationBarActionList(context)
            : null,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }

  CoreBottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return CoreBottomNavigationBar(
      backgroundColor: ThemeDataCenter.getBackgroundColor(context),
      child: IconTheme(
        data: const IconThemeData(color: Colors.white),
        child: _buildBottomNavigationBarActionList(context),
      ),
    );
  }

  Row _buildBottomNavigationBarActionList(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CoreElevatedButton(
          onPressed: () {
            _resetConditions();
            _reloadPage();
          },
          coreButtonStyle:
              ThemeDataCenter.getCoreScreenButtonStyle(context: context),
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
                                              .getAloneTextColorStyle(context)),
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
                                          .getFormFieldLabelColorStyle(context),
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
                                      if (_searchController.text.isNotEmpty) {
                                        setState(() {
                                          _searchController.text = "";
                                          _searchText = "";
                                          _subjectConditionModel.searchText =
                                              _searchText;
                                        });
                                        // Reload Page
                                        _reloadPage();
                                      }
                                    },
                                    coreButtonStyle: ThemeDataCenter
                                        .getCoreScreenButtonStyle(
                                            context: context),
                                  ),
                                  CoreElevatedButton.iconOnly(
                                    icon: const Icon(Icons.search_rounded),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          if (_searchController
                                              .text.isNotEmpty) {
                                            // Set Condition
                                            _subjectConditionModel.searchText =
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
                                            context: context),
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
              ThemeDataCenter.getCoreScreenButtonStyle(context: context),
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
                builder: (BuildContext context) => _filterPopup(context));
          },
          coreButtonStyle:
              ThemeDataCenter.getCoreScreenButtonStyle(context: context),
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
                        actionMode: ActionModeEnum.create,
                        redirectFromEnum: RedirectFromEnum.subjects,
                      )),
            );
          },
          coreButtonStyle:
              ThemeDataCenter.getCoreScreenButtonStyle(context: context),
          child: const Icon(
            Icons.add,
            size: 25.0,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
      SubjectNotifier subjectNotifier, SettingNotifier settingNotifier) {
    return Column(
      children: [
        settingNotifier.isSetBackgroundImage == true
            ? SizedBox(height: CommonDimensions.scaffoldAppBarHeight(context))
            : Container(),
        Expanded(
          child: PagedListView<int, SubjectModel>(
            padding: EdgeInsets.only(
                top: CommonDimensions.scaffoldAppBarHeight(context) / 5),
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
                                    redirectFromEnum: null,
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
                        color:
                            ThemeDataCenter.getAloneTextColorStyle(context))),
              ),
              noItemsFoundIndicatorBuilder: (context) => Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BounceInLeft(
                        child: FaIcon(FontAwesomeIcons.waze,
                            size: 30.0,
                            color: ThemeDataCenter.getAloneTextColorStyle(
                                context))),
                    const SizedBox(width: 5),
                    BounceInRight(
                      child: Text('No items found!',
                          style: TextStyle(
                              color: ThemeDataCenter.getAloneTextColorStyle(
                                  context))),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                ThemeDataCenter.getCoreScreenButtonStyle(context: context),
          ),
        )
      ],
      backgroundColor: settingNotifier.isSetBackgroundImage == true
          ? Colors.transparent
          : ThemeDataCenter.getBackgroundColor(context),
      title: Row(
        children: [
          Text(
            CommonLanguages.convert(
                lang: settingNotifier.languageString ??
                    CommonLanguages.languageStringDefault(),
                word: 'screen.title.subjects'),
            style: CommonStyles.screenTitleTextStyle(
                color: ThemeDataCenter.getScreenTitleTextColor(context)),
          ),
          _isFiltering()
              ? Tooltip(
                  message: 'Filtering...',
                  child: IconButton(
                      icon: AvatarGlow(
                        glowRadiusFactor: 0.5,
                        curve: Curves.linearToEaseOut,
                        child: Icon(Icons.filter_alt_rounded,
                            color: ThemeDataCenter.getFilteringTextColorStyle(
                                context)),
                      ),
                      onPressed: () async {
                        await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) =>
                                _filterPopup(context));
                      }),
                )
              : Container()
        ],
      ),
    );
  }
}
