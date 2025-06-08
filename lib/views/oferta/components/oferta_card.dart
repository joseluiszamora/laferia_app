import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/ofertas/ofertas_event.dart';
import 'package:laferia/core/blocs/ofertas/ofertas_state.dart';
import '../../../core/models/models.dart';
import '../../../core/blocs/ofertas/ofertas_bloc.dart';

class OfertaCard extends StatelessWidget {
  final Oferta oferta;
  final bool
  isFromUser; // true si la oferta es del usuario actual, false si es para el usuario

  const OfertaCard({super.key, required this.oferta, required this.isFromUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildOfferAmount(),
            const SizedBox(height: 8),
            if (oferta.mensaje.isNotEmpty) ...[
              _buildMessage(),
              const SizedBox(height: 8),
            ],
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage:
              oferta.avatarUsuario != null
                  ? NetworkImage(oferta.avatarUsuario!)
                  : null,
          onBackgroundImageError: (_, __) {},
          child:
              oferta.avatarUsuario == null || oferta.avatarUsuario!.isEmpty
                  ? const Icon(Icons.person)
                  : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                oferta.nombreUsuario,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                oferta.tiempoTranscurrido,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    IconData? chipIcon;

    switch (oferta.estado) {
      case EstadoOferta.pendiente:
        chipColor = Colors.orange;
        chipIcon = Icons.access_time;
        break;
      case EstadoOferta.aceptada:
        chipColor = Colors.green;
        chipIcon = Icons.check_circle;
        break;
      case EstadoOferta.rechazada:
        chipColor = Colors.red;
        chipIcon = Icons.cancel;
        break;
      case EstadoOferta.cancelada:
        chipColor = Colors.grey;
        chipIcon = Icons.block;
        break;
      case EstadoOferta.expirada:
        chipColor = Colors.grey;
        chipIcon = Icons.schedule;
        break;
    }

    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chipIcon != null) ...[
            Icon(chipIcon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            _getStatusText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getStatusText() {
    switch (oferta.estado) {
      case EstadoOferta.pendiente:
        return 'Pendiente';
      case EstadoOferta.aceptada:
        return 'Aceptada';
      case EstadoOferta.rechazada:
        return 'Rechazada';
      case EstadoOferta.cancelada:
        return 'Cancelada';
      case EstadoOferta.expirada:
        return 'Expirada';
    }
  }

  Widget _buildOfferAmount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(
            'Oferta: \$${oferta.montoOferta.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mensaje:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(oferta.mensaje, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (oferta.estado != EstadoOferta.pendiente) {
      return _buildResponseInfo(context);
    }

    return _buildActionButtons(context);
  }

  Widget _buildResponseInfo(BuildContext context) {
    if (oferta.respuestaVendedor?.isNotEmpty == true) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              oferta.estado == EstadoOferta.aceptada
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Respuesta del vendedor:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              oferta.respuestaVendedor!,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<OfertasBloc, OfertasState>(
      builder: (context, state) {
        final isLoading = state is OfertasLoading;

        return Row(
          children: [
            if (isFromUser && oferta.puedeCancelarse) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : () => _cancelarOferta(context),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancelar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ] else if (!isFromUser) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : () => _rechazarOferta(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Rechazar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : () => _aceptarOferta(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Aceptar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _cancelarOferta(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancelar oferta'),
            content: const Text(
              '¿Estás seguro de que quieres cancelar esta oferta?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<OfertasBloc>().add(CancelOferta(oferta.id));
                },
                child: const Text('Sí, cancelar'),
              ),
            ],
          ),
    );
  }

  void _aceptarOferta(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Aceptar oferta'),
            content: Text(
              '¿Aceptar la oferta de \$${oferta.montoOferta.toStringAsFixed(0)}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<OfertasBloc>().add(
                    AcceptOferta(
                      ofertaId: oferta.id,
                      respuestaVendedor:
                          'Oferta aceptada. ¡Gracias por tu interés!',
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  void _rechazarOferta(BuildContext context) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Rechazar oferta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('¿Por qué rechazas esta oferta? (Opcional)'),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<OfertasBloc>().add(
                    RejectOferta(
                      ofertaId: oferta.id,
                      respuestaVendedor:
                          messageController.text.isEmpty
                              ? 'Oferta rechazada'
                              : messageController.text,
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Rechazar'),
              ),
            ],
          ),
    );
  }
}
