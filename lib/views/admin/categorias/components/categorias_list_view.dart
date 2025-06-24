import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_state.dart';
import 'package:laferia/views/admin/categorias/components/categoria_card.dart';

class CategoriasListView extends StatelessWidget {
  const CategoriasListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, state) {
        if (state is CategoriasLoaded) {
          final categorias = state.categoriasFiltradas;

          if (categorias.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron categorías',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              return CategoriaCard(categoria: categoria);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
