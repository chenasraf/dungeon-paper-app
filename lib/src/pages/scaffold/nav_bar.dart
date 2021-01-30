import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Pages { Home, Battle, Reference, Inventory, Notes }

typedef ColorBuilder = Widget Function(Color color);

class NavBar extends StatefulWidget {
  final PageController pageController;
  NavBar({Key key, @required this.pageController}) : super(key: key);

  @override
  NavBarState createState() => NavBarState(pageController: pageController);
}

class NavBarState extends State<NavBar> {
  final PageController pageController;
  double activePageIndex = 0;

  NavBarState({
    Key key,
    @required this.pageController,
  });

  @override
  void initState() {
    pageController.addListener(pageListener);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     systemNavigationBarColor: Get.theme.canvasColor,
  //   ));
  //   super.didChangeDependencies();
  // }

  void pageListener() {
    if (pageController.hasClients && pageController.page != activePageIndex) {
      setState(() {
        activePageIndex = pageController.page;
      });
    }
  }

  Map<Pages, PageDetails> pageDetails = {
    Pages.Home: PageDetails(
        Text('Profile'), (color) => Icon(Icons.person, color: color)),
    Pages.Battle: PageDetails(
        Text('Battle'),
        (color) => PlatformSvg.asset(
              'swords.svg',
              color: color,
              width: 24,
              height: 24,
            )),
    Pages.Notes: PageDetails(
        Text('Notes'), (color) => Icon(Icons.speaker_notes, color: color)),
    Pages.Inventory: PageDetails(
        Text('Inventory'),
        (color) => PlatformSvg.asset(
              // 'armor.svg',
              'bag.svg',
              color: color,
              width: 24,
              height: 24,
            )),
    Pages.Reference: PageDetails(
        Text('Reference'),
        (color) => Icon(
              CupertinoIcons.book_solid,
              color: color,
            )),
  };

  @override
  Widget build(BuildContext context) {
    final pageItems = Pages.values.map((page) {
      final details = pageDetails[page];
      final t = (activePageIndex - page.index).abs();
      final color = Color.lerp(
        Get.theme.colorScheme.surface.withOpacity(0.8), // slected color
        Get.theme.colorScheme.secondary, // unselected color
        clamp01<double>(t),
      );

      if (details == null) {
        return Container();
      }

      return PageNavItem(
        foregroundColor: color,
        label: details.label,
        iconBuilder: details.iconBuilder,
        onChangePage: () => pageController.animateToPage(page.index,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutQuart),
      );
    }).toList();
    final width = MediaQuery.of(context).size.width;

    return BottomAppBar(
      color: Get.theme.colorScheme.primary,
      elevation: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            width < 300 ? MainAxisAlignment.spaceAround : MainAxisAlignment.end,
        children: pageItems,
      ),
    );
  }

  @override
  void dispose() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Get.theme.scaffoldBackgroundColor,
    // ));
    pageController.removeListener(pageListener);
    super.dispose();
  }
}

class PageDetails {
  final Widget label;
  final ColorBuilder iconBuilder;

  PageDetails(this.label, this.iconBuilder);
}

class PageNavItem extends StatelessWidget {
  const PageNavItem({
    Key key,
    @required this.label,
    @required this.iconBuilder,
    @required this.foregroundColor,
    @required this.onChangePage,
  }) : super(key: key);

  final Color foregroundColor;
  final Widget label;
  final ColorBuilder iconBuilder;
  final Function onChangePage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 60,
          child: InkWell(
            onTap: onChangePage,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                iconBuilder(foregroundColor),
                DefaultTextStyle(
                  style: Get.theme.textTheme.bodyText2
                      .copyWith(color: foregroundColor),
                  child: label,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
