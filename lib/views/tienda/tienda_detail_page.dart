import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/views/tienda/components/tienda_main_info.dart';
import 'package:laferia/views/tienda/components/tienda_header_widget.dart';
import 'package:laferia/views/tienda/components/tienda_productos_section.dart';
import '../../core/models/tienda.dart';
import '../../core/blocs/productos/productos_bloc.dart';
import '../../core/blocs/productos/productos_event.dart';
import '../../core/blocs/comentarios/comentarios.dart';
import '../comentarios/components/comentarios_section.dart';

class TiendaDetailPage extends StatefulWidget {
  final Tienda tienda;

  const TiendaDetailPage({super.key, required this.tienda});

  @override
  State<TiendaDetailPage> createState() => _TiendaDetailPageState();
}

class _TiendaDetailPageState extends State<TiendaDetailPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  ProductosBloc()..add(LoadProductos(widget.tienda.productos)),
        ),
        BlocProvider(create: (context) => ComentariosBloc()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                //* Sección Tienda header
                SliverToBoxAdapter(
                  child: TiendaHeaderWidget(
                    tienda: widget.tienda,
                    onBackPressed: () => Navigator.pop(context),
                    onSearchPressed: () {},
                    onFavoritePressed: () {},
                    onSharePressed: () {
                      // Por ejemplo, usando el paquete 'share_plus'
                      // Share.share('Mira esta tienda: ${tienda.nombre}');
                    },
                  ),
                ),

                SliverToBoxAdapter(
                  child: TiendaMainInfo(tienda: widget.tienda),
                ),

                //* Sección de productos
                SliverToBoxAdapter(
                  child: TiendaProductosSection(tienda: widget.tienda),
                ),

                // //* Sección de comentarios
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ComentariosSection(tiendaId: widget.tienda.id),
                  ),
                ),
                // const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
