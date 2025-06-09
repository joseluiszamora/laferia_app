import 'package:flutter/material.dart';

class HeaderSection extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback openDrawer;
  final String title;
  final bool isMainPage;

  const HeaderSection({
    super.key,
    required this.openDrawer,
    required this.title,
    required this.isMainPage,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String _selectedLocation = 'Feria 16 de Julio';

  final List<Map<String, dynamic>> _locations = [
    {'name': 'Feria 16 de Julio', 'enabled': true},
    {'name': 'Feria de Cochabamba', 'enabled': false},
    {'name': 'Feria de Santa Cruz', 'enabled': false},
  ];

  void _showLocationUnavailable(String location) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$location estará disponible próximamente'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: theme.appBarTheme.elevation,
      leading: IconButton(
        icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black),
        onPressed: widget.openDrawer,
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child:
            widget.isMainPage
                ? _buildLocationDropdown(isDarkMode)
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
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

  Widget _buildLocationDropdown(bool isDarkMode) {
    return Center(
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          final location = _locations.firstWhere((loc) => loc['name'] == value);
          if (location['enabled']) {
            setState(() {
              _selectedLocation = value;
            });
          } else {
            _showLocationUnavailable(value);
          }
        },
        itemBuilder: (BuildContext context) {
          return _locations.map((location) {
            return PopupMenuItem<String>(
              value: location['name'],
              enabled: true,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18,
                    color:
                        location['enabled']
                            ? (isDarkMode ? Colors.white : Colors.black54)
                            : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    location['name'],
                    style: TextStyle(
                      color:
                          location['enabled']
                              ? (isDarkMode ? Colors.white : Colors.black)
                              : Colors.grey,
                      fontWeight:
                          location['enabled']
                              ? FontWeight.normal
                              : FontWeight.w300,
                    ),
                  ),
                  // if (!location['enabled']) ...[
                  //   const SizedBox(width: 4),
                  //   Text(
                  //     '(Próximamente)',
                  //     style: TextStyle(
                  //       color: Colors.grey,
                  //       fontSize: 12,
                  //       fontStyle: FontStyle.italic,
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              _selectedLocation,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
