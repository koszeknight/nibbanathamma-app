import 'package:flutter/material.dart';
import 'package:nibbana_dhamma/utills/colors.dart';

class TopTitleBar extends StatelessWidget {
  const TopTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;

        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(236, 255, 223, 83),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Menu Button
                GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromARGB(255, 146, 64, 9),
                    ),
                    child: const Icon(
                      Icons.menu,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Title Section
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "නිබ්බාන ධම්ම",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 18 : 22,
                                color: mainTextColor,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (!isSmallScreen) const SizedBox(height: 2),
                            if (!isSmallScreen)
                              Text(
                                "Nibbana Dhamma",
                                style: TextStyle(
                                  fontSize: 9,
                                  color: mainTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Empty space to balance the menu button
                const SizedBox(
                    width: 52), // Matches menu button width + spacing
              ],
            ),
          ),
        );
      },
    );
  }
}
