import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:laferia/core/layouts/layout_main.dart';
import 'package:laferia/core/constants/app_colors.dart';
import 'package:laferia/views/admin/admin_demo_page.dart';
import 'package:laferia/views/auth/home_page_demo.dart';
import 'package:laferia/views/categorias/categorias_page.dart';
import 'package:laferia/views/design/design_pages.dart';
import 'package:laferia/views/profile/profile_page.dart';
import 'package:laferia/views/home/home_page.dart';
import 'package:laferia/views/navigation/components/header_section.dart';
import 'package:laferia/views/tiendas-maps/markers_maps_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:line_icons/line_icons.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _pageSelected = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //* Pages List
    List<Widget> pages = [
      // const HomePageWithMap(),
      const HomePageDemo(),
      const CategoriasPage(),
      // const TiendaListPage(),
      const HomePage(),
      // const OfertasPage(),
      // const MapsPage(),
      // const MainMap(),
      // TiendasMapsPage(
      //   showControls: true,
      //   defaultCenter: LatLng(-16.4953, -68.1700),
      //   initialZoom: 15.0,
      // ),
      MarkersMapsPage(
        showControls: true,
        defaultCenter: LatLng(-16.4953, -68.1700),
        initialZoom: 15.0,
      ),
      const DesignPagesPage(),
      const AdminDemoPage(),
    ];

    List<String> titles = [
      'Categorías',
      'Ofertas',
      'Inicio',
      'Mapa',
      'UI',
      'Admin',
    ];

    return Scaffold(
      appBar: HeaderSection(
        title: titles[_pageSelected],
        isMainPage:
            _pageSelected == 2, // Check if the current page is the main page
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: GNav(
              curve: Curves.easeIn,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.red[100]!,
              gap: 4,
              activeColor: AppColors.primary,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color:
                  theme.brightness == Brightness.light
                      ? AppColors.primary
                      : Colors.white,
              tabs: [
                GButton(icon: LineIcons.userCircle, text: 'Categorías'),
                GButton(icon: LineIcons.handshake, text: 'Ofertas'),
                GButton(icon: LineIcons.home, text: 'Inicio'),
                GButton(icon: LineIcons.map, text: 'Mapa'),
                GButton(icon: LineIcons.photoVideo, text: 'UI'),
                GButton(icon: Icons.admin_panel_settings, text: 'Admin'),
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
}
