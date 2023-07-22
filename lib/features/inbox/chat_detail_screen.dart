import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  bool _isWriting = false;

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: ListTile(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: Sizes.size6,
        leading: SizedBox(
          width: 55,
          height: 55,
          child: Stack(
            children: [
              const CircleAvatar(
                radius: Sizes.size24,
                foregroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/3612017',
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 118, 221, 121),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          '후추(${widget.chatId})',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: const Text('Active now'),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.flag,
              color: Colors.black,
              size: Sizes.size20,
            ),
            Gaps.h32,
            FaIcon(
              FontAwesomeIcons.ellipsis,
              color: Colors.black,
              size: Sizes.size20,
            ),
          ],
        ),
      )),
      body: Stack(
        children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size20,
              horizontal: Sizes.size14,
            ),
            itemBuilder: ((context, index) {
              final isMine = index % 2 == 0;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      Sizes.size14,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isMine ? Colors.blue : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(
                          Sizes.size20,
                        ),
                        topRight: const Radius.circular(
                          Sizes.size20,
                        ),
                        bottomLeft: Radius.circular(
                          isMine ? Sizes.size20 : Sizes.size5,
                        ),
                        bottomRight: Radius.circular(
                          !isMine ? Sizes.size20 : Sizes.size5,
                        ),
                      ),
                    ),
                    child: const Text(
                      "how are you today?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size16,
                      ),
                    ),
                  )
                ],
              );
            }),
            separatorBuilder: (context, index) => Gaps.v10,
            itemCount: 10,
          ),
          Positioned(
            bottom: 5,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              height: 130,
              padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size14, vertical: Sizes.size5),
              color: Colors.grey.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      autoComplete(text: '🤣🤣🤣'),
                      Gaps.h5,
                      autoComplete(text: '❤️❤️❤️'),
                      Gaps.h5,
                      autoComplete(text: '👏👏👏'),
                      Gaps.h5,
                      autoComplete(text: '🂱 Share post'),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Sizes.size44,
                          child: TextField(
                            onTap: _onStartWriting,
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              hintText: "Send a message...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  Sizes.size12,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size12,
                                vertical: Sizes.size10,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                  right: Sizes.size14,
                                ),
                                child: Row(
                                  //남은 공간을 다 쓰지말고, 최소한으로만 사용하게끔 세팅
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.faceSmile,
                                      color: Colors.grey.shade900,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gaps.h10,
                      GestureDetector(
                        onTap: _stopWriting,
                        child: Container(
                          child: const FaIcon(FontAwesomeIcons.paperPlane),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class autoComplete extends StatelessWidget {
  final String text;
  const autoComplete({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size12, vertical: Sizes.size4),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            Sizes.size20,
          ),
          topRight: Radius.circular(
            Sizes.size20,
          ),
          bottomLeft: Radius.circular(
            Sizes.size20,
          ),
          bottomRight: Radius.circular(
            Sizes.size20,
          ),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Text(
          text,
          style: const TextStyle(fontSize: Sizes.size16),
        ),
      ),
    );
  }
}
