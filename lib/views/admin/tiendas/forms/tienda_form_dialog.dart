import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_event.dart';
import '../../../../core/blocs/tiendas/tiendas_state.dart';
import '../../../../core/blocs/categorias/categorias_bloc.dart';
import '../../../../core/blocs/categorias/categorias_state.dart';
import '../../../../core/models/ubicacion.dart';
import '../../../../core/models/contacto.dart';
import '../../../../core/services/categoria_service.dart';
import '../components/location_picker_map.dart';

class TiendaFormDialog extends StatefulWidget {
  final int? tiendaId; // Para editar

  const TiendaFormDialog({super.key, this.tiendaId});

  @override
  State<TiendaFormDialog> createState() => _TiendaFormDialogState();
}

class _TiendaFormDialogState extends State<TiendaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _nombrePropietarioController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _horarioController = TextEditingController();

  int? _selectedCategoriaId;
  Ubicacion _ubicacion = Ubicacion(
    lat: -16.5000,
    lng: -68.1193,
  ); // La Paz por defecto
  List<String> _diasSeleccionados = [];

  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  bool get isEditing => widget.tiendaId != null;

  @override
  void initState() {
    super.initState();

    // Si es edición, cargar datos de la tienda
    if (isEditing) {
      _loadTiendaData();
    } else {
      // Valores por defecto para nueva tienda
      _horarioController.text = '08:00 - 18:00';
      _diasSeleccionados = [
        'Lunes',
        'Martes',
        'Miércoles',
        'Jueves',
        'Viernes',
      ];
    }
  }

  void _loadTiendaData() {
    final state = context.read<TiendasBloc>().state;
    if (state is TiendasLoaded) {
      final tienda =
          state.todasLasTiendas
              .where((t) => t.id == widget.tiendaId)
              .firstOrNull;

      if (tienda != null) {
        _nombreController.text = tienda.nombre;
        _nombrePropietarioController.text = tienda.nombrePropietario;
        _direccionController.text = tienda.direccion ?? '';
        _telefonoController.text = tienda.contacto?.telefono ?? '';
        _horarioController.text = tienda.horarioAtencion;
        _selectedCategoriaId = tienda.categoryId;
        _ubicacion = tienda.ubicacion;
        _diasSeleccionados = List.from(tienda.diasAtencion);
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _nombrePropietarioController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _horarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = (screenSize.width * 0.95).clamp(300.0, 800.0);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenSize.height * 0.9,
            minHeight: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit : Icons.add,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEditing ? 'Editar Tienda' : 'Nueva Tienda',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Información básica
                        const Text(
                          'Información Básica',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Nombre de la tienda
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de la tienda *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.store),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Nombre del propietario
                        TextFormField(
                          controller: _nombrePropietarioController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del propietario *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre del propietario es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Categoría
                        _buildCategoriaSelector(),
                        const SizedBox(height: 16),

                        // Dirección
                        TextFormField(
                          controller: _direccionController,
                          decoration: const InputDecoration(
                            labelText: 'Dirección',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Teléfono
                        TextFormField(
                          controller: _telefonoController,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),

                        // Ubicación en el mapa
                        const Text(
                          'Ubicación en el Mapa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LocationPickerMap(
                          initialLocation: _ubicacion,
                          onLocationChanged: (ubicacion) {
                            setState(() {
                              _ubicacion = ubicacion;
                            });
                          },
                          height: 200,
                        ),
                        const SizedBox(height: 24),

                        // Horarios de atención
                        const Text(
                          'Horarios de Atención',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Horario
                        TextFormField(
                          controller: _horarioController,
                          decoration: const InputDecoration(
                            labelText: 'Horario (ej: 08:00 - 18:00)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El horario es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Días de atención
                        const Text(
                          'Días de atención:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDiasSelector(),
                      ],
                    ),
                  ),
                ),
              ),

              // Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isEditing ? 'Actualizar' : 'Crear'),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriaSelector() {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, state) {
        if (state is CategoriasLoaded) {
          final categorias = state.todasLasCategorias;

          return DropdownButtonFormField<int?>(
            value: _selectedCategoriaId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
              labelText: 'Categoría *',
            ),
            isExpanded: true,
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Selecciona una categoría'),
              ),
              ...categorias.map((categoria) {
                return DropdownMenuItem<int?>(
                  value: categoria.id,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getColorFromHex(
                            categoria.color,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          _getIconFromString(categoria.icon ?? 'category'),
                          color: _getColorFromHex(categoria.color),
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          categoria.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategoriaId = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Selecciona una categoría';
              }
              return null;
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDiasSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          _diasSemana.map((dia) {
            final isSelected = _diasSeleccionados.contains(dia);
            return FilterChip(
              label: Text(dia),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _diasSeleccionados.add(dia);
                  } else {
                    _diasSeleccionados.remove(dia);
                  }
                });
              },
              selectedColor: Colors.green[100],
              checkmarkColor: Colors.green[700],
            );
          }).toList(),
    );
  }

  Color _getColorFromHex(String? hexColor) {
    if (hexColor == null) return Colors.grey;
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getIconFromString(String iconName) {
    final iconMap = CategoriaService.availableIcons.firstWhere(
      (icon) => icon['name'] == iconName,
      orElse: () => CategoriaService.availableIcons.first,
    );
    return iconMap['icon'] as IconData;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos un día de atención'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final nombre = _nombreController.text.trim();
    final nombrePropietario = _nombrePropietarioController.text.trim();
    final direccion = _direccionController.text.trim();
    final telefono = _telefonoController.text.trim();
    final horario = _horarioController.text.trim();

    // Crear objeto contacto si hay teléfono
    final contacto = telefono.isNotEmpty ? Contacto(telefono: telefono) : null;

    if (isEditing) {
      // Actualizar tienda existente
      context.read<TiendasBloc>().add(
        ActualizarTienda(
          id: widget.tiendaId!,
          name: nombre,
          ownerName: nombrePropietario,
          ubicacion: _ubicacion,
          categoryId: _selectedCategoriaId!,
          contacto: contacto,
          address: direccion.isNotEmpty ? direccion : null,
          schedules: _diasSeleccionados,
          operatingHours: horario,
        ),
      );
    } else {
      // Crear nueva tienda
      context.read<TiendasBloc>().add(
        CrearTienda(
          name: nombre,
          ownerName: nombrePropietario,
          ubicacion: _ubicacion,
          categoryId: _selectedCategoriaId!,
          contacto: contacto,
          address: direccion.isNotEmpty ? direccion : null,
          schedules: _diasSeleccionados,
          operatingHours: horario,
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
