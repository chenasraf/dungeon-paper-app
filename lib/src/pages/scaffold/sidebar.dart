import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/user.dart';
import 'package:dungeon_paper/src/atoms/user_avatar.dart';
import 'package:dungeon_paper/src/dialogs/dialogs.dart';
import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:dungeon_paper/src/pages/about_view/about_view.dart';
import 'package:dungeon_paper/src/pages/campaigns_view/campaigns_view.dart';
import 'package:dungeon_paper/src/pages/custom_classes_view/custom_classes_view.dart';
import 'package:dungeon_paper/src/pages/character/character_view.dart';
import 'package:dungeon_paper/src/pages/settings_view/settings_view.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/scaffolds/manage_characters_view/manage_characters_view.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/auth/auth.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  AnimationController userMenuCtrl;
  Animation<double> userMenuAnim;

  @override
  void initState() {
    super.initState();
    logger.d('Open Sidebar');
    userMenuCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    userMenuAnim = CurvedAnimation(
      parent: userMenuCtrl,
      curve: Curves.easeInOut,
    );
    analytics.logEvent(name: Events.OpenSidebar);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final user = userController.current;

        return Drawer(
          child: Column(
            children: [
              UserDrawerHeader(
                user: user,
                onToggleUserMenu: _toggleUserMenu,
              ),
              SizeTransition(
                axis: Axis.vertical,
                sizeFactor: userMenuAnim,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Account'),
                      onTap: () => Get.toNamed('/account'),
                    ),
                    // Log out
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Log out'),
                      onTap: _signOut,
                    ),
                    Divider(height: 1),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: 8),
                    title(
                      'Characters',
                      context,
                      leading: Row(
                        children: [
                          IconButton(
                            color: Get.theme.accentColor,
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add),
                            tooltip: 'Create new character',
                            onPressed: createNewCharacterScreen,
                          ),
                          IconButton(
                            color: Get.theme.accentColor,
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.settings),
                            tooltip: 'Manage characters',
                            onPressed: manageCharactersScreen,
                          ),
                        ],
                      ),
                    ),
                    ...characterList(characterController.all, context),
                    Divider(),
                    title('Custom Content', context),
                    if (user.isDm)
                      ListTile(
                        title: Text('Campaigns'),
                        onTap: campaignsScreen,
                        leading: Icon(Icons.group),
                      ),
                    ListTile(
                      title: Text('Custom Classes'),
                      onTap: customClassesScreen,
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: PlatformSvg.asset(
                          'book-stack.svg',
                          width: 16,
                          height: 16,
                          color: Get.theme.brightness == Brightness.light
                              ? Colors.black45
                              : Get.theme.accentColor,
                        ),
                      ),
                    ),
                    Divider(),
                    title('Application', context),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () =>
                          openPage(ScreenNames.Settings, SettingsView()),
                    ),
                    // About
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About'),
                      onTap: aboutScreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleUserMenu() {
    setState(() {
      if (userMenuCtrl.value == userMenuCtrl.lowerBound) {
        userMenuCtrl.forward();
      } else {
        userMenuCtrl.reverse();
      }
    });
  }

  void _signOut() {
    Get.back();
    signOutAll();
  }

  void openPage(
    String pageName,
    Widget page,
  ) {
    logger.d('Page View: $pageName');
    analytics.setCurrentScreen(screenName: pageName);
    Get.to(page);
  }

  void createNewCharacterScreen() {
    Get.back();
    openPage(
      ScreenNames.CharacterScreen,
      CharacterView(
        character: null,
        mode: DialogMode.create,
        onSave: (char) => characterController.setCurrent(char),
      ),
    );
  }

  void manageCharactersScreen() {
    Get.back();
    openPage(ScreenNames.ManageCharacters, ManageCharactersView());
  }

  void customClassesScreen() {
    Get.back();
    openPage(ScreenNames.CustomClasses, CustomClassesView());
  }

  void campaignsScreen() {
    Get.back();
    openPage(ScreenNames.About, CampaignsView());
  }

  void aboutScreen() {
    Get.back();
    openPage(ScreenNames.About, AboutView());
  }

  Widget title(
    String text,
    BuildContext context, {
    Widget leading,
  }) {
    Widget title = Padding(
      padding: EdgeInsets.all(8).copyWith(left: 18),
      child: Text(
        text.toUpperCase(),
        style: titleStyle,
      ),
    );
    if (leading == null) {
      return title;
    }
    final leadingStyle = titleStyle.copyWith(
      color: Get.theme.textTheme.headline3.color,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        title,
        DefaultTextStyle(
          child: leading,
          style: leadingStyle,
        ),
      ],
    );
  }

  static final titleStyle = TextStyle(
    color: Get.theme.accentColor,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  List<Widget> characterList(
      Map<String, Character> characters, BuildContext context) {
    if (characters == null || characters.isEmpty) {
      return [];
    }
    return CharacterListTile.list(
      characters.values.toList()..sort((ch1, ch2) => ch1.order - ch2.order),
      selectedId: characterController.current.documentID,
    );
  }
}

class CharacterListTile extends StatelessWidget {
  final Character character;
  final bool selected;
  const CharacterListTile({
    Key key,
    @required this.character,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (character?.displayName == null) {
      return Container(height: 0);
    }
    return ListTileTheme.merge(
      selectedColor: Get.theme.colorScheme.secondaryVariant,
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(character.displayName),
        selected: selected,
        onTap: () {
          logger.d('Set Current Char: $character');
          analytics.logEvent(name: Events.ChangeCharacter, parameters: {
            'documentID': character.documentID,
            'order': character.order,
          });
          characterController.setCurrent(character);
          Get.back();
        },
      ),
    );
  }

  static List<Widget> list(
    Iterable<Character> characters, {
    String selectedId,
  }) =>
      characters
          .map((character) => CharacterListTile(
                key: Key(character.documentID),
                character: character,
                selected:
                    selectedId != null && selectedId == character.documentID,
              ))
          .toList();
}

class UserDrawerHeader extends StatelessWidget {
  const UserDrawerHeader({
    Key key,
    @required this.user,
    @required this.onToggleUserMenu,
  }) : super(key: key);

  final User user;
  final void Function() onToggleUserMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Get.theme.accentColor),
          accountEmail: Text(
            user.email,
            style: TextStyle(color: Get.theme.colorScheme.onSecondary),
          ),
          accountName: Text(
            user.displayName,
            style: TextStyle(color: Get.theme.colorScheme.onSecondary),
          ),
          currentAccountPicture: GestureDetector(
            child: UserAvatar(user: user),
            onTap: () => Get.toNamed('/account'),
          ),
          onDetailsPressed: onToggleUserMenu,
        ),
      ],
    );
  }
}
