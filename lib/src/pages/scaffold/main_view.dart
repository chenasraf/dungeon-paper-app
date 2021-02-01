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
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/loading_controller.dart';
import 'package:dungeon_paper/src/controllers/prefs_controller.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:dungeon_paper/themes/themes.dart';
import 'package:dungeon_world_data/dice.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pedantic/pedantic.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'app_bar_title.dart';
import 'drawer_positioner.dart';
import 'fab.dart';
import 'nav_bar.dart';
import 'sidebar.dart';

class MainContainer extends StatelessWidget {
  MainContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Themes>(
      init: Themes.instance,
      builder: (themes) {
        return Obx(
          () {
            final character = characterController.current;
            final user = userController.current;
            final isLoading = loadingController[LoadingKeys.character] ||
                loadingController[LoadingKeys.user];
            return MainView(
              character: character,
              user: user,
              loading: isLoading,
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

  MainView({
    Key key,
    @required this.character,
    @required this.user,
    @required this.loading,
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
  PageController pageController;
  String sessionKey;

  @override
  void initState() {
    sessionKey = Uuid().v4();
    pageController = PageController(initialPage: 0, keepPage: false)
      ..addListener(_pageListener);
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
    pageController.removeListener(_pageListener);
    pageController.dispose();
    scrollControllers.forEach((key, value) {
      value?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useAppBar = widget.character != null;
    return DrawerPositioner(
      drawer: drawer,
      body: (drawer) => MainScaffold(
        title: appBarTitle,
        actions: actions(context),
        elevation: 0,
        wrapWithScrollable: false,
        useAppBar: useAppBar,
        drawer: drawer,
        floatingActionButton: fab,
        floatingActionButtonLocation: fabLocation,
        bottomNavigationBar: navBar,
        body: pageView,
      ),
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
      : AppBarTitle(pageController: pageController);

  Widget get pageView => PageView(
        controller: pageController,
        children: widget.character != null
            ? pages
            : [WelcomeView(loading: widget.loading)],
      );

  String get pageName => enumName(page);

  Pages get page => Pages.values.elementAt(
        pageController?.page?.toInt?.call() ?? 0,
      );

  // ScrollController get _currentScrollController =>
  //     pageController.hasClients ? scrollControllers[page] : null;

  Widget get fab => widget.character != null
      ? FAB(pageController: pageController, character: widget.character)
      : null;

  FloatingActionButtonLocation get fabLocation =>
      widget.character != null ? FloatingActionButtonLocation.endFloat : null;

  Widget get drawer =>
      widget.user != null && widget.character != null ? Sidebar() : null;

  List<Widget> get pages => Pages.values.map((page) {
        if (!pageController.hasClients) {
          return Container();
        }
        final builder = pageMap[page];
        if (builder != null) {
          return builder(widget.character);
        }
        return Center(child: Container());
      }).toList();

  Widget get navBar =>
      widget.character != null ? NavBar(pageController: pageController) : null;

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

  static final screenNames = <String, String>{
    'Home': 'home_page',
    'Battle': 'battle_page',
    'Inventory': 'inventory_page',
    'Notes': 'notes_page',
    'Reference': 'reference_page',
  };

  void _pageListener() {
    if (pageController.hasClients) {
      loseAllFocus(context);
      if (pageController.page.round() == pageController.page) {
        if (pageName != lastPageName) {
          logger.d(
              'Page View: ${screenNames[pageName]} (from: ${screenNames[lastPageName]})');
          setState(() {
            lastPageName = pageName;
          });
          analytics.setCurrentScreen(
            screenName: screenNames[pageName],
          );
        } else {
          analytics.logEvent(name: Events.ReturnToScreen, parameters: {
            'screen_name': screenNames[lastPageName],
          });
        }
      }
    }
  }
}
