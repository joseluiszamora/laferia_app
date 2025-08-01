import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/producto.dart';
import '../../../core/blocs/admin_productos/admin_productos.dart';

class AdminProductoFormPage extends StatefulWidget {
  final Producto? producto;

  const AdminProductoFormPage({super.key, this.producto});

  @override
  State<AdminProductoFormPage> createState() => _AdminProductoFormPageState();
}

class _AdminProductoFormPageState extends State<AdminProductoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _weightController = TextEditingController();
  final _lowStockAlertController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;
  bool _acceptOffers = false;
  bool _isAvailable = true;
  bool _isFeatured = false;
  ProductStatus _status = ProductStatus.draft;
  int? _categoryId;
  int? _storeId;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.producto != null;

    // Inicializar valores por defecto
    _lowStockAlertController.text = '5';

    if (_isEditing) {
      _loadProductoData();
    }
  }

  void _loadProductoData() {
    final producto = widget.producto!;
    _nameController.text = producto.name;
    _descriptionController.text = producto.description;
    _shortDescriptionController.text = producto.shortDescription ?? '';
    _priceController.text = producto.price.toString();
    _stockController.text = producto.stock.toString();
    _skuController.text = producto.sku ?? '';
    _barcodeController.text = producto.barcode ?? '';
    _weightController.text = producto.weight?.toString() ?? '';
    _lowStockAlertController.text = producto.lowStockAlert.toString();

    _acceptOffers = producto.acceptOffers;
    _isAvailable = producto.isAvailable;
    _isFeatured = producto.isFeatured;
    _status = producto.status;
    _categoryId = producto.categoryId;
    _storeId = producto.storeId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _shortDescriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _weightController.dispose();
    _lowStockAlertController.dispose();
    super.dispose();
  }

  void _saveProducto() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Crear el mapa de datos del producto
      final productoData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'short_description':
            _shortDescriptionController.text.trim().isEmpty
                ? null
                : _shortDescriptionController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'sku':
            _skuController.text.trim().isEmpty
                ? null
                : _skuController.text.trim(),
        'barcode':
            _barcodeController.text.trim().isEmpty
                ? null
                : _barcodeController.text.trim(),
        'weight':
            _weightController.text.trim().isEmpty
                ? null
                : double.parse(_weightController.text),
        'low_stock_alert': int.parse(_lowStockAlertController.text),
        'accept_offers': _acceptOffers,
        'is_available': _isAvailable,
        'is_featured': _isFeatured,
        'status': _status.value,
        'category_id':
            _categoryId ?? 1, // Categoría por defecto si no se selecciona
        'store_id': _storeId ?? 1, // Tienda por defecto si no se selecciona
        // Generar slug a partir del nombre
        'slug': _nameController.text
            .trim()
            .toLowerCase()
            .replaceAll(' ', '-')
            .replaceAll(RegExp(r'[^a-z0-9\-]'), ''),
      };

      if (_isEditing) {
        // Actualizar producto existente
        context.read<AdminProductosBloc>().add(
          UpdateProducto(
            productoId: widget.producto!.id,
            productoData: productoData,
          ),
        );
      } else {
        // Crear nuevo producto
        context.read<AdminProductosBloc>().add(
          CreateProducto(productoData: productoData),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminProductosBloc(),
      child: BlocListener<AdminProductosBloc, AdminProductosState>(
        listener: (context, state) {
          if (state is AdminProductoOperationSuccess) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(
              context,
              true,
            ); // Devolver true para indicar que hubo cambios
          } else if (state is AdminProductosError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_isEditing ? 'Editar Producto' : 'Nuevo Producto'),
            actions: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: _saveProducto,
                  child: Text(
                    _isEditing ? 'Actualizar' : 'Crear',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Nombre del producto
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción *',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Descripción corta
                TextFormField(
                  controller: _shortDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción corta (opcional)',
                    border: OutlineInputBorder(),
                    helperText: 'Breve descripción para listados',
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                // Precio
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio *',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El precio es obligatorio';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Ingresa un precio válido mayor a 0';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Stock y Alerta de stock bajo
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _stockController,
                        decoration: const InputDecoration(
                          labelText: 'Stock *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El stock es obligatorio';
                          }
                          final stock = int.tryParse(value);
                          if (stock == null || stock < 0) {
                            return 'Stock inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lowStockAlertController,
                        decoration: const InputDecoration(
                          labelText: 'Alerta stock',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            _lowStockAlertController.text =
                                '5'; // Valor por defecto
                            return null;
                          }
                          final alert = int.tryParse(value);
                          if (alert == null || alert < 0) {
                            return 'Valor inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // SKU y Código de barras
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _skuController,
                        decoration: const InputDecoration(
                          labelText: 'SKU (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _barcodeController,
                        decoration: const InputDecoration(
                          labelText: 'Código de barras',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Peso
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso (kg)',
                    border: OutlineInputBorder(),
                    suffixText: 'kg',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return 'Ingresa un peso válido';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Estado del producto
                DropdownButtonFormField<ProductStatus>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Estado del producto',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ProductStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(_getStatusText(status)),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value ?? ProductStatus.draft;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Switches
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Configuraciones',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          title: const Text('Acepta ofertas'),
                          subtitle: const Text(
                            'Los clientes pueden hacer ofertas',
                          ),
                          value: _acceptOffers,
                          onChanged: (value) {
                            setState(() {
                              _acceptOffers = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Disponible'),
                          subtitle: const Text(
                            'El producto está disponible para venta',
                          ),
                          value: _isAvailable,
                          onChanged: (value) {
                            setState(() {
                              _isAvailable = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Producto destacado'),
                          subtitle: const Text(
                            'Se mostrará en secciones especiales',
                          ),
                          value: _isFeatured,
                          onChanged: (value) {
                            setState(() {
                              _isFeatured = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Botón de guardar
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProducto,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            _isEditing
                                ? 'Actualizar Producto'
                                : 'Crear Producto',
                            style: const TextStyle(fontSize: 16),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusText(ProductStatus status) {
    switch (status) {
      case ProductStatus.draft:
        return 'Borrador';
      case ProductStatus.published:
        return 'Publicado';
      case ProductStatus.archived:
        return 'Archivado';
      case ProductStatus.exhausted:
        return 'Agotado';
    }
  }
}
