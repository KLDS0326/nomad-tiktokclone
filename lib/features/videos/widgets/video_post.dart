import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_action_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;

  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  //클래스의 메서드와 속성을 복사
  //위젯이 보일 때만 Ticker을 제공함.
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/video.mp4");
  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;
  bool _isPaused = false;
  bool _autoMute = videoConfig.value;

  bool _isMuted = true;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    //_videoPlayerController.play();
    await _videoPlayerController.setLooping(true);

    //kIsWeb : 웹에서 작동하도록 컴파일 되었는지 나타내는 constant임.
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this, //offscreen 애니메이션의 불필요한 리소스 막음. 위젯 안보일 때 애니메이션 작동 X
      //애니메이션에 callback을 제공해주는게 Ticker(엄청빠른 시계/프레임)임. 매 프레임마다 호출.
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    videoConfig.addListener(() {
      setState(() {
        _autoMute = videoConfig.value;
      });
    });

    /* _animationController.addListener(
      () {
        print(_animationController.value);
        //build 메소드에게 변화 알리기
        setState(() {});
      },
    ); */
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    //mounted 프로퍼티는 Widget이 마운트 되었는지 아닌지, 알려줌.
    print(mounted);
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); // lowerBound
    } else {
      _videoPlayerController.play();
      _animationController.forward(); //upperBound
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      // Future 은 async ~ await 할 수 있다.
      //Future 은유저가 댓글창을 닫으면 resolve된다.
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
    );
    print('유저가 영상화면으로 돌아갔다는 것을 알 수 있음.');
    _onTogglePause(); //다시 재생
  }

  void _onVolumnToggle() {
    if (_videoPlayerController.value.volume == 0) {
      _videoPlayerController.setVolume(1);
    } else {
      _videoPlayerController.setVolume(0);
    }
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(_animationController.value);
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      /* (info) {
        print(info.visibleFraction * 100);
        print("Video : #${widget.index} is ${info.visibleFraction * 100}  ");
      }, */
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                // animation 값이 변경될 때마다 실행됨.
                child: AnimatedBuilder(
                  // _animationController 값 변화 감지
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child, // AnimatedOpacity를 넘겨주기 위함.
                    );
                  },
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.black,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                _autoMute
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.black,
              ),
              onPressed: () {
                videoConfig.value = !videoConfig.value;
              },
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@지혜",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v24,
                Text(
                  "This is 검암 부동산입니다.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://lh3.googleusercontent.com/a/AGNmyxbL4Yi9AfuVk0aJkpmgKb_Xlzkpiu1LFiOWhLsILA=s576"),
                  child: Text("지혜"),
                ),
                Gaps.v24,
                VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: S.of(context).likeCount(98798711111987)),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(65656),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                ),
                Gaps.v24,
                const VideoActionButton(
                  icon: FontAwesomeIcons.share,
                  text: 'Share',
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onVolumnToggle,
                  child: VideoActionButton(
                    icon: _isMuted
                        ? FontAwesomeIcons.volumeXmark
                        : FontAwesomeIcons.volumeHigh,
                    text: 'Volume',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
