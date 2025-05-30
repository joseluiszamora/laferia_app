import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback openDrawer;
  final String title;

  const HeaderSection({
    super.key,
    required this.openDrawer,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation,
      leading: IconButton(
        icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black),
        onPressed: openDrawer,
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // CircleAvatar(
        //   radius: 16,
        //   backgroundImage: NetworkImage(
        //     'https://randomuser.me/api/portraits/men/7.jpg',
        //   ),
        // ),
        IconButton(
          icon: Icon(
            Icons.notifications,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            // Acción para notificaciones
          },
        ),
      ],
    );
  }
}
