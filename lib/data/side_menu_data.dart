import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/side_menu.dart';

class SideMenuData {
  final sideMenu = <SideMenu>[
    SideMenu(
        icon: Icons.audio_file, title: "ශ්‍රවණ දේසනා", routeName: '/audio'),
    SideMenu(
        icon: Icons.video_file_rounded,
        title: "Video දේසනා",
        routeName: '/video'),
    SideMenu(icon: Icons.book_sharp, title: "ධම්ම පුස්තක", routeName: '/books'),
    SideMenu(
        icon: Icons.event_available,
        title: "ඉදිරි දේසනා",
        routeName: '/events'),
    SideMenu(
        icon: Icons.history_edu_sharp,
        title: "හෙළ ඉතිහාසය",
        routeName: '/history'),
    SideMenu(icon: Icons.event, title: "ධම්ම වැඩසටහන්", routeName: '/programs'),
    SideMenu(
        icon: Icons.person_3_rounded,
        title: "දේශකයන් වහන්සේලා",
        routeName: '/preachers'),
    SideMenu(icon: Icons.dock_outlined, title: "විස්තර", routeName: '/about'),
  ];
}
