import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/views/tienda/components/tienda_header.dart';
import 'package:laferia/views/tienda/components/tienda_productos_section.dart';
import '../../core/models/tienda.dart';
import '../../core/blocs/productos/productos_bloc.dart';
import '../../core/blocs/productos/productos_event.dart';
import '../../core/blocs/comentarios/comentarios.dart';
import '../comentarios/components/comentarios_section.dart';

class TiendaDetailPage extends StatelessWidget {
  final Tienda tienda;

  const TiendaDetailPage({super.key, required this.tienda});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  ProductosBloc()..add(LoadProductos(tienda.productos)),
        ),
        BlocProvider(create: (context) => ComentariosBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(tienda.nombre),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Aquí puedes implementar la lógica para compartir
                // Por ejemplo, usando el paquete 'share_plus'
                // Share.share('Mira esta tienda: ${tienda.nombre}');
              },
              tooltip: 'Compartir tienda',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Sección Tienda header
              TiendaHeader(tienda: tienda),
              const SizedBox(height: 16),

              //* Sección de productos
              TiendaProductosSection(tienda: tienda),
              const SizedBox(height: 24),

              //* Sección de comentarios
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ComentariosSection(tiendaId: tienda.id),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
