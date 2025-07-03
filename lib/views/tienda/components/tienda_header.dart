import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:laferia/core/models/tienda.dart';
import 'package:laferia/views/common_components/info_row.dart';

class TiendaHeader extends StatelessWidget {
  final Tienda tienda;

  const TiendaHeader({super.key, required this.tienda});

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
              InfoRow(
                icon: Icons.location_on,
                title: 'Dirección',
                subtitle: tienda.direccion!,
              ),

            // Información de días y horarios de atención
            InfoRow(
              icon: Icons.calendar_today,
              title: 'Días de atención',
              subtitle: tienda.diasAtencion.join(', '),
            ),

            InfoRow(
              icon: Icons.access_time,
              title: 'Horario de atención',
              subtitle: tienda.horarioAtencion,
            ),

            // Información de contacto y horario
            if (tienda.horario != null)
              InfoRow(
                icon: Icons.schedule,
                title: 'Horario completo',
                subtitle: tienda.horario!,
              ),

            if (tienda.contacto?.telefono != null)
              InfoRow(
                icon: Icons.phone,
                title: 'Teléfono',
                subtitle: tienda.contacto!.telefono!,
                onTap: () => _launchPhone(tienda.contacto!.telefono!),
              ),

            if (tienda.contacto?.whatsapp != null)
              InfoRow(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: tienda.contacto!.whatsapp!,
                onTap: () => _launchWhatsApp(tienda.contacto!.whatsapp!),
              ),

            if (tienda.contacto?.redesSociales?.facebook != null)
              InfoRow(
                icon: Icons.facebook,
                title: 'Facebook',
                subtitle: tienda.contacto!.redesSociales!.facebook!,
                onTap:
                    () => _launchUrl(tienda.contacto!.redesSociales!.facebook!),
              ),

            if (tienda.contacto?.redesSociales?.instagram != null)
              InfoRow(
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
