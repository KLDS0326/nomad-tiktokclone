import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/google_places/google_search_main_home.dart';
import 'package:tiktok_clone/features/google_places/google_search_screen.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/features/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/features/videos/video_timeline_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  /* final screens = [
    Container(
      key: GlobalKey(),
    ),
    Container(
      key: GlobalKey(),
    ),
    Container(),
    Container(
      key: GlobalKey(),
    ),
    Container(
      key: GlobalKey(),
    ),
  ]; */

  void _onTap(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
    /* if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const GoogleSearchMainHome(),
        ),
      );
    }
    */
  }

  void _onPostVideoButtonTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Record video')),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _openGoogleMapSearchScreen(BuildContext context) async {
    KakaoMapUtil util = KakaoMapUtil();
    String hana = "hana";
    // String url = await util.getResolvedLink(
    //     util.getKakaoMapURL(37.402056, 127.108212, name: 'Kakao 본사'));

    /// This is short form of the above comment
/*     String url =
        await util.getMapScreenURL(37.402056, 127.108212, name: 'Kakao 본사'); */
/* 
    debugPrint('url : $url'); */

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GoogleSearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _selectedIndex == 0 ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ), // screens.elementAt(_selectedIndex), //screens[_selectedIndex],
          Offstage(
            offstage: _selectedIndex != 1,
            child: const GoogleSearchMainHome(), //const GoogleSearchMainHome(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: Container(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: _selectedIndex == 0 ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(
            Sizes.size12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: "리포트",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.penToSquare,
                selectedicon: FontAwesomeIcons.solidPenToSquare,
                onTap: () => _onTap(0),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "홈",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.house,
                selectedicon: FontAwesomeIcons.house,
                onTap: () => _onTap(1),
                selectedIndex: _selectedIndex,
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onPostVideoButtonTap,
                /*() async {
                  await _openGoogleMapSearchScreen(context);
                }, */
                child: PostVideoButton(
                  inverted: _selectedIndex != 0,
                ),
              ),
              Gaps.h24,
              NavTab(
                text: "선호지역",
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.star,
                selectedicon: FontAwesomeIcons.solidStar,
                onTap: () => _onTap(3),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "내 정보",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedicon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* Material 3
return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: Colors.teal,
            ),
            label: 'home',
          ),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.amber,
            ),
            label: 'Search',
          ),
        ],
      ),
    );
   */

/* Material 2
bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        //selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: "Home",
            tooltip: "WHar are you",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: "Search",
            tooltip: "what are you",
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: "Search",
            tooltip: "what are you",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: "Search",
            tooltip: "what are you",
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: "Search",
            tooltip: "what are you",
            backgroundColor: Colors.pink,
          ),
        ],
      ), */
