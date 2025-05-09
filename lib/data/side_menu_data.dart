import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/model/side_menu.dart';

class SideMenuData {
  final sideMenu = <SideMenu>[
    SideMenu(
        icon: Icons.audio_file, title: "Audio Deshana", routeName: '/audio'),
    SideMenu(
        icon: Icons.video_file_rounded,
        title: "Video Deshana",
        routeName: '/video'),
    SideMenu(icon: Icons.book_sharp, title: "Books", routeName: '/books'),
    SideMenu(
        icon: Icons.event_available, title: "Events", routeName: '/events'),
    SideMenu(
        icon: Icons.history_edu_sharp,
        title: "Hela History",
        routeName: '/history'),
    SideMenu(icon: Icons.link, title: "Links", routeName: '/links'),
    SideMenu(
        icon: Icons.contact_page_sharp,
        title: "Contact",
        routeName: '/contact'),
  ];
}
