import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/services/categoria_service.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_event.dart';
import 'package:laferia/core/blocs/categorias/categorias_state.dart';
import 'package:laferia/core/models/categoria.dart';

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
      // Buscar en todasLasCategorias para evitar problemas con filtros
      final categoria = state.todasLasCategorias.firstWhere(
        (cat) => cat.id == widget.categoriaId,
      );

      _nameController.text = categoria.name;
      _slugController.text = categoria.slug;
      _descriptionController.text = categoria.description ?? '';
      _selectedIcon = categoria.icon ?? 'category';
      _selectedColor = categoria.color ?? '#2196F3';
      // Manejar parentId correctamente: si es vacío o null, asignar null
      _selectedParentId =
          (categoria.parentId?.isEmpty ?? true) ? null : categoria.parentId;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = (screenWidth * 0.9).clamp(300.0, 600.0);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 800,
            minHeight: 400,
          ), // Aumentamos la altura máxima
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
                    Icon(
                      isEditing ? Icons.edit : Icons.add,
                      color: Colors.white,
                    ),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[700],
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParentSelector() {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, state) {
        if (state is CategoriasLoaded) {
          // Obtener todas las categorías disponibles como padre
          List<Categoria> categoriasDisponibles;

          if (isEditing) {
            // Al editar, excluir la categoría actual y todos sus descendientes para evitar ciclos
            final descendientes = _obtenerDescendientes(
              widget.categoriaId!,
              state.todasLasCategorias,
            );
            categoriasDisponibles =
                state.todasLasCategorias
                    .where(
                      (cat) =>
                          cat.id != widget.categoriaId &&
                          !descendientes.contains(cat.id),
                    )
                    .toList();
          } else {
            // Al crear nueva categoría, todas están disponibles
            categoriasDisponibles = List.from(state.todasLasCategorias);
          }

          // Ordenar las categorías jerárquicamente para mejor visualización
          final categoriasOrdenadas = _ordenarCategoriesJerarquicamente(
            categoriasDisponibles,
          );

          // Validar que el parentId seleccionado existe en las categorías disponibles
          final parentIdValido =
              _selectedParentId == null ||
              categoriasDisponibles.any((cat) => cat.id == _selectedParentId);

          // Si el parentId no es válido, resetear a null
          if (!parentIdValido) {
            _selectedParentId = null;
          }

          // Debug: verificar qué categorías están disponibles
          print('=== DEBUG CATEGORIAS DISPONIBLES ===');
          print('Total categorías: ${state.todasLasCategorias.length}');
          print('Categorías disponibles: ${categoriasDisponibles.length}');
          print('Categoría editándose: ${widget.categoriaId}');
          if (isEditing) {
            final descendientes = _obtenerDescendientes(
              widget.categoriaId!,
              state.todasLasCategorias,
            );
            print(
              'Descendientes excluidos: ${descendientes.length} -> $descendientes',
            );
          }
          print(
            'Principales disponibles: ${categoriasDisponibles.where((cat) => cat.parentId == null || cat.parentId!.isEmpty).length}',
          );
          print('=====================================');

          return DropdownButtonFormField<String>(
            value: _selectedParentId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.folder),
              labelText: 'Categoría Padre',
            ),
            isExpanded: true,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Categoría Principal'),
              ),
              ...categoriasOrdenadas.map((categoria) {
                final nivel = _calcularNivelCategoria(
                  categoria.id,
                  categoriasDisponibles,
                );
                final indent = '  ' * nivel; // Indentación visual

                return DropdownMenuItem(
                  value: categoria.id,
                  child: Text(
                    '$indent${categoria.name}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _selectedParentId = value;
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
      height: 200, // Aumentamos la altura para acomodar más iconos
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8, // Aumentamos de 7 a 8 columnas
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 1.0,
        ),
        itemCount: CategoriaService.availableIcons.length,
        itemBuilder: (context, index) {
          final iconData = CategoriaService.availableIcons[index];
          final isSelected = _selectedIcon == iconData['name'];

          return Tooltip(
            message: iconData['tooltip'] ?? iconData['name'],
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIcon = iconData['name'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueGrey[700] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color:
                        isSelected ? Colors.blueGrey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: Icon(
                  iconData['icon'],
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 18, // Reducimos un poco el tamaño del icono
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorSelector() {
    return Container(
      height: 120, // Aumentamos la altura para múltiples filas
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10, // 10 colores por fila
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: CategoriaService.availableColors.length,
        itemBuilder: (context, index) {
          final color = CategoriaService.availableColors[index];
          final isSelected = _selectedColor == color;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child:
                  isSelected
                      ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                        shadows: [Shadow(color: Colors.black, blurRadius: 1)],
                      )
                      : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreview() {
    final selectedIconData =
        CategoriaService.availableIcons.firstWhere(
          (icon) => icon['name'] == (_selectedIcon ?? 'category'),
          orElse: () => CategoriaService.availableIcons.first,
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

  // Función para calcular el nivel jerárquico de una categoría por su ID
  int _calcularNivelCategoria(String categoriaId, List<Categoria> categorias) {
    final categoria = categorias.firstWhere(
      (cat) => cat.id == categoriaId,
      orElse: () => const Categoria(id: '', name: '', slug: ''),
    );

    if (categoria.id.isEmpty ||
        categoria.parentId == null ||
        categoria.parentId!.isEmpty) {
      return 0; // Categoría principal
    }

    int nivel = 1;
    String? currentParentId = categoria.parentId;

    while (currentParentId != null && currentParentId.isNotEmpty) {
      final parent = categorias.firstWhere(
        (cat) => cat.id == currentParentId,
        orElse: () => const Categoria(id: '', name: '', slug: ''),
      );

      if (parent.id.isEmpty) break;

      currentParentId = parent.parentId;
      if (currentParentId != null && currentParentId.isNotEmpty) {
        nivel++;
      }
    }

    return nivel;
  }

  // Función para ordenar categorías jerárquicamente
  List<Categoria> _ordenarCategoriesJerarquicamente(
    List<Categoria> categorias,
  ) {
    final Map<String?, List<Categoria>> categoriasMap = {};

    // Agrupar categorías por parentId
    for (final categoria in categorias) {
      final parentId =
          categoria.parentId?.isEmpty == true ? null : categoria.parentId;
      categoriasMap[parentId] ??= [];
      categoriasMap[parentId]!.add(categoria);
    }

    List<Categoria> resultado = [];

    // Función recursiva para agregar categorías en orden jerárquico
    void agregarCategoriasRecursivamente(String? parentId, int nivel) {
      final categoriasDelNivel = categoriasMap[parentId] ?? [];
      categoriasDelNivel.sort((a, b) => a.name.compareTo(b.name));

      for (final categoria in categoriasDelNivel) {
        resultado.add(categoria);
        // Recursivamente agregar subcategorías
        agregarCategoriasRecursivamente(categoria.id, nivel + 1);
      }
    }

    // Comenzar con categorías principales (parentId = null)
    agregarCategoriasRecursivamente(null, 0);

    return resultado;
  }

  // Función para obtener todos los descendientes (subcategorías) de una categoría
  Set<String> _obtenerDescendientes(
    String categoriaId,
    List<Categoria> todasLasCategorias,
  ) {
    final Set<String> descendientes = {};

    // Función recursiva para encontrar todos los descendientes
    void buscarDescendientes(String parentId) {
      final hijos =
          todasLasCategorias.where((cat) => cat.parentId == parentId).toList();

      for (final hijo in hijos) {
        descendientes.add(hijo.id);
        // Recursivamente buscar los descendientes de este hijo
        buscarDescendientes(hijo.id);
      }
    }

    buscarDescendientes(categoriaId);
    return descendientes;
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
