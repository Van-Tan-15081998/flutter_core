import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/common/pagination/models/CorePaginationModel.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreBasicDialog.dart';
import '../../../../../core/components/form/CoreTextFormField.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../home/home_screen.dart';
import '../databases/label_db_manager.dart';
import '../models/label_condition_model.dart';
import '../models/label_model.dart';
import '../providers/label_notifier.dart';
import 'functions/label_widget.dart';
import 'label_create_screen.dart';

class LabelListScreen extends StatefulWidget {
  final LabelConditionModel? labelConditionModel;
  const LabelListScreen({super.key, required this.labelConditionModel});

  @override
  State<LabelListScreen> createState() => _LabelListScreenState();
}

class _LabelListScreenState extends State<LabelListScreen> {
  List<LabelModel> labels = [];
  final ScrollController _scrollController = ScrollController();

  /*
   Parameters For Search & Filter
   */
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchText = "";
  bool _filterByDeleted = false;

  /*
   Pagination Parameters
   */
  static const _pageSize = 10;
  final PagingController<int, LabelModel> _pagingController =
  PagingController(firstPageKey: 0);

  final CorePaginationModel _corePaginationModel =
  CorePaginationModel(currentPageIndex: 0, itemPerPage: _pageSize);
  LabelConditionModel _labelConditionModel = LabelConditionModel();

  Future<List<LabelModel>> _fetchPage(int pageKey) async {
    try {
      List<LabelModel>? result = [];
      result = await LabelDatabaseManager.onGetLabelPagination(
          _corePaginationModel, _labelConditionModel);

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
  Reload Page
   */
  _reloadPage() {
    _corePaginationModel.currentPageIndex = 0;
    _pagingController.refresh();
  }

  Future<bool> _onDeleteLabel(
      BuildContext context, LabelModel label) async {
    return await LabelDatabaseManager.delete(
        label, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _onDeleteLabelForever(
      BuildContext context, LabelModel label) async {
    return await LabelDatabaseManager.deleteForever(label);
  }

  Future<bool> _onRestoreLabelFromTrash(
      BuildContext context, LabelModel label) async {
    return await LabelDatabaseManager.restoreFromTrash(
        label, DateTime.now().millisecondsSinceEpoch);
  }

  /*
  Reset conditions - NoteConditionModel noteConditionModel
   */
  _resetConditions() {
    setState(() {
      _searchText = "";
      _filterByDeleted = false;

      _labelConditionModel.id = null;
      _labelConditionModel.searchText = null;
      _labelConditionModel.isDeleted = null;

      _reloadPage();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelNotifier = Provider.of<LabelNotifier>(context);

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
                  kitBackgroundColorOption: Colors.white,
                  kitForegroundColorOption: const Color(0xFF404040),
                  coreFixedSizeButton: CoreFixedSizeButton.medium_40),
            ),
          )
        ],
        backgroundColor: const Color(0xFF202124),
        title: Text(
          'Labels',
          style:
              GoogleFonts.montserrat( fontStyle: FontStyle.italic,
                  fontSize: 30,
                  color: const Color(0xFF404040),
                  fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF404040), // Set the color you desire
        ),
      ),
      body: PagedListView<int, LabelModel>(
        scrollController: _scrollController,
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<LabelModel>(
          animateTransitions: true,
          transitionDuration: const Duration(milliseconds: 500),
          itemBuilder: (context, item, index) => LabelWidget(
              label: item,
              onUpdate: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LabelCreateScreen(
                          label: item,
                          actionMode: ActionModeEnum.update,
                        )));
                setState(() {});
              },
              onDelete: () {
                _onDeleteLabel(context, item).then((result) {
                  if (result) {
                    labelNotifier.onCountAll();

                    setState(() {
                      _pagingController.itemList!.remove(item);
                    });

                    CoreNotification.show(context, CoreNotificationStatus.success,
                        CoreNotificationAction.delete, 'Label');
                  } else {
                    CoreNotification.show(context, CoreNotificationStatus.error,
                        CoreNotificationAction.delete, 'Label');
                  }
                });
              },
              onDeleteForever: () async {
                if (await CoreHelperWidget.confirmFunction(context)) {
                  _onDeleteLabelForever(context, item).then((result) {
                    if (result) {
                      labelNotifier.onCountAll();

                      setState(() {
                        _pagingController.itemList!.remove(item);
                      });

                      CoreNotification.show(
                          context,
                          CoreNotificationStatus.success,
                          CoreNotificationAction.delete,
                          'Label');
                    } else {
                      CoreNotification.show(
                          context,
                          CoreNotificationStatus.error,
                          CoreNotificationAction.delete,
                          'Label');
                    }
                  });
                }
              },
              onRestoreFromTrash: () {
                _onRestoreLabelFromTrash(context, item).then((result) {
                  if (result) {
                    labelNotifier.onCountAll();

                    setState(() {
                      _pagingController.itemList!.remove(item);
                    });

                    CoreNotification.show(
                        context,
                        CoreNotificationStatus.success,
                        CoreNotificationAction.restore,
                        'Label');
                  } else {
                    CoreNotification.show(context, CoreNotificationStatus.error,
                        CoreNotificationAction.restore, 'Label');
                  }
                });
              },
          ),
          firstPageErrorIndicatorBuilder: (context) => const Center(
            child: Text('Error loading data!'),
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
                  _resetConditions();
                  _reloadPage();
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.home,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
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
                                        style: null,
                                        onChanged: (String value) {
                                          setState(() {
                                            _searchText = value.trim();
                                          });
                                        },
                                        controller: _searchController,
                                        focusNode: _searchFocusNode,
                                        validateString: 'Please enter your search string',
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
                                          _searchController.text =
                                              _searchText = "";
                                          _labelConditionModel
                                              .searchText = _searchText;
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
                                          _labelConditionModel
                                              .searchText = _searchText;

                                          // Reload Data
                                          _reloadPage();

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
                                        Text('Deleted',
                                            style: CommonStyles
                                                .buttonTextStyle),
                                        Checkbox(
                                          checkColor: Colors.white,
                                          value: _filterByDeleted,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _filterByDeleted = value!;
                                              if (_filterByDeleted) {
                                                _labelConditionModel
                                                    .isDeleted =
                                                    _filterByDeleted;
                                              } else {
                                                _labelConditionModel
                                                    .isDeleted = null;
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
                        builder: (context) => const LabelCreateScreen(
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
