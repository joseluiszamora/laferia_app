import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_event.dart';
import 'package:laferia/core/blocs/categorias/categorias_state.dart';

class CategoriaFormDialog extends StatefulWidget {
  final String? categoriaId; // Para editar
  final String? parentCategoriaId; // Para crear subcategoría

  const CategoriaFormDialog({
    super.key,
    this.categoriaId,
    this.parentCategoriaId,
  });

  @override
  State<CategoriaFormDialog> createState() => _CategoriaFormDialogState();
}

class _CategoriaFormDialogState extends State<CategoriaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedIcon;
  String? _selectedColor;
  String? _selectedParentId;

  bool get isEditing => widget.categoriaId != null;
  bool get isCreatingSubcategory => widget.parentCategoriaId != null;

  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'category', 'icon': Icons.category},
    {'name': 'store', 'icon': Icons.store},
    {'name': 'restaurant', 'icon': Icons.restaurant},
    {'name': 'eco', 'icon': Icons.eco},
    {'name': 'checkroom', 'icon': Icons.checkroom},
    {'name': 'shopping_bag', 'icon': Icons.shopping_bag},
    {'name': 'directions_car', 'icon': Icons.directions_car},
    {'name': 'devices', 'icon': Icons.devices},
    {'name': 'menu_book', 'icon': Icons.menu_book},
    {'name': 'local_pharmacy', 'icon': Icons.local_pharmacy},
    {'name': 'build', 'icon': Icons.build},
    {'name': 'diamond', 'icon': Icons.diamond},
    {'name': 'local_florist', 'icon': Icons.local_florist},
    {'name': 'pets', 'icon': Icons.pets},
    {'name': 'face_retouching_natural', 'icon': Icons.face_retouching_natural},
    {'name': 'sports_soccer', 'icon': Icons.sports_soccer},
    {'name': 'home', 'icon': Icons.home},
    {'name': 'toys', 'icon': Icons.toys},
    {'name': 'music_note', 'icon': Icons.music_note},
    {'name': 'account_balance', 'icon': Icons.account_balance},
    {'name': 'palette', 'icon': Icons.palette},
  ];

  final List<String> _availableColors = [
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#FF9800', // Orange
    '#9C27B0', // Purple
    '#F44336', // Red
    '#795548', // Brown
    '#607D8B', // Blue Grey
    '#FFEB3B', // Yellow
    '#E91E63', // Pink
    '#009688', // Teal
    '#3F51B5', // Indigo
    '#8BC34A', // Light Green
  ];

  @override
  void initState() {
    super.initState();

    // Inicializar valores por defecto
    _selectedIcon = 'category';
    _selectedColor = '#2196F3';
    _selectedParentId = isCreatingSubcategory ? widget.parentCategoriaId : null;

    if (isEditing) {
      _loadCategoriaData();
    }

    // Auto-generar slug cuando cambie el nombre
    _nameController.addListener(_generateSlug);
  }

  void _loadCategoriaData() {
    final state = context.read<CategoriasBloc>().state;
    if (state is CategoriasLoaded) {
      final categoria = state.categorias.firstWhere(
        (cat) => cat.id == widget.categoriaId,
      );

      _nameController.text = categoria.name;
      _slugController.text = categoria.slug;
      _descriptionController.text = categoria.description ?? '';
      _selectedIcon = categoria.icon ?? 'category';
      _selectedColor = categoria.color ?? '#2196F3';
      _selectedParentId = categoria.parentId;
    }
  }

  void _generateSlug() {
    if (!isEditing) {
      final slug = _nameController.text
          .toLowerCase()
          .replaceAll(' ', '-')
          .replaceAll(RegExp(r'[^a-z0-9\-]'), '');
      _slugController.text = slug;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey[700],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(isEditing ? Icons.edit : Icons.add, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Editar Categoría'
                          : isCreatingSubcategory
                          ? 'Nueva Subcategoría'
                          : 'Nueva Categoría',
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
                      // Nombre
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la categoría *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.label),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Slug
                      TextFormField(
                        controller: _slugController,
                        decoration: const InputDecoration(
                          labelText: 'Slug (URL amigable) *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.link),
                          helperText: 'Usado en URLs, debe ser único',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El slug es requerido';
                          }
                          if (!RegExp(r'^[a-z0-9\-]+$').hasMatch(value)) {
                            return 'Solo letras minúsculas, números y guiones';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripción *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción es requerida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Categoría padre (solo si no es subcategoría)
                      if (!isCreatingSubcategory) ...[
                        const Text(
                          'Categoría Padre',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildParentSelector(),
                        const SizedBox(height: 16),
                      ],

                      // Selector de icono
                      const Text(
                        'Icono',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildIconSelector(),
                      const SizedBox(height: 16),

                      // Selector de color
                      const Text(
                        'Color',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildColorSelector(),
                      const SizedBox(height: 24),

                      // Preview
                      _buildPreview(),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isEditing ? 'Actualizar' : 'Crear'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParentSelector() {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, state) {
        if (state is CategoriasLoaded) {
          final categoriasPrincipales =
              state.categorias.where((cat) => cat.parentId == '0').toList();

          return DropdownButtonFormField<String>(
            value: _selectedParentId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.folder),
            ),
            items: [
              const DropdownMenuItem(
                value: '0',
                child: Text('Categoría Principal'),
              ),
              ...categoriasPrincipales.map((categoria) {
                return DropdownMenuItem(
                  value: categoria.id,
                  child: Text(categoria.name),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _selectedParentId = value!;
              });
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildIconSelector() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: _availableIcons.length,
        itemBuilder: (context, index) {
          final iconData = _availableIcons[index];
          final isSelected = _selectedIcon == iconData['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIcon = iconData['name'];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueGrey[700] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.blueGrey[700]! : Colors.grey[300]!,
                ),
              ),
              child: Icon(
                iconData['icon'],
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorSelector() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availableColors.length,
        itemBuilder: (context, index) {
          final color = _availableColors[index];
          final isSelected = _selectedColor == color;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey[300]!,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child:
                  isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreview() {
    final selectedIconData =
        _availableIcons.firstWhere(
          (icon) => icon['name'] == (_selectedIcon ?? 'category'),
          orElse: () => _availableIcons.first,
        )['icon'];

    final selectedColorValue = Color(
      int.parse((_selectedColor ?? '#2196F3').replaceFirst('#', '0xFF')),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vista Previa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: selectedColorValue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  selectedIconData,
                  color: selectedColorValue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text
                          : 'Nombre de la categoría',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _slugController.text.isNotEmpty
                          ? _slugController.text
                          : 'slug-categoria',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      _descriptionController.text.isNotEmpty
                          ? _descriptionController.text
                          : 'Descripción de la categoría',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final slug = _slugController.text.trim();
      final description = _descriptionController.text.trim();

      if (isEditing) {
        context.read<CategoriasBloc>().add(
          ActualizarCategoria(
            id: widget.categoriaId!,
            parentId: _selectedParentId,
            name: name,
            slug: slug,
            description: description.isNotEmpty ? description : null,
            icon: _selectedIcon,
            color: _selectedColor,
          ),
        );
      } else {
        context.read<CategoriasBloc>().add(
          CrearCategoria(
            parentId: _selectedParentId,
            name: name,
            slug: slug,
            description: description.isNotEmpty ? description : null,
            icon: _selectedIcon,
            color: _selectedColor,
          ),
        );
      }

      Navigator.of(context).pop();
    }
  }
}
