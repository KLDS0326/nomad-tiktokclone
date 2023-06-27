import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/google_places/google_search_screen.dart';

class GoogleSearchMainHome extends StatefulWidget {
  const GoogleSearchMainHome({super.key});

  @override
  State<GoogleSearchMainHome> createState() => _GoogleSearchMainHomeState();
}

class _GoogleSearchMainHomeState extends State<GoogleSearchMainHome> {
  Future<void> _createPressed(BuildContext context) async {
    //부드럽게 화면이동하고, X 했을 떄 전 화면으로 돌아가게끔
    /* Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondartyAnimation) =>
            const GoogleSearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        },
      ),
    ); */

    //높이 상한선있음. 화면의 50%
    /* showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const GoogleSearch(),
    ); */

    showDialog(
      context: context,
      builder: (context) => const GoogleSearch(),
    );

    /* showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: const GoogleSearch(),
        );
      },
    ); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main"),
        actions: [
          IconButton(
            onPressed: () => _createPressed(context),
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(15),
        separatorBuilder: (context, index) => Gaps.v4,
        itemCount: 10,
        itemBuilder: (context, index) => Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(
                  Sizes.size10,
                ),
                /*   boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: const Offset(5, 5),
                    color: Colors.black.withOpacity(0.1),
                  )
                ], */
              ),
              width: 400,
              height: 70,
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "인천광역시 서구 가정동",
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    color: Colors.black87,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
