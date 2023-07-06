/* 
Google Maps

final List<GoogleMapExampleAppPage> _allPages = <GoogleMapExampleAppPage>[
  const MapClickPage(),
  const MapUiPage(),
  const ScrollingMapPage(),
  const MarkerIconsPage(),
  const PlaceMarkerPage(),
  const MoveCameraPage(),
  const AnimateCameraPage(),
  const TileOverlayPage(),
  const SnapshotPage(),
  const PlacePolylinePage(),
  const PlaceCirclePage(),
  const MapCoordinatesPage(),
  const PlacePolygonPage(),
];

class MapsDemo extends StatelessWidget {
  const MapsDemo({super.key});

  void _pushPage(BuildContext context, GoogleMapExampleAppPage page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(page.title),
          ),
          body: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoogleMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: MapsDemo(),
    ),
  );
} */

//틱톡 클론코딩
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //플러터 엔진과 프레임워크를 묶음. 바인딩 초기화

  //세로방향고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 상단 배터리, 와이파이 아이콘 UI 색상변경
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TikTok Clone',
        themeMode: ThemeMode.dark, //시스템 설정 따라감.
        theme: ThemeData(
          textTheme: GoogleFonts.itimTextTheme(),
          brightness: Brightness.light,
          /* textTheme: TextTheme(
            displayLarge: GoogleFonts.openSans(
                fontSize: 95, fontWeight: FontWeight.w300, letterSpacing: -1.5),
            displayMedium: GoogleFonts.openSans(
                fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
            displaySmall:
                GoogleFonts.openSans(fontSize: 48, fontWeight: FontWeight.w400),
            headlineMedium: GoogleFonts.openSans(
                fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            headlineSmall:
                GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w400),
            titleLarge: GoogleFonts.openSans(
                fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            titleMedium: GoogleFonts.openSans(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            titleSmall: GoogleFonts.openSans(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyLarge: GoogleFonts.roboto(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            bodyMedium: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            labelLarge: GoogleFonts.roboto(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            bodySmall: GoogleFonts.roboto(
                fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
            labelSmall: GoogleFonts.roboto(
                fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          ), */

          scaffoldBackgroundColor: Colors.white,
          bottomAppBarTheme: BottomAppBarTheme(
              color: isDarkMode(context)
                  ? Colors.grey.shade900
                  : Colors.grey.shade50),
          primaryColor: const Color(0xFFE9435A),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
            selectionColor: Color(0xFFE9435A),
          ),
          // 버튼 터치 시 스플래쉬 되지않도록 함.
          splashColor: Colors.transparent,
          // 길게 누르기도 없애려면,
          //highlightColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        darkTheme: ThemeData(
          textTheme: GoogleFonts.itimTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: const Color(0xFFE9435A),
        ),
        home: const SignUpScreen()
        // const SignUpScreen()  //ActivityScreen() // MainScreen() -> 스터디앱
        //MapsDemo() //const MainNavigationScreen() //MapSample() //const MainNavigationScreen(),  //
        );
  }
}

/* CupertinoApp
return const CupertinoApp(
      title: 'TikTok Clone',
      home: MainNavigationScreen(),
    );
*/

/* Material
return MaterialApp(
      title: 'TikTok Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const MainNavigationScreen(),
    ); */
