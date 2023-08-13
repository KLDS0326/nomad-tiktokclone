import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();

  final Duration _scrollDuration = const Duration(microseconds: 200);
  final Curve _scrollCurve = Curves.linear;

  /*List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.teal,
  ]; */

  void _onPageChanged(int page) {
    if (page == _itemCount - 1) {
      _pageController.animateToPage(
        page,
        duration: _scrollDuration,
        curve: _scrollCurve,
      );
      _itemCount = _itemCount + 4;
/*       colors.addAll(
        [
          Colors.blue,
          Colors.red,
          Colors.yellow,
          Colors.teal,
        ],
      ); */
      setState(() {});
    }
  }

  void _onVideoFinished() {
    return;

    /* 영상이 끝나면 다음 영상 자동재생 
     _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    ); */
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    return Future.delayed(
      const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh, //async or future 반환
      displacement: 50,
      edgeOffset: 20,
      color: Theme.of(context).primaryColor,
      strokeWidth: 3,

      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: _itemCount,
        itemBuilder: (context, index) => VideoPost(
          onVideoFinished: _onVideoFinished,
          index: index,
        ),
      ),
    );
  }
}
