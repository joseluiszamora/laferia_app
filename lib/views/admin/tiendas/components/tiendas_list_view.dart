import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_event.dart';
import '../../../../core/blocs/tiendas/tiendas_state.dart';
import 'tienda_card.dart';

class TiendasListView extends StatelessWidget {
  const TiendasListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TiendasBloc, TiendasState>(
      builder: (context, state) {
        if (state is TiendasLoaded) {
          final tiendas = state.tiendasFiltradas;

          if (tiendas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron tiendas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Intenta ajustar los filtros de búsqueda',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<TiendasBloc>().add(LoadTiendas());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tiendas.length,
              itemBuilder: (context, index) {
                final tienda = tiendas[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TiendaCard(tienda: tienda),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
