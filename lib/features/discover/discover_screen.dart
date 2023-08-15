import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

/* 검색기본 값을 주려면, controller를 이용해야함. 그리고 그러려면, StatefulWidget을 써야함.*/
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  /* DiscoverScreen  (집), State (주소, 크기 색상 등 즉, 상태를 관리하는 클래스)
    createState() : 상태를 생성하는 열 쇠 
    상태 객체를 생성하여 반환함. 
  */
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  // 기본 겁색어 설정
  final TextEditingController _textEditingController =
      TextEditingController(text: "무엇을 검색해볼까");
  void _onSearchChanged(String value) {
    // print("입력내용 받기 $value");
  }

  void _onSearchSubmitted(String value) {
    //print("검색하기 $value");
  }

  //컨트롤러 사용할 때에는 dispose를 함께 써주어야함. 메모리누수방지 앱성능/자원관리
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      // Tab controller 필요 .
      length: tabs.length,
      child: Scaffold(
          //화면 줄어듦 없음. 리사이즈 방지
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 1,
            // 커서 색상 같은 커스터마이징 안되나, main.dart에서 앱의 모든 택스트필드  옵션조절가능

            title: Container(
              constraints: const BoxConstraints(
                maxWidth: BreakPoints.sm,
              ),
              child: CupertinoSearchTextField(
                controller: _textEditingController,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchSubmitted,
                style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : Colors.black),
              ),
            ),
            bottom: TabBar(
              onTap: (value) => FocusScope.of(context).unfocus(),

              splashFactory: NoSplash.splashFactory, //터치 효과
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
              isScrollable: true,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: Sizes.size16),
              indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
              tabs: [
                for (var tab in tabs)
                  Tab(
                    text: tab,
                  ),
              ],
            ), // PreferredSizeWidget, 특정크기 가질 때 자식 크기 제한 안함. 특정사이즈를 가지려하면, 부모요소의 사이즈 제한 안받음
          ),
          body: TabBarView(
            children: [
              /*여러가지 방법. 칠드런 별로임. 성능별로임. 빌더를 씀 페이지뷰처럼. 
               델리게이트는 컨트롤러와 달리 도우미 같음. 그리드뷰 그리는거 도와줌.
              비디오 타임라인을 보면 페이지뷰와 비슷함. 구조가. 아이템빌드*/
              GridView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: 20,
                padding: const EdgeInsets.all(
                    Sizes.size6), // SliverGridDelegate 몇개의 컬럼을 가질지
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > BreakPoints.lg ? 5 : 2,
                  crossAxisSpacing: Sizes.size10,
                  mainAxisSpacing: Sizes.size10,
                  childAspectRatio: 9 / 20,
                ),
                // 유저이미지는 인터넷에 올라왔일테고, 구글클라우드 스토리지 (우리)
                /*Image.asset(
                                    "assets/images/mycat.jpg",
                        ),*/
                //큰 용량은 못올리게 제한 - 느림  , 인터넷환경 등
                /* Image.network(
                        "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxNzA1MjlfMjc5%2FMDAxNDk2MDU4OTMxMTY5.-AXGgNDYUn4kjzZslGfueFca3-9mRJRDHXRF4Lc1hgYg.vu2kVIGHJX78gJikywPIPkXK8X41VhH_B5rCk3MY1K4g.JPEG.js2y86%2F0Tkaakdldnpdl0b15.jpg&type=a340"),
                        ), */
                /* 에셋네트워크 : 플레이스홀더로 보여줄 이미지가 에셋에 있다는 뜻.(context, index) => 
                        백그라운드 : 네트워크 이미지를 받아옴 (페이드인이미지) 네트워크 이미지 로딩중까지는
                        플레이스홀더 이미지를 보여줌. 강추
                        
                      사용자가 우리가 원하는 이미지사이즈를 업로드 안할 수도 있음.
                      
                      백엔드에서 이미지를 크롭해서 틱톡에 맞는 직사각형으로 만들 수도 있지만,
                      에스펙트레이시오 위젯사용 >> 강제로 특정이미지 사이즈 변경함. 
                      Fit은 이미지가 부모요소에 적용될지 정해줌.
                    */
                itemBuilder: (context, index) => LayoutBuilder(
                  builder: (context, constraints) => Column(
                    children: [
                      Container(
                        // imager가 컨테이너를 초과함. 이를 clipBehavior로 잘라줌.
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Sizes.size4,
                          ),
                        ),
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover, // 전체를 덮게함.
                              placeholder: "assets/images/mycat.jpg",
                              image:
                                  "https://plus.unsplash.com/premium_photo-1669612840452-dde22311731d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=874&q=80"),
                        ),
                      ),
                      Gaps.v8,
                      const Text(
                        "is a vert long caption for my tikotk that im uploaded just now crurrently",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Sizes.size16 + Sizes.size2,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      Gaps.v5,
                      /*      if (constraints.maxWidth < 200 ||
                          constraints.maxWidth > 250) */
                      DefaultTextStyle(
                        style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                  "https://avatars.githubusercontent.com/u/3612017"),
                            ),
                            Gaps.h4,
                            const Expanded(
                              child: Text(
                                "MY avater name is very long",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.h4,
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size16,
                              color: Colors.grey.shade600,
                            ),
                            Gaps.h2,
                            const Text(
                              "324",
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              for (var tab in tabs.skip(1)) // 첫번째 스킵함.
                Center(
                  child: Text(
                    tab,
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
            ],
          )),
    );
  }
}
