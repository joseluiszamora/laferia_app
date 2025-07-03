import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/producto.dart';
import '../../../core/blocs/ofertas/ofertas_bloc.dart';
import '../../../core/blocs/ofertas/ofertas_event.dart';
import '../../../core/blocs/ofertas/ofertas_state.dart';

class OfertarProductoDialog extends StatefulWidget {
  final Producto producto;
  final Function(double)? onOfertaEnviada;

  const OfertarProductoDialog({
    super.key,
    required this.producto,
    this.onOfertaEnviada,
  });

  @override
  State<OfertarProductoDialog> createState() => _OfertarProductoDialogState();
}

class _OfertarProductoDialogState extends State<OfertarProductoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ofertaController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _ofertaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final precioMaximo = widget.producto.precioEfectivo;

    return AlertDialog(
      title: const Text('Hacer una oferta'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del producto
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child:
                            widget.producto.tieneImagenes
                                ? Image.network(
                                  widget.producto.imagenPrincipal?.url ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.image, size: 25),
                                    );
                                  },
                                )
                                : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image, size: 25),
                                ),
                      ),
                      // Badge de favorito
                      if (widget.producto.isFeatured)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      // Badge de múltiples imágenes
                      if (widget.producto.cantidadImagenes > 1)
                        Positioned(
                          bottom: 2,
                          left: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${widget.producto.cantidadImagenes}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.producto.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (widget.producto.isFeatured) ...[
                              Icon(
                                Icons.favorite,
                                size: 12,
                                color: Colors.red.shade600,
                              ),
                              const SizedBox(width: 2),
                            ],
                            if (widget.producto.cantidadImagenes > 1) ...[
                              Icon(
                                Icons.photo_library,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${widget.producto.cantidadImagenes}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                widget.producto.categoryId.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (widget.producto.tieneOferta) ...[
                          Text(
                            'Precio original: Bs. ${widget.producto.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            'Precio actual: Bs. ${precioMaximo.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ] else
                          Text(
                            'Precio: Bs. ${precioMaximo.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Campo de oferta
            Text(
              'Tu oferta:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ofertaController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: 'Ingresa tu oferta en Bs.',
                prefixText: 'Bs. ',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _ofertaController.clear(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una oferta';
                }

                final oferta = double.tryParse(value);
                if (oferta == null) {
                  return 'Ingresa un número válido';
                }

                if (oferta <= 0) {
                  return 'La oferta debe ser mayor a 0';
                }

                if (oferta >= precioMaximo) {
                  return 'La oferta debe ser menor al precio actual';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),

            // Información adicional
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'El vendedor recibirá tu oferta y podrá aceptarla o rechazarla.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _enviarOferta,
          child:
              _isSubmitting
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Enviar Oferta'),
        ),
      ],
    );
  }

  void _enviarOferta() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final oferta = double.parse(_ofertaController.text);

    // Usar el BLoC para crear la oferta
    final ofertasBloc = context.read<OfertasBloc>();
    ofertasBloc.add(
      CreateOferta(
        productoId: widget.producto.id,
        montoOferta: oferta,
        mensaje: 'Oferta enviada desde la aplicación',
        nombreUsuario:
            'Usuario Actual', // En una app real, esto vendría del usuario autenticado
        avatarUsuario: null,
      ),
    );

    // Escuchar los cambios del BLoC
    final subscription = ofertasBloc.stream.listen((state) {
      if (mounted) {
        if (state is OfertaCreated) {
          setState(() {
            _isSubmitting = false;
          });

          // Llamar callback si existe
          widget.onOfertaEnviada?.call(oferta);

          Navigator.of(context).pop();

          // Mostrar mensaje de confirmación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Oferta de Bs. ${oferta.toStringAsFixed(0)} enviada correctamente',
              ),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'Ver',
                textColor: Colors.white,
                onPressed: () {
                  // Aquí se podría navegar a una página de ofertas
                },
              ),
            ),
          );
        } else if (state is OfertasError) {
          setState(() {
            _isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    // Cancelar la suscripción después de un tiempo
    Future.delayed(const Duration(seconds: 5), () {
      subscription.cancel();
    });
  }
}
