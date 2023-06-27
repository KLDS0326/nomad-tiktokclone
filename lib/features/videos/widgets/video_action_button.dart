import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoActionButton extends StatelessWidget {
  final IconData _icon;
  final String _text;

  const VideoActionButton({
    super.key,
    required icon,
    required text,
  })  : _icon = icon,
        _text = text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(
          _icon,
          color: Colors.black,
          size: Sizes.size40,
        ),
        Gaps.v5,
        Text(
          _text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
