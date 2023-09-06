import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  /*StatelessWidget인 경우, 메소드는 context를 가질 수 없다.
   build 메소드만 이를 가질 수 있음. 그래서 () => _abc(context) 형태를 가지게 됨.
   이를 하기 싫다면, 모두 지우고 stateful로 변경하면됨.
   무조건 stateless가 좋음. const로 사용할 수도 있고, 전반적으로 코드양이 적어서임.
    */
  void _onDmPressed() {
    context.pushNamed(ChatsScreen.routeName);
  }

  void _onActivityTap() {
    context.pushNamed(ActivityScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('inbox'),
          actions: [
            IconButton(
              onPressed: _onDmPressed,
              icon: const FaIcon(
                FontAwesomeIcons.paperPlane,
              ),
            ),
          ],
        ),
        //너무 고성능 안말들 것임. 두개만 하면되어서...
        body: ListView(
          children: [
            ListTile(
              onTap: _onActivityTap,
              title: const Text(
                "Activity",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size18,
                ),
              ),
              trailing: const FaIcon(
                FontAwesomeIcons.chevronRight,
                size: Sizes.size14,
                color: Colors.black,
              ),
            ),
            Container(
              height: Sizes.size1,
              color: Colors.grey.shade200,
            ),
            ListTile(
              leading: Container(
                width: Sizes.size52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.users,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Text(
                "New followers",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size16,
                ),
              ),
              subtitle: const Text(
                "Messages from followers will appear here",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: Sizes.size14),
              ),
              trailing: const FaIcon(
                FontAwesomeIcons.chevronRight,
                size: Sizes.size14,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }
}
