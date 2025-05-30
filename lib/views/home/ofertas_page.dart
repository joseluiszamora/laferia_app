import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/ofertas/ofertas_bloc.dart';
import '../../core/blocs/ofertas/ofertas_event.dart';
import '../../core/blocs/ofertas/ofertas_state.dart';
import '../../core/models/oferta.dart';
import 'components/oferta_card.dart';

class OfertasPage extends StatefulWidget {
  const OfertasPage({super.key});

  @override
  State<OfertasPage> createState() => _OfertasPageState();
}

class _OfertasPageState extends State<OfertasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              OfertasBloc()..add(
                const LoadOfertas(
                  usuarioId:
                      'Usuario Actual', // En una app real, esto vendría del usuario autenticado
                ),
              ),
      child: _OfertasPageContent(tabController: _tabController),
    );
  }
}

class _OfertasPageContent extends StatelessWidget {
  final TabController tabController;

  const _OfertasPageContent({required this.tabController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ofertas'),
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(icon: Icon(Icons.send), text: 'Enviadas'),
            Tab(icon: Icon(Icons.inbox), text: 'Recibidas'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OfertasBloc>().add(
                const LoadOfertas(usuarioId: 'Usuario Actual'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<OfertasBloc, OfertasState>(
        builder: (context, state) {
          if (state is OfertasLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OfertasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar ofertas',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<OfertasBloc>().add(
                        const LoadOfertas(usuarioId: 'Usuario Actual'),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is OfertasLoaded) {
            return TabBarView(
              controller: tabController,
              children: [
                // Ofertas enviadas
                _buildOfertasList(
                  ofertas: state.ofertasEnviadas,
                  emptyMessage: 'No has enviado ninguna oferta aún',
                  emptyIcon: Icons.send_outlined,
                  isEnviadas: true,
                  context: context,
                ),
                // Ofertas recibidas
                _buildOfertasList(
                  ofertas: state.ofertasRecibidas,
                  emptyMessage: 'No has recibido ninguna oferta aún',
                  emptyIcon: Icons.inbox_outlined,
                  isEnviadas: false,
                  context: context,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOfertasList({
    required List<Oferta> ofertas,
    required String emptyMessage,
    required IconData emptyIcon,
    required bool isEnviadas,
    required BuildContext context,
  }) {
    if (ofertas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isEnviadas
                  ? 'Explora productos y haz tu primera oferta'
                  : 'Las ofertas que recibas aparecerán aquí',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<OfertasBloc>().add(
          const LoadOfertas(usuarioId: 'Usuario Actual'),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ofertas.length,
        itemBuilder: (context, index) {
          final oferta = ofertas[index];
          return OfertaCard(oferta: oferta, isFromUser: isEnviadas);
        },
      ),
    );
  }
}
