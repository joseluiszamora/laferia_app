import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models/tienda.dart';
import '../../core/blocs/productos/productos_bloc.dart';
import '../../core/blocs/productos/productos_event.dart';
import '../../core/blocs/productos/productos_state.dart';
import 'components/producto_card.dart';
import 'producto_detail_page.dart';

class TiendaDetailPage extends StatelessWidget {
  final Tienda tienda;

  const TiendaDetailPage({super.key, required this.tienda});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ProductosBloc()..add(LoadProductos(tienda.productos)),
      child: Scaffold(
        appBar: AppBar(title: Text(tienda.nombre), elevation: 0),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TiendaHeader(tienda: tienda),
              const SizedBox(height: 16),
              _ProductosSection(tienda: tienda),
            ],
          ),
        ),
      ),
    );
  }
}

class _TiendaHeader extends StatelessWidget {
  final Tienda tienda;

  const _TiendaHeader({required this.tienda});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.primaryColor.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.store, color: theme.primaryColor, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tienda.nombre,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Propietario: ${tienda.nombrePropietario}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tienda.rubroPrincipal,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (tienda.calificacion != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < tienda.calificacion!.floor()
                                    ? Icons.star
                                    : index < tienda.calificacion!
                                    ? Icons.star_half
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              tienda.calificacion!.toStringAsFixed(1),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Información de ubicación
            if (tienda.direccion != null)
              _InfoRow(
                icon: Icons.location_on,
                title: 'Dirección',
                subtitle: tienda.direccion!,
              ),

            // Información de días y horarios de atención
            _InfoRow(
              icon: Icons.calendar_today,
              title: 'Días de atención',
              subtitle: tienda.diasAtencion.join(', '),
            ),

            _InfoRow(
              icon: Icons.access_time,
              title: 'Horario de atención',
              subtitle: tienda.horarioAtencion,
            ),

            // Información de contacto y horario
            if (tienda.horario != null)
              _InfoRow(
                icon: Icons.schedule,
                title: 'Horario completo',
                subtitle: tienda.horario!,
              ),

            if (tienda.contacto?.telefono != null)
              _InfoRow(
                icon: Icons.phone,
                title: 'Teléfono',
                subtitle: tienda.contacto!.telefono!,
                onTap: () => _launchPhone(tienda.contacto!.telefono!),
              ),

            if (tienda.contacto?.whatsapp != null)
              _InfoRow(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: tienda.contacto!.whatsapp!,
                onTap: () => _launchWhatsApp(tienda.contacto!.whatsapp!),
              ),

            if (tienda.contacto?.redesSociales?.facebook != null)
              _InfoRow(
                icon: Icons.facebook,
                title: 'Facebook',
                subtitle: tienda.contacto!.redesSociales!.facebook!,
                onTap:
                    () => _launchUrl(tienda.contacto!.redesSociales!.facebook!),
              ),

            if (tienda.contacto?.redesSociales?.instagram != null)
              _InfoRow(
                icon: Icons.camera_alt,
                title: 'Instagram',
                subtitle: tienda.contacto!.redesSociales!.instagram!,
                onTap:
                    () => _launchUrl(
                      'https://instagram.com/${tienda.contacto!.redesSociales!.instagram!.replaceAll('@', '')}',
                    ),
              ),
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/591$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, color: theme.primaryColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.open_in_new, color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductosSection extends StatelessWidget {
  final Tienda tienda;

  const _ProductosSection({required this.tienda});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Productos disponibles',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          BlocBuilder<ProductosBloc, ProductosState>(
            builder: (context, state) {
              if (state is ProductosLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is ProductosError) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar productos',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductosBloc>().add(
                            LoadProductos(tienda.productos),
                          );
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProductosLoaded) {
                if (state.productos.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No hay productos disponibles',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        0.65, // Cambiado de 0.75 a 0.65 para más altura
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.productos.length,
                  itemBuilder: (context, index) {
                    final producto = state.productos[index];
                    return ProductoCard(
                      producto: producto,
                      onTap: () => _navigateToProductoDetail(context, producto),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _navigateToProductoDetail(BuildContext context, producto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductoDetailPage(producto: producto),
      ),
    );
  }
}
