import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [like, share, speed];
  static const List<MenuItem> secondItems = [video];

  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const like = MenuItem(text: 'Like', icon: FontAwesomeIcons.thumbsUp);
  static const speed = MenuItem(text: 'speed', icon: Icons.shutter_speed_rounded);
  static const video = MenuItem(text: 'video', icon: Icons.video_camera_back_sharp);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.like:
      //Do something
        break;
      case MenuItems.speed:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.video:
      //Do something
        break;
    }
  }
}