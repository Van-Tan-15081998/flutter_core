import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/dimensions/CommonDimensions.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../home/home_screen.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../../label/databases/label_db_manager.dart';
import '../../label/models/label_model.dart';
import '../../note/databases/note_db_manager.dart';
import '../../note/models/note_condition_model.dart';
import '../../note/models/note_model.dart';
import '../../note/note_create_screen.dart';
import '../../note/widgets/note_widget.dart';
import '../../note/widgets/small_note_widget.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'functions/subject_widget_folder_item.dart';
import 'subject_create_screen.dart';
import 'subject_detail_folder_item.dart';
import 'subject_list_screen.dart';

class SubjectListFolderModeScreen extends StatefulWidget {
  final SubjectConditionModel? subjectConditionModel;
  final RedirectFromEnum? redirectFrom;
  final List<SubjectModel>? breadcrumb;
  const SubjectListFolderModeScreen(
      {super.key,
      required this.subjectConditionModel,
      required this.redirectFrom,
      required this.breadcrumb});

  @override
  State<SubjectListFolderModeScreen> createState() =>
      _SubjectListFolderModeScreenState();
}

class _SubjectListFolderModeScreenState
    extends State<SubjectListFolderModeScreen> {
  List<LabelModel>? _labelList = [];
  List<SubjectModel>? _subjectList = [];

  List<SubjectModel> subjectFolders = [];
  List<NoteModel> notes = [];
  final ScrollController _breadcrumbScrollController = ScrollController();

  List<SubjectModel> breadcrumb = [];
  SubjectModel? currentParentSubject;
  bool canPop = false;
  /*
   Parameters For Search & Filter
   */
  SubjectConditionModel _subjectConditionModel = SubjectConditionModel();
  NoteConditionModel _noteConditionModel = NoteConditionModel();

  Future<List<SubjectModel>> _fetchPageDataSubject() async {
    try {
      List<SubjectModel>? result = [];

      // Check current subject parent to set condition
      if (currentParentSubject == null) {
        _subjectConditionModel.isRootSubject = true;
        _subjectConditionModel.onlyParentId = null;
      } else {
        _subjectConditionModel.isRootSubject = null;
        _subjectConditionModel.onlyParentId = currentParentSubject!.id;
      }

      result = await SubjectDatabaseManager.onGetSubjectPagination(
          CorePaginationModel(currentPageIndex: 0, itemPerPage: 10000),
          _subjectConditionModel);

      if (result == null) {
        return [];
      }
      return result;
    } catch (error) {
      return [];
    }
  }

  Future<List<NoteModel>> _fetchPageDataNote() async {
    try {
      // Check current subject parent to set condition
      if (currentParentSubject != null) {
        _noteConditionModel.subjectId = currentParentSubject!.id;
        _noteConditionModel.onlyNoneSubject = null;
      } else {
        _noteConditionModel.subjectId = null;
        _noteConditionModel.onlyNoneSubject = true;
      }

      List<NoteModel>? result = [];
      result = await NoteDatabaseManager.onGetNotePagination(
          CorePaginationModel(currentPageIndex: 0, itemPerPage: 10000),
          _noteConditionModel);

      if (result == null) {
        return [];
      }
      return result;
    } catch (error) {
      return [];
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

  void _onInitData() {
    // Fetch Labels and Subjects
    _fetchLabels().then((labelsResult) {
      if (labelsResult != null && labelsResult.isNotEmpty) {
        _labelList = labelsResult;
      }
    });

    _fetchSubjects().then((subjectsResult) {
      if (subjectsResult != null && subjectsResult.isNotEmpty) {
        _subjectList = subjectsResult;
      }
    });

    breadcrumb = widget.breadcrumb ?? [];
    if (breadcrumb.isNotEmpty) {
      currentParentSubject = breadcrumb.last;
    }

    _reloadPage();
  }

  _scrollToLastBreadcrumbItem() {
    if (breadcrumb.isNotEmpty) {
      _breadcrumbScrollController.animateTo(
        _breadcrumbScrollController.position.maxScrollExtent +
            _breadcrumbScrollController.position.viewportDimension,
        duration: const Duration(milliseconds: 500),
        curve: Curves.slowMiddle,
      );
    }
  }

  _resetPage() {
    _resetConditions();
    currentParentSubject = null;
    _reloadPage().then((result) => {
          if (result)
            {
              setState(() {
                breadcrumb = [];
              })
            }
        });
  }

  Future<bool> _reloadPage() async {
    await _fetchPageDataSubject().then((items) async {
      setState(() {
        subjectFolders = items;
      });

      await _fetchPageDataNote().then((items) {
        setState(() {
          notes = items;
        });
      });
    });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.subjectConditionModel != null) {
      _subjectConditionModel = widget.subjectConditionModel!;
    }

    _onInitData();
  }

  /*
  Reset conditions - NoteConditionModel noteConditionModel
   */
  _resetConditions() {
    _subjectConditionModel.id = null;
    _subjectConditionModel.searchText = null;
    _subjectConditionModel.isDeleted = null;
    _subjectConditionModel.parentId = null;
    _subjectConditionModel.isRootSubject = true;
    _subjectConditionModel.onlyParentId = null;

    _noteConditionModel.onlyNoneSubject = null;
    _noteConditionModel.subjectId = null;
  }

  @override
  void dispose() {
    _breadcrumbScrollController.dispose;
    super.dispose();
  }

  void _onChangeToListView() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const SubjectListScreen(
              subjectConditionModel: null,
              redirectFrom: null,
              breadcrumb: null)),
      (route) => false,
    );
  }

  void _onPopAction(BuildContext context) {
    if (breadcrumb.length > 1) {
      currentParentSubject = breadcrumb[breadcrumb.length - 2];

      _reloadPage().then((result) => {
            if (result)
              {
                setState(() {
                  breadcrumb.removeLast();
                })
              }
          });

      return;
    } else if (breadcrumb.length == 1) {
      currentParentSubject = null;

      _reloadPage().then((result) => {
            if (result)
              {
                setState(() {
                  breadcrumb = [];
                })
              }
          });

      return;
    } else if (breadcrumb.isEmpty) {
      canPop = true;
    }
    if (widget.redirectFrom == RedirectFromEnum.notes) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return;
      }
    }
    if (widget.redirectFrom == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen(
                  title: 'Hi Notes',
                )),
        (route) => false,
      );
      return;
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }
  }

  Widget? _buildAppbarLeading(
      BuildContext context, SettingNotifier settingNotifier) {
    return IconButton(
      style: CommonStyles.appbarLeadingBackButtonStyle(
          whiteBlur:
              settingNotifier.isSetBackgroundImage == true ? true : false),
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

    bool reloadPage = subjectNotifier.reloadPage;
    if (reloadPage) {
      _reloadPage();
      subjectNotifier.onResetReloadPage();
    }

    return WillPopScope(
      onWillPop: () async {
        _onPopAction(context);
        return canPop;
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
                      image: AssetImage(settingNotifier
                              .backgroundImageSourceString ??
                          CommonStyles.backgroundImageSourceStringDefault()),
                      fit: BoxFit.cover),
                ),
                child:
                    _buildBodyFolderViewMode(subjectNotifier, settingNotifier))
            : _buildBodyFolderViewMode(subjectNotifier, settingNotifier),
        floatingActionButton:
            _buildFloatingActionCreateButton(context, settingNotifier),
      ),
    );
  }

  Widget _buildFloatingActionCreateButton(
      BuildContext context, SettingNotifier settingNotifier) {
    return AvatarGlow(
      glowRadiusFactor: 0.2,
      curve: Curves.linearToEaseOut,
      child: Tooltip(
        message: CommonLanguages.convert(
            lang: settingNotifier.languageString ??
                CommonLanguages.languageStringDefault(),
            word: 'tooltip.button.createNote'),
        child: CoreElevatedButton.iconOnly(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteCreateScreen(
                        note: null,
                        copyNote: null,
                        subject: currentParentSubject,
                        actionMode: ActionModeEnum.create,
                        redirectFrom: RedirectFromEnum.subjectsInFolderMode,
                      )),
            );
          },
          coreButtonStyle: ThemeDataCenter.getCoreScreenButtonStyle(
              context: context, customRadius: 40.0),
          icon: const SizedBox(
            width: 50.0,
            height: 50.0,
            child: Center(
              child: Icon(
                Icons.add_rounded,
                size: 35.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            color: settingNotifier.isSetBackgroundImage == true
                ? Colors.white.withOpacity(0.85)
                : Colors.transparent),
        child: Row(
          children: [
            IconButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color?>(
                    Colors.blueGrey.withOpacity(0.65)),
              ),
              onPressed: () {
                _resetPage();
              },
              icon: const Icon(Icons.folder_rounded),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _breadcrumbScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    breadcrumb.length,
                    (index) => InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () {
                        if (index < breadcrumb.length - 1) {
                          currentParentSubject = breadcrumb[index];

                          _reloadPage().then((result) => {
                                if (result)
                                  {
                                    setState(() {
                                      breadcrumb.removeRange(
                                          index + 1, breadcrumb.length);
                                    })
                                  }
                              });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
                              child: Text(
                                breadcrumb[index].title,
                                style: TextStyle(
                                    fontWeight: index == breadcrumb.length - 1
                                        ? FontWeight.w500
                                        : null,
                                    fontSize: 16),
                              ),
                            ),
                            index == breadcrumb.length - 1
                                ? Container()
                                : const Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color?>(
                    Colors.blueGrey.withOpacity(0.65)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubjectCreateScreen(
                            parentSubject: currentParentSubject,
                            actionMode: ActionModeEnum.create,
                            redirectFrom: RedirectFromEnum.subjectsInFolderMode,
                            breadcrumb: null,
                          )),
                );
              },
              icon: const Icon(Icons.create_new_folder_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyFolderViewMode(
      SubjectNotifier subjectNotifier, SettingNotifier settingNotifier) {
    return Column(
      children: [
        settingNotifier.isSetBackgroundImage == true
            ? SizedBox(height: CommonDimensions.scaffoldAppBarHeight(context))
            : Container(),
        Expanded(
          child: SubjectDetailFolderItem(
            subject: null,
            redirectFrom: null,
            breadcrumbWidget: _buildBreadcrumb(settingNotifier),
            subjectFoldersWidget: subjectFolders.isNotEmpty
                ? GridView.builder(
                    padding: EdgeInsets.only(
                        top: CommonDimensions.scaffoldAppBarHeight(context) / 5,
                        bottom: 150.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: subjectFolders.length,
                    itemBuilder: (context, index) {
                      return SubjectWidgetFolderItem(
                        index: index,
                        subject: subjectFolders[index],
                        isSubSubject: null,
                        onUpdate: () {},
                        onDelete: () {},
                        onDeleteForever: () {},
                        onRestoreFromTrash: () {},
                        onFilterChildrenOnly: () {
                          currentParentSubject = subjectFolders[index];

                          _reloadPage().then((result) {
                            if (result) {
                              setState(() {
                                breadcrumb.add(currentParentSubject!);
                                canPop = false;
                              });

                              _scrollToLastBreadcrumbItem();
                            }
                          });
                        },
                        onFilterParent: () {},
                      );
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            color: settingNotifier.isSetBackgroundImage == true
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
                                  CommonLanguages.convert(
                                      lang: settingNotifier.languageString ??
                                          CommonLanguages
                                              .languageStringDefault(),
                                      word: 'notification.noItem.subject'),
                                  style: GoogleFonts.montserrat(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16.0,
                                      color: ThemeDataCenter
                                          .getAloneTextColorStyle(context),
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
            notesWidget: notes.isNotEmpty
                ? _buildNotesWidget(context, settingNotifier)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            color: settingNotifier.isSetBackgroundImage == true
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
                                  CommonLanguages.convert(
                                      lang: settingNotifier.languageString ??
                                          CommonLanguages
                                              .languageStringDefault(),
                                      word: 'notification.noItem.note'),
                                  style: GoogleFonts.montserrat(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16.0,
                                      color: ThemeDataCenter
                                          .getAloneTextColorStyle(context),
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  /*
  Get note's labels
   */
  List<LabelModel>? _getNoteLabels(String jsonLabelIds) {
    List<LabelModel>? noteLabels = [];
    List<dynamic> labelIds = jsonDecode(jsonLabelIds);

    if (_labelList != null && _labelList!.isNotEmpty) {
      noteLabels =
          _labelList!.where((model) => labelIds.contains(model.id)).toList();
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

  Widget _buildNotesWidget(
      BuildContext context, SettingNotifier settingNotifier) {
    return SingleChildScrollView(
        child: Column(
            children: List.generate(
                notes.length,
                (index) => SmallNoteWidget(
                      note: notes[index],
                      index: index + 1,
                      labels: _getNoteLabels(notes[index].labels!),
                      subject: _getNoteSubject(notes[index].subjectId),
                    ))));
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
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                CommonLanguages.convert(
                    lang: settingNotifier.languageString ??
                        CommonLanguages.languageStringDefault(),
                    word: 'screen.title.subjects'),
                style: CommonStyles.screenTitleTextStyle(
                    color: ThemeDataCenter.getScreenTitleTextColor(context)),
              ),
            ),
          ),
          Tooltip(
            message: 'List view',
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
                      color:
                          ThemeDataCenter.getFilteringTextColorStyle(context),
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
                onTap: () {
                  _onChangeToListView();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
