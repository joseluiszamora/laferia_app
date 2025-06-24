import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'categorias/pages/admin_categorias_page.dart';

class AdminCategoriasPages extends StatelessWidget {
  const AdminCategoriasPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriasBloc(),
      child: const AdminCategoriasPage(),
    );
  }
}
