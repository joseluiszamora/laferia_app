import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:laferia/core/layouts/layout_main.dart';
import 'package:laferia/core/providers/theme_provider.dart';
import 'package:laferia/core/constants/app_colors.dart';
import 'package:laferia/views/categorias/categorias_page.dart';
import 'package:laferia/views/home/home_page.dart';
import 'package:laferia/views/home/ofertas_page.dart';
import 'package:laferia/views/maps/maps_page.dart';
import 'package:laferia/views/maps/simple_offline_map_screen.dart';
import 'package:laferia/views/navigation/components/header_section.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _pageSelected = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //* Pages List
    List<Widget> pages = [
      const HomePage(),
      const CategoriasPage(),
      const OfertasPage(),
      const SimpleOfflineMapScreen(),
    ];

    List<String> titles = ['Inicio', 'Categorias', 'Ofertas', 'Mapa'];

    return Scaffold(
      key: _scaffoldKey,
      appBar: HeaderSection(
        title: titles[_pageSelected],
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: _buildDrawer(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: LayoutMain(content: pages[_pageSelected]),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color:
              theme.brightness == Brightness.light
                  ? AppColors.navigationBarLight
                  : AppColors.navigationBarDark,
          // color: Colors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withAlpha(1)),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              curve: Curves.easeIn,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.red[100]!,
              gap: 8,
              activeColor: AppColors.primary,
              iconSize: 30,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color:
                  theme.brightness == Brightness.light
                      ? AppColors.primary
                      : Colors.white,
              tabs: [
                GButton(icon: LineIcons.home, text: 'Inicio'),
                GButton(icon: LineIcons.userCircle, text: 'Categorias'),
                GButton(icon: LineIcons.handshake, text: 'Ofertas'),
                GButton(icon: LineIcons.map, text: 'Mapa'),
              ],
              selectedIndex: _pageSelected,
              onTabChange: (index) {
                setState(() {
                  _pageSelected = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.person,
            text: 'Perfil',
            onTap: () => _navigateTo(context, '/profile'),
          ),
          _buildDrawerItem(
            icon: Icons.handshake,
            text: 'Mis Ofertas',
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              setState(() {
                _pageSelected = 2; // Cambia a la pestaña de ofertas
              });
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'Historial',
            onTap: () => _navigateTo(context, '/history'),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Configuración',
            onTap: () => _navigateTo(context, '/settings'),
          ),
          // Selector de tema
          ListTile(
            leading: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            title: Text(
              'Tema ${themeProvider.isDarkMode ? 'Oscuro' : 'Claro'}',
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.help,
            text: 'Ayuda',
            onTap: () => _navigateTo(context, '/help'),
          ),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Cerrar sesión',
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(color: const Color(0xFF0bbfdf)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Cargando...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(text), onTap: onTap);
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Cierra el drawer
    Navigator.pushNamed(context, route);
  }

  void _logout(BuildContext context) {
    // Navigator.pop(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar Sesión'),
            content: const Text('¿Está seguro que desea cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar Sesión'),
              ),
            ],
          ),
    ); // Cierra el drawer
  }
} // Lógica para cerrar sesión
