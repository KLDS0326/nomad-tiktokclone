import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).muted,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setMuted(value),
            title: const Text("Aute Mute"),
            subtitle: const Text("Videos muted by default."),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).autoplay,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setAutoplay(value),
            title: const Text("Autoplay"),
            subtitle: const Text("Video will start playing automatically."),
          ),
          Switch(
            value: false,
            onChanged: (value) {},
          ),
          Checkbox(
            value: false,
            onChanged: (value) {},
          ),
          CheckboxListTile(
            checkColor: Colors.red,
            activeColor: Colors.yellow,
            value: false,
            onChanged: (value) {},
            title: const Text("Enable notifications"),
          ),
          ListTile(
            onTap: () => showAboutDialog(
                context: context,
                applicationVersion: "1.0",
                applicationLegalese: "All rights reserved. plz don't copy me."),
            title: const Text("About"),
            subtitle: const Text("About this app..."),
          ),
          const AboutListTile(),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2024),
              );
              print(date);

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time);

              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1990),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              print(booking);
            },
            title: const Text("What is your Birthday?"),
          ),
          ListTile(
            title: const Text(
              "LOG OUT (IOS)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Colors.red,
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("로그아웃 하시겠습니까?"),
                  content: const Text("다음에 또 뵙겠습니다."),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("아니요"),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        ref.read(authRepo).signOut();
                        context.go("/");
                      },
                      child: const Text("네"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "LOG OUT (Android)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const FaIcon(FontAwesomeIcons.skull),
                  title: const Text("로그아웃 하시겠습니까?"),
                  content: const Text("다음에 또 뵙겠습니다."),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const FaIcon(FontAwesomeIcons.buildingUser),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("네"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              "LOG OUT (IOS/BOTTOM)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            textColor: Colors.red,
            onTap: () {
              // 위에 뜸 & 바깥을 눌러도 취소가 안됨.->  showCupertinoDialog
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  message: const Text("다음에 또 뵙겠습니다."),
                  title: const Text("로그아웃 하시겠습니까?"),
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDefaultAction: true,
                      child: const Text("아니요"),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDestructiveAction: true,
                      child: const Text("네"),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
