import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/side_menu.dart';

class SideMenuData {
  final sideMenu = <SideMenu>[
    SideMenu(
        icon: Icons.audio_file, title: "ශ්‍රවන දේශනා", routeName: '/audio'),
    SideMenu(
        icon: Icons.video_file_rounded,
        title: "Video දේශනා",
        routeName: '/video'),
    SideMenu(icon: Icons.book_sharp, title: "ධර්ම පුස්ථක", routeName: '/books'),
    SideMenu(
        icon: Icons.event_available,
        title: "ඉදිරි දේශනා",
        routeName: '/events'),
    SideMenu(
        icon: Icons.history_edu_sharp,
        title: "හෙල ඉතිහාසය",
        routeName: '/history'),
    SideMenu(icon: Icons.link, title: "ධම්ම වැඩසටහන්", routeName: '/programs'),
    SideMenu(icon: Icons.link, title: "දේශකයනෝ", routeName: '/preachers'),
    SideMenu(icon: Icons.dock_outlined, title: "වි්ස්තර", routeName: '/about'),
  ];
}
