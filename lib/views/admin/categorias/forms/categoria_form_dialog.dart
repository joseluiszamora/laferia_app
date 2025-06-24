import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
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
    // Generales
    {
      'name': 'category',
      'icon': Icons.category,
      'tooltip': 'Categoría general',
    },
    {'name': 'store', 'icon': LineIcons.store, 'tooltip': 'Tienda'},
    {
      'name': 'shopping_bag',
      'icon': LineIcons.shoppingBag,
      'tooltip': 'Compras',
    },
    {
      'name': 'shopping_cart',
      'icon': LineIcons.shoppingCart,
      'tooltip': 'Carrito de compras',
    },

    // Autopartes y Vehículos
    {'name': 'car', 'icon': LineIcons.car, 'tooltip': 'Automóviles'},
    {
      'name': 'car_repair',
      'icon': LineIcons.tools,
      'tooltip': 'Reparación de autos',
    },
    {
      'name': 'motorcycle',
      'icon': LineIcons.motorcycle,
      'tooltip': 'Motocicletas',
    },
    {
      'name': 'gas_station',
      'icon': LineIcons.gasPump,
      'tooltip': 'Combustibles',
    },
    {
      'name': 'car_rental',
      'icon': LineIcons.car,
      'tooltip': 'Alquiler de vehículos',
    },
    {'name': 'tire', 'icon': Icons.tire_repair, 'tooltip': 'Neumáticos'},
    {'name': 'bus', 'icon': LineIcons.bus, 'tooltip': 'Transporte público'},
    {'name': 'shuttle', 'icon': LineIcons.shuttleVan, 'tooltip': 'Transporte'},
    {'name': 'truck', 'icon': LineIcons.truck, 'tooltip': 'Camiones'},

    // Ropa y Moda
    {'name': 'tshirt', 'icon': LineIcons.tShirt, 'tooltip': 'Ropa'},
    {'name': 'dress', 'icon': LineIcons.female, 'tooltip': 'Ropa de mujer'},
    {
      'name': 'male_clothes',
      'icon': LineIcons.male,
      'tooltip': 'Ropa de hombre',
    },
    {
      'name': 'baby_clothes',
      'icon': LineIcons.baby,
      'tooltip': 'Ropa infantil',
    },
    {'name': 'laundry', 'icon': Icons.dry_cleaning, 'tooltip': 'Tintorería'},
    {'name': 'hat', 'icon': LineIcons.userTie, 'tooltip': 'Accesorios'},

    // Calzado
    {
      'name': 'shoe',
      'icon': LineIcons.shoePrints,
      'tooltip': 'Calzado general',
    },
    {
      'name': 'running_shoe',
      'icon': LineIcons.running,
      'tooltip': 'Calzado deportivo',
    },
    {
      'name': 'hiking_boot',
      'icon': LineIcons.hiking,
      'tooltip': 'Calzado outdoor',
    },

    // Electrónica y Tecnología
    {'name': 'mobile', 'icon': LineIcons.mobilePhone, 'tooltip': 'Celulares'},
    {'name': 'laptop', 'icon': LineIcons.laptop, 'tooltip': 'Laptops'},
    {'name': 'tablet', 'icon': LineIcons.tablet, 'tooltip': 'Tablets'},
    {'name': 'tv', 'icon': Icons.tv, 'tooltip': 'Televisores'},
    {
      'name': 'headphones',
      'icon': LineIcons.headphones,
      'tooltip': 'Auriculares',
    },
    {'name': 'camera', 'icon': LineIcons.camera, 'tooltip': 'Cámaras'},
    {'name': 'desktop', 'icon': LineIcons.desktop, 'tooltip': 'Computadoras'},
    {
      'name': 'microchip',
      'icon': LineIcons.microchip,
      'tooltip': 'Componentes PC',
    },
    {'name': 'usb', 'icon': LineIcons.usb, 'tooltip': 'Cables y conectores'},
    {'name': 'wifi', 'icon': LineIcons.wifi, 'tooltip': 'Redes'},
    {
      'name': 'smartwatch',
      'icon': LineIcons.clock,
      'tooltip': 'Relojes inteligentes',
    },
    {'name': 'gamepad', 'icon': LineIcons.gamepad, 'tooltip': 'Gaming'},

    // Muebles y Hogar
    {'name': 'home', 'icon': LineIcons.home, 'tooltip': 'Hogar'},
    {'name': 'chair', 'icon': LineIcons.chair, 'tooltip': 'Sillas'},
    {'name': 'bed', 'icon': LineIcons.bed, 'tooltip': 'Dormitorio'},
    {'name': 'table', 'icon': Icons.table_restaurant, 'tooltip': 'Mesas'},
    {'name': 'kitchen', 'icon': LineIcons.utensils, 'tooltip': 'Cocina'},
    {'name': 'bathroom', 'icon': LineIcons.bath, 'tooltip': 'Baño'},
    {'name': 'couch', 'icon': LineIcons.couch, 'tooltip': 'Sala de estar'},
    {
      'name': 'lightbulb',
      'icon': LineIcons.lightbulb,
      'tooltip': 'Iluminación',
    },
    {'name': 'home_decor', 'icon': LineIcons.palette, 'tooltip': 'Decoración'},

    // Mascotas
    {'name': 'dog', 'icon': LineIcons.dog, 'tooltip': 'Perros'},
    {'name': 'cat', 'icon': LineIcons.cat, 'tooltip': 'Gatos'},
    {'name': 'paw', 'icon': LineIcons.paw, 'tooltip': 'Mascotas general'},

    // Comida y Bebidas
    {
      'name': 'restaurant',
      'icon': LineIcons.utensils,
      'tooltip': 'Restaurantes',
    },
    {
      'name': 'hamburger',
      'icon': LineIcons.hamburger,
      'tooltip': 'Comida rápida',
    },
    {'name': 'pizza', 'icon': LineIcons.pizzaSlice, 'tooltip': 'Pizza'},
    {'name': 'coffee', 'icon': LineIcons.coffee, 'tooltip': 'Café'},
    {'name': 'wine', 'icon': LineIcons.wineGlass, 'tooltip': 'Vinos'},
    {'name': 'beer', 'icon': LineIcons.beer, 'tooltip': 'Cerveza'},
    {'name': 'cake', 'icon': LineIcons.birthdayCake, 'tooltip': 'Repostería'},
    {
      'name': 'grocery',
      'icon': LineIcons.shoppingBasket,
      'tooltip': 'Supermercado',
    },
    {'name': 'apple', 'icon': LineIcons.apple, 'tooltip': 'Frutas'},
    {'name': 'bread', 'icon': LineIcons.breadSlice, 'tooltip': 'Panadería'},
    {'name': 'fish', 'icon': LineIcons.fish, 'tooltip': 'Pescados y mariscos'},
    {'name': 'meat', 'icon': LineIcons.bacon, 'tooltip': 'Carnes'},

    // Belleza y Salud
    {'name': 'beauty', 'icon': LineIcons.spa, 'tooltip': 'Belleza'},
    {'name': 'spa', 'icon': LineIcons.leaf, 'tooltip': 'Spa y relajación'},
    {'name': 'pharmacy', 'icon': LineIcons.pills, 'tooltip': 'Farmacia'},
    {'name': 'medical', 'icon': LineIcons.stethoscope, 'tooltip': 'Salud'},
    {'name': 'wellness', 'icon': LineIcons.heartbeat, 'tooltip': 'Bienestar'},
    {'name': 'hygiene', 'icon': Icons.sanitizer, 'tooltip': 'Higiene'},

    // Deportes y Fitness
    {'name': 'dumbbell', 'icon': LineIcons.dumbbell, 'tooltip': 'Gimnasio'},
    {
      'name': 'basketball',
      'icon': LineIcons.basketballBall,
      'tooltip': 'Básquetbol',
    },
    {'name': 'tennis', 'icon': LineIcons.tableTennis, 'tooltip': 'Tenis'},
    {'name': 'swimming', 'icon': LineIcons.swimmer, 'tooltip': 'Natación'},
    {
      'name': 'skiing',
      'icon': LineIcons.skiing,
      'tooltip': 'Deportes de invierno',
    },
    {'name': 'golf', 'icon': LineIcons.golfBall, 'tooltip': 'Golf'},
    {'name': 'esports', 'icon': LineIcons.gamepad, 'tooltip': 'Esports'},
    {'name': 'bicycle', 'icon': LineIcons.bicycle, 'tooltip': 'Ciclismo'},
    {'name': 'football', 'icon': LineIcons.footballBall, 'tooltip': 'Fútbol'},
    {
      'name': 'volleyball',
      'icon': LineIcons.volleyballBall,
      'tooltip': 'Voleibol',
    },

    // Herramientas y Construcción
    {'name': 'tools', 'icon': LineIcons.tools, 'tooltip': 'Herramientas'},
    {'name': 'hammer', 'icon': LineIcons.hammer, 'tooltip': 'Construcción'},
    {
      'name': 'screwdriver',
      'icon': LineIcons.screwdriver,
      'tooltip': 'Herramientas manuales',
    },
    {'name': 'wrench', 'icon': LineIcons.wrench, 'tooltip': 'Llaves'},
    {
      'name': 'hardhat',
      'icon': LineIcons.hardHat,
      'tooltip': 'Seguridad industrial',
    },

    // Jardín y Exterior
    {'name': 'leaf', 'icon': LineIcons.leaf, 'tooltip': 'Ecológico'},
    {
      'name': 'seedling',
      'icon': LineIcons.seedling,
      'tooltip': 'Plantas y flores',
    },
    {'name': 'tree', 'icon': LineIcons.tree, 'tooltip': 'Jardín'},
    {'name': 'grass', 'icon': Icons.grass, 'tooltip': 'Césped'},

    // Juguetes y Entretenimiento
    {'name': 'toy_horse', 'icon': LineIcons.horse, 'tooltip': 'Juguetes'},
    {
      'name': 'puzzle',
      'icon': LineIcons.puzzlePiece,
      'tooltip': 'Juegos de mesa',
    },
    {'name': 'dice', 'icon': LineIcons.dice, 'tooltip': 'Juegos'},

    // Música e Instrumentos
    {'name': 'music', 'icon': LineIcons.music, 'tooltip': 'Música'},
    {
      'name': 'guitar',
      'icon': LineIcons.guitar,
      'tooltip': 'Instrumentos musicales',
    },
    {'name': 'drum', 'icon': LineIcons.drum, 'tooltip': 'Percusión'},
    {'name': 'microphone', 'icon': LineIcons.microphone, 'tooltip': 'Audio'},

    // Libros y Educación
    {'name': 'book', 'icon': LineIcons.book, 'tooltip': 'Libros'},
    {
      'name': 'graduation',
      'icon': LineIcons.graduationCap,
      'tooltip': 'Educación',
    },
    {'name': 'library', 'icon': LineIcons.bookOpen, 'tooltip': 'Biblioteca'},
    {'name': 'pen', 'icon': LineIcons.pen, 'tooltip': 'Papelería'},

    // Joyería y Accesorios
    {'name': 'gem', 'icon': LineIcons.gem, 'tooltip': 'Joyería'},
    {'name': 'ring', 'icon': LineIcons.ring, 'tooltip': 'Anillos'},
    {'name': 'crown', 'icon': LineIcons.crown, 'tooltip': 'Lujo'},

    // Arte y Manualidades
    {'name': 'paint_brush', 'icon': LineIcons.paintBrush, 'tooltip': 'Arte'},
    {'name': 'palette', 'icon': LineIcons.palette, 'tooltip': 'Pintura'},

    // Servicios
    {'name': 'business', 'icon': LineIcons.building, 'tooltip': 'Negocios'},
    {
      'name': 'bank',
      'icon': LineIcons.university,
      'tooltip': 'Servicios financieros',
    },
    {'name': 'cleaning', 'icon': LineIcons.broom, 'tooltip': 'Limpieza'},
    {'name': 'delivery', 'icon': LineIcons.truck, 'tooltip': 'Delivery'},
    {'name': 'taxi', 'icon': LineIcons.taxi, 'tooltip': 'Taxi'},
    {'name': 'real_estate', 'icon': LineIcons.key, 'tooltip': 'Inmobiliaria'},
    {'name': 'design', 'icon': LineIcons.paintBrush, 'tooltip': 'Diseño'},
    {'name': 'calendar', 'icon': LineIcons.calendar, 'tooltip': 'Eventos'},

    // Transporte
    {'name': 'train', 'icon': LineIcons.train, 'tooltip': 'Tren'},
    {'name': 'plane', 'icon': LineIcons.plane, 'tooltip': 'Vuelos'},
    {'name': 'ship', 'icon': LineIcons.ship, 'tooltip': 'Barcos'},
    {'name': 'shipping', 'icon': LineIcons.truck, 'tooltip': 'Envíos'},

    // Oficina y Papelería
    {'name': 'briefcase', 'icon': LineIcons.briefcase, 'tooltip': 'Oficina'},
    {'name': 'folder', 'icon': LineIcons.folder, 'tooltip': 'Archivos'},
    {'name': 'printer', 'icon': LineIcons.print, 'tooltip': 'Impresión'},
    {
      'name': 'calculator',
      'icon': LineIcons.calculator,
      'tooltip': 'Calculadora',
    },

    // Otros
    {'name': 'gift', 'icon': LineIcons.gift, 'tooltip': 'Tarjetas de regalo'},
    {'name': 'money', 'icon': LineIcons.dollarSign, 'tooltip': 'Financiero'},
    {'name': 'atm', 'icon': LineIcons.creditCard, 'tooltip': 'Cajero'},
    {'name': 'warehouse', 'icon': LineIcons.warehouse, 'tooltip': 'Inventario'},
    {'name': 'percent', 'icon': LineIcons.percentage, 'tooltip': 'Ofertas'},
    {'name': 'fire', 'icon': LineIcons.fire, 'tooltip': 'Trending/Popular'},
    {'name': 'star', 'icon': LineIcons.star, 'tooltip': 'Premium/Destacado'},
  ];

  final List<String> _availableColors = [
    // Azules
    '#2196F3', // Blue - Tecnología, Servicios
    '#1976D2', // Blue 700 - Electrónica
    '#0277BD', // Light Blue 800 - Autopartes
    '#0288D1', // Light Blue 600 - Transporte
    '#039BE5', // Light Blue 500 - Limpieza
    // Verdes
    '#4CAF50', // Green - Jardín, Naturaleza, Eco
    '#388E3C', // Green 700 - Plantas, Orgánico
    '#2E7D32', // Green 800 - Agricultura
    '#00E676', // Green A400 - Energía renovable
    '#66BB6A', // Green 400 - Salud natural
    '#8BC34A', // Light Green - Alimentación saludable
    '#689F38', // Light Green 700 - Productos naturales
    // Naranjas y Amarillos
    '#FF9800', // Orange - Comida, Restaurantes
    '#F57C00', // Orange 800 - Panadería
    '#FF8F00', // Amber 700 - Bebidas
    '#FFC107', // Amber - Ofertas, Promociones
    '#FFEB3B', // Yellow - Entretenimiento, Diversión
    '#FDD835', // Yellow 600 - Juguetes
    '#FFB300', // Amber 600 - Delivery
    // Rojos y Rosas
    '#F44336', // Red - Urgente, Ofertas especiales
    '#D32F2F', // Red 700 - Automotor
    '#C62828', // Red 800 - Herramientas
    '#E91E63', // Pink - Belleza, Moda femenina
    '#AD1457', // Pink 800 - Cosméticos
    '#EC407A', // Pink 400 - Ropa de mujer
    '#F06292', // Pink 300 - Accesorios
    // Morados y Violetas
    '#9C27B0', // Purple - Lujo, Premium
    '#7B1FA2', // Purple 700 - Joyería
    '#6A1B9A', // Purple 800 - Arte
    '#8E24AA', // Purple 600 - Música
    '#AB47BC', // Purple 400 - Creatividad
    '#673AB7', // Deep Purple - Tecnología avanzada
    '#5E35B1', // Deep Purple 600 - Gaming
    // Marrones
    '#795548', // Brown - Muebles, Madera
    '#5D4037', // Brown 700 - Artesanías
    '#4E342E', // Brown 800 - Cuero
    '#6D4C41', // Brown 600 - Decoración rústica
    '#8D6E63', // Brown 400 - Hogar tradicional
    // Grises y Azul Gris
    '#607D8B', // Blue Grey - Oficina, Profesional
    '#455A64', // Blue Grey 700 - Servicios empresariales
    '#37474F', // Blue Grey 800 - Industria
    '#546E7A', // Blue Grey 600 - Construcción
    '#78909C', // Blue Grey 400 - Equipamiento
    '#90A4AE', // Blue Grey 300 - Neutral
    '#9E9E9E', // Grey - General
    '#757575', // Grey 600 - Básico
    // Verdes Azulados (Teal)
    '#009688', // Teal - Medicina, Salud
    '#00796B', // Teal 700 - Farmacia
    '#00695C', // Teal 800 - Productos médicos
    '#26A69A', // Teal 400 - Bienestar
    '#4DB6AC', // Teal 300 - Spa, Relajación
    // Índigos
    '#3F51B5', // Indigo - Educación, Libros
    '#303F9F', // Indigo 700 - Capacitación
    '#283593', // Indigo 800 - Cursos
    '#5C6BC0', // Indigo 400 - Aprendizaje
    // Colores especiales
    '#FF5722', // Deep Orange - Deportes, Actividad
    '#E65100', // Orange 900 - Fitness extremo
    '#BF360C', // Deep Orange 900 - Aventura
    '#FF7043', // Deep Orange 400 - Deportes recreativos
    // Cyans
    '#00BCD4', // Cyan - Agua, Piscinas
    '#0097A7', // Cyan 700 - Servicios acuáticos
    '#00838F', // Cyan 800 - Plomería
    '#26C6DA', // Cyan 400 - Limpieza de piscinas
    // Limas
    '#CDDC39', // Lime - Ecología
    '#AFD135', // Lime 600 - Productos bio
    '#9BC34A', // Light Green 500 - Orgánico
    // Colores metálicos representados
    '#B0BEC5', // Blue Grey 200 - Metales
    '#78909C', // Blue Grey 400 - Acero
    '#455A64', // Blue Grey 700 - Hierro
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
          final categoriasPrincipales =
              state.categorias
                  .where((cat) => cat.parentId == null || cat.parentId!.isEmpty)
                  .toList();

          return DropdownButtonFormField<String>(
            value: _selectedParentId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.folder),
            ),
            items: [
              const DropdownMenuItem(
                value: null,
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
        itemCount: _availableIcons.length,
        itemBuilder: (context, index) {
          final iconData = _availableIcons[index];
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
