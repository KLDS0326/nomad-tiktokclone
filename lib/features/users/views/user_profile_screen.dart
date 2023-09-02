import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/persistent_tab_bar.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  final String tab;
  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: widget.tab == "likes" ? 1 : 0,
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(widget.username),
                  actions: [
                    IconButton(
                      onPressed: _onGearPressed,
                      icon: const FaIcon(
                        FontAwesomeIcons.gear,
                        size: Sizes.size20,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        foregroundImage: NetworkImage(
                            "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjExMTNfNDAg%2FMDAxNjY4MzM1NjA5MDI2.g4OBc9SF4R35wDDxijeZUUYda5_Q3elb-hJOOg9nRUYg.gFSqoyyTJPmnWWalCOxWr6jkRFohacPRKAnD4mDqJucg.PNG.boosung6666%2F%25A4%25B8%25A4%25A1%25A4%25B1.png&type=sc960_832"),
                        child: Text("중꺾마"),
                      ),
                      Gaps.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "@${widget.username}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size18,
                            ),
                          ),
                          Gaps.h5,
                          FaIcon(
                            FontAwesomeIcons.solidCircleCheck,
                            size: Sizes.size16,
                            color: Colors.blue.shade500,
                          ),
                        ],
                      ),
                      Gaps.v24,
                      SizedBox(
                        height: Sizes.size48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const UserAccount(
                              count: 44424,
                              text: "Followers",
                            ),
                            //father의 크기를 따라감. (SizedBox)
                            VerticalDivider(
                              width: Sizes.size32,
                              thickness: Sizes.size1,
                              color: Colors.grey.shade500,
                              indent: Sizes.size10,
                              endIndent: Sizes.size10,
                            ),
                            const UserAccount(
                              count: 444,
                              text: "Following",
                            ),
                            VerticalDivider(
                              width: Sizes.size32,
                              thickness: Sizes.size1,
                              color: Colors.grey.shade500,
                              indent: Sizes.size10,
                              endIndent: Sizes.size10,
                            ),
                            const UserAccount(
                              count: 21114,
                              text: "Likes",
                            ),
                          ],
                        ),
                      ),
                      Gaps.v14,
                      FractionallySizedBox(
                        widthFactor: 0.7,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size12,
                                horizontal: Sizes.size56 + Sizes.size12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.size4),
                                ),
                              ),
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Gaps.h5,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size12,
                                  horizontal: Sizes.size14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.size4),
                                ),
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.youtube,
                                size: Sizes.size16,
                              ),
                            ),
                            Gaps.h5,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.size12,
                                  horizontal: Sizes.size14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.size4),
                                ),
                              ),
                              child: const FaIcon(FontAwesomeIcons.chevronDown,
                                  size: Sizes.size16),
                            ),
                          ],
                        ),
                      ),
                      Gaps.v14,
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size32,
                        ),
                        child: Text(
                          'All highlights and where to watch live matches on FIFA+ haha i"m a boy you are a girl',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gaps.v14,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.link,
                            size: Sizes.size12,
                          ),
                          Gaps.h4,
                          Text(
                            "http://howaryoutoday.com",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      Gaps.v20,
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  delegate: PersistentTabBar(),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                GridView.builder(
                  //physics: const NeverScrollableScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: 20,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: Sizes.size2,
                    mainAxisSpacing: Sizes.size2,
                    childAspectRatio: 9 / 14,
                  ),
                  // 유저이미지는 인터넷에 올라왔일테고, 구글클라우드 스토리지 (우리)
                  itemBuilder: (context, index) => Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 9 / 14,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            FadeInImage.assetNetwork(
                                fit: BoxFit.cover, // 전체를 덮게함.
                                placeholder: "assets/images/mycat.jpg",
                                image:
                                    "https://plus.unsplash.com/premium_photo-1669612840452-dde22311731d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=874&q=80"),
                            const Positioned(
                              left: 5,
                              bottom: 5,
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.play,
                                    color: Colors.white,
                                    size: Sizes.size12,
                                  ),
                                  Gaps.h6,
                                  Text(
                                    '4.1M',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Sizes.size12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: Text('page two'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserAccount extends StatelessWidget {
  final int count;
  final String text;

  const UserAccount({
    super.key,
    required this.count,
    required this.text,
  });

  String formatCount() {
    if (count > 1000) {
      double countInMillion = count / 10000;
      return "${countInMillion.toStringAsFixed(1)}M";
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          formatCount(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size16,
          ),
        ),
        Gaps.v3,
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
