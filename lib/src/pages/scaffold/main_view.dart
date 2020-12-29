import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/user.dart';
import 'package:dungeon_paper/src/atoms/dice_icon.dart';
import 'package:dungeon_paper/src/dialogs/roll_dice_view.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/pages/battle_view/battle_view.dart';
import 'package:dungeon_paper/src/pages/home_view/home_view.dart';
import 'package:dungeon_paper/src/pages/inventory_view/inventory_view.dart';
import 'package:dungeon_paper/src/pages/notes_view/notes_view.dart';
import 'package:dungeon_paper/src/pages/reference_view/reference_view.dart';
import 'package:dungeon_paper/src/pages/welcome_view/welcome_view.dart';
import 'package:dungeon_paper/src/pages/whats_new_view/whats_new_view.dart';
import 'package:dungeon_paper/src/redux/connectors.dart';
import 'package:dungeon_paper/src/redux/loading/loading_store.dart';
import 'package:dungeon_paper/src/redux/shared_preferences/prefs_store.dart';
import 'package:dungeon_paper/src/redux/stores.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_paper/themes/themes.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info/package_info.dart';
import 'package:pedantic/pedantic.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'app_bar_title.dart';
import 'fab.dart';
import 'nav_bar.dart';
import 'sidebar.dart';

class MainContainer extends StatelessWidget {
  MainContainer({
    Key key,
    this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Themes>(
      init: Themes.instance,
      builder: (themes) {
        return DWStoreConnector<DWStore>(
          builder: (ctx, state) {
            final character = state.characters.current;
            final user = state.user.current;
            return MainView(
              character: character,
              user: user,
              loading: state.loading[LoadingKeys.Character] ||
                  state.loading[LoadingKeys.User],
              pageController: pageController,
            );
          },
        );
      },
    );
  }
}

class MainView extends StatefulWidget {
  final Character character;
  final User user;
  final bool loading;
  final PageController pageController;

  MainView({
    Key key,
    @required this.character,
    @required this.user,
    @required this.loading,
    @required this.pageController,
  }) : super(key: key);

  static Widget bottomSpacer = BOTTOM_SPACER;

  @override
  _MainViewState createState() => _MainViewState();
}

typedef PageBuilder = Widget Function(Character character);

class _MainViewState extends State<MainView> {
  final Map<Pages, PageBuilder> pageMap = {
    Pages.Home: (character) => HomeView(character: character),
    Pages.Battle: (character) => BattleView(character: character),
    Pages.Inventory: (character) => InventoryView(character: character),
    Pages.Notes: (character) => NotesView(character: character),
    Pages.Reference: (_) => ReferenceView(),
  };
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  Map<Pages, ScrollController> scrollControllers;
  String lastPageName = 'Home';
  double elevation = 0;

  @override
  void initState() {
    widget.pageController.addListener(_pageListener);
    scrollControllers = {};
    Pages.values.forEach((page) {
      scrollControllers[page] =
          ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
    });
    _showWhatsNew();
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_pageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useAppBar = widget.character != null;
    return MainScaffold(
      // appBar: MainAppBar(
      // scrollController: _currentScrollController,
      title: appBarTitle,
      actions: actions(context),
      elevation: 0,
      // ),
      wrapWithScrollable: false,
      useAppBar: useAppBar,
      drawer: drawer,
      floatingActionButton: fab,
      floatingActionButtonLocation: fabLocation,
      bottomNavigationBar: navBar,
      body: pageView,
    );
  }

  List<Widget> actions(BuildContext context) => widget.character != null
      ? [
          IconButton(
            tooltip: 'Roll Dice',
            icon: DiceIcon(
              dice: Dice.d20,
              size: 24,
              color: Get.theme.colorScheme.secondary,
            ),
            onPressed: () {
              showDiceRollView(
                character: widget.character,
                analyticsSource: pageName,
              );
            },
          )
        ]
      : null;

  Widget get appBarTitle => widget.character == null
      ? null
      : AppBarTitle(pageController: widget.pageController);

  Widget get pageView => PageView(
        controller: widget.pageController,
        children: widget.character != null
            ? pages
            : [WelcomeView(loading: widget.loading)],
      );

  String get pageName => enumName(page);

  Pages get page => Pages.values.elementAt(
        widget.pageController?.page?.toInt?.call() ?? 0,
      );

  // ScrollController get _currentScrollController =>
  //     widget.pageController.hasClients ? scrollControllers[page] : null;

  Widget get fab => widget.character != null
      ? FAB(pageController: widget.pageController, character: widget.character)
      : null;

  FloatingActionButtonLocation get fabLocation =>
      widget.character != null ? FloatingActionButtonLocation.endFloat : null;

  Widget get drawer =>
      widget.user != null && widget.character != null ? Sidebar() : null;

  List<Widget> get pages => Pages.values.map((page) {
        final builder = pageMap[page];
        if (builder != null) {
          final child = builder(widget.character);
          return child;
          // return Container(
          //   color: Colors.blue[100],
          //   child: SingleChildScrollView(
          //     controller: widget.pageController.hasClients
          //         ? scrollControllers[page]
          //         : null,
          //     child: Container(color: Colors.red[100], child: child),
          //   ),
          // );
        }
        return Center(child: Container());
      }).toList();

  Widget get navBar => widget.character != null
      ? NavBar(pageController: widget.pageController)
      : null;

  void _showWhatsNew() async {
    var packageInfo = await PackageInfo.fromPlatform();
    var sharedPrefs = await SharedPreferences.getInstance();
    var lastVersionKey = enumName(SharedPrefKeys.LastOpenedVersion);
    Version lastViewedAt;
    if (sharedPrefs.containsKey(lastVersionKey)) {
      lastViewedAt = Version.parse(sharedPrefs.getString(lastVersionKey));
    }
    if (lastViewedAt == null ||
        lastViewedAt < Version.parse(packageInfo.version)) {
      unawaited(showDialog(
        context: context,
        builder: (context) => WhatsNew.dialog(),
      ));
    }
    unawaited(sharedPrefs.setString(lastVersionKey, packageInfo.version));
  }

  void _pageListener() {
    if (widget.pageController.hasClients) {
      // if (clamp01(widget.pageController.page) != elevation) {
      //   setState(() {
      //     elevation = clamp01(widget.pageController.page);
      //   });
      // }
      if (FocusScope.of(context).isFirstFocus) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
      if (widget.pageController.page.round() == widget.pageController.page) {
        if (pageName != lastPageName) {
          setState(() {
            lastPageName = pageName;
          });
          logger.d('Page View: $pageName (from: $lastPageName)');
          analytics.setCurrentScreen(
            screenName: pageName,
          );
        } else {
          analytics.logEvent(name: Events.ReturnToScreen, parameters: {
            'screen_name': lastPageName,
          });
        }
      }
    }
  }
}
