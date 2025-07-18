import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_event.dart';

import 'package:laferia/views/home/components/banner_section.dart';
import 'package:laferia/views/home/components/category_section.dart';
import 'package:laferia/views/home/components/latest_products_section.dart';
import 'package:laferia/views/home/components/latest_stores_section.dart';
import 'package:laferia/views/home/components/quick_actions_section.dart';
import 'package:laferia/views/home/components/recommended_section.dart';
import 'package:laferia/views/home/components/search_section.dart';
import 'package:laferia/views/home/components/welcome_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriasBloc()..add(LoadMainCategorias()),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              WelcomeSection(),
              const SizedBox(height: 24),

              // Search bar
              SearchSection(),
              const SizedBox(height: 24),

              // Banner section
              BannerSection(),
              const SizedBox(height: 32),

              // Categories section
              CategorySection(),
              const SizedBox(height: 32),

              // latest stores section
              LatestStoresSection(),
              const SizedBox(height: 32),

              // latest products section
              LatestProductsSection(),
              const SizedBox(height: 32),

              // Recommended section
              RecommendedSection(),
              const SizedBox(height: 32),

              // Quick actions section
              QuickActionsSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
