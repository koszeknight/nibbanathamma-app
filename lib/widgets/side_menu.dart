import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/data/side_menu_data.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIdex = 0;
  final sideMenuData = SideMenuData();

  void _navigate(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.black26,
      child: ListView.builder(
          itemCount: sideMenuData.sideMenu.length,
          itemBuilder: (context, index) {
            return _sideMenuList(sideMenuData, index);
          }),
    );
  }

  Widget _sideMenuList(SideMenuData sideMenuData, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIdex = index;
          _navigate(sideMenuData.sideMenu[index].routeName);
          // navigator(sideMenuData.sideMenu[index].title, context);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: selectedIdex == index
                ? Colors.yellowAccent
                : Colors.transparent),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(sideMenuData.sideMenu[index].icon,
                  color: selectedIdex == index ? Colors.black : Colors.yellow),
              SizedBox(
                width: 10,
              ),
              Text(
                sideMenuData.sideMenu[index].title,
                style: TextStyle(
                    color: selectedIdex == index ? Colors.black : Colors.yellow,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }

  // static navigator(String navigatePage, context) {
  //   if (navigatePage == "Audio Deshana") {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const AudioPage()),
  //     );
  //   }
  // }
}
