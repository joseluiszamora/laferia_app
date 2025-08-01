import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import '../../../core/models/producto.dart';
import '../../../core/models/producto_medias.dart';
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

  // Campos para manejo de imágenes y medios
  List<ProductoMedias> _existingMedias = [];
  List<Map<String, dynamic>> _newMedias = [];
  List<int> _mediasToDelete = [];
  bool _isUploadingImage = false;
  final ImagePicker _imagePicker = ImagePicker();

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

    // Cargar medios existentes
    _existingMedias = List.from(producto.medias);
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
        // Agregar información de medios
        'medias': _newMedias,
        'medias_to_delete': _mediasToDelete,
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

  // Selección y subida real de imagen
  void _addImage() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Seleccionar imagen',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Tomar foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Elegir de galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancelar'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _isUploadingImage = true;
        });

        await _uploadImageToSupabase(image);
      }
    } on Exception catch (e) {
      String errorMessage = 'Error al seleccionar imagen';

      if (e.toString().contains('photo_access_denied') ||
          e.toString().contains('camera_access_denied')) {
        errorMessage =
            'Permisos denegados. Por favor, habilita el acceso a la ${source == ImageSource.camera ? 'cámara' : 'galería'} en configuración.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _uploadImageToSupabase(XFile imageFile) async {
    try {
      // Verificar tamaño del archivo (máximo 5MB)
      final fileSize = await imageFile.length();
      const maxSizeInBytes = 5 * 1024 * 1024; // 5MB

      if (fileSize > maxSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La imagen es demasiado grande. Máximo 5MB permitido.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final supabase = Supabase.instance.client;

      // Generar nombre único para el archivo
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = imageFile.path.split('.').last.toLowerCase();

      // Validar extensión de archivo
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Formato de imagen no soportado. Use JPG, PNG o WebP.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final fileName = 'producto_${timestamp}.$extension';

      // Leer el archivo como bytes
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Subir archivo a Supabase Storage
      await supabase.storage
          .from('productos')
          .uploadBinary(
            fileName,
            imageBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Obtener URL pública del archivo
      final imageUrl = supabase.storage
          .from('productos')
          .getPublicUrl(fileName);

      // Agregar imagen a la lista
      setState(() {
        _newMedias.add({
          'media_url': imageUrl,
          'media_type': 'image',
          'is_primary': _newMedias.isEmpty && _existingMedias.isEmpty,
          'alt_text': 'Imagen del producto',
          'order_index': _newMedias.length + _existingMedias.length,
          'file_name': fileName, // Guardar nombre para posible eliminación
          'file_size': fileSize,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imagen subida exitosamente (${(fileSize / 1024 / 1024).toStringAsFixed(1)} MB)',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on StorageException catch (e) {
      String errorMessage = 'Error al subir imagen';

      switch (e.statusCode) {
        case '413':
          errorMessage = 'La imagen es demasiado grande';
          break;
        case '415':
          errorMessage = 'Formato de imagen no soportado';
          break;
        case '403':
          errorMessage = 'Sin permisos para subir archivos';
          break;
        default:
          errorMessage = 'Error de almacenamiento: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado al subir imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeExistingMedia(int index) {
    setState(() {
      final media = _existingMedias[index];
      _mediasToDelete.add(media.id);
      _existingMedias.removeAt(index);
    });
  }

  void _removeNewMedia(int index) async {
    final media = _newMedias[index];

    // Si tiene nombre de archivo, eliminar de Supabase Storage
    if (media['file_name'] != null) {
      try {
        final supabase = Supabase.instance.client;
        await supabase.storage.from('productos').remove([media['file_name']]);
      } catch (e) {
        print('Error al eliminar archivo de storage: $e');
        // No mostrar error al usuario, solo log
      }
    }

    setState(() {
      _newMedias.removeAt(index);
    });
  }

  void _setAsPrimaryMedia(int existingIndex, int newIndex) {
    setState(() {
      // Quitar primary de todos los nuevos medios
      for (var media in _newMedias) {
        media['is_primary'] = false;
      }

      // Establecer el nuevo primary
      if (existingIndex >= 0) {
        // Para medios existentes, necesitaríamos actualizar el modelo
        // Por ahora solo manejamos los nuevos medios
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funcionalidad disponible solo para nuevas imágenes'),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (newIndex >= 0) {
        _newMedias[newIndex]['is_primary'] = true;
      }
    });
  }

  Widget _buildMediaSection() {
    final allMedias = <Widget>[];

    // Agregar medios existentes
    for (int i = 0; i < _existingMedias.length; i++) {
      final media = _existingMedias[i];
      allMedias.add(
        _buildMediaItem(
          imageUrl: media.url,
          isPrimary: media.isMain,
          isNew: false,
          onRemove: () => _removeExistingMedia(i),
          onSetPrimary: () => _setAsPrimaryMedia(i, -1),
        ),
      );
    }

    // Agregar nuevos medios
    for (int i = 0; i < _newMedias.length; i++) {
      final media = _newMedias[i];
      allMedias.add(
        _buildMediaItem(
          imageUrl: media['media_url'],
          isPrimary: media['is_primary'] ?? false,
          isNew: true,
          onRemove: () => _removeNewMedia(i),
          onSetPrimary: () => _setAsPrimaryMedia(-1, i),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Imágenes del producto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: _isUploadingImage ? null : _addImage,
              icon:
                  _isUploadingImage
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.add_photo_alternate),
              label: Text(_isUploadingImage ? 'Subiendo...' : 'Agregar Imagen'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (allMedias.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'No hay imágenes agregadas',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _isUploadingImage ? null : _addImage,
                  icon:
                      _isUploadingImage
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.add_photo_alternate),
                  label: Text(
                    _isUploadingImage
                        ? 'Subiendo...'
                        : 'Agregar Primera Imagen',
                  ),
                ),
              ],
            ),
          )
        else
          Wrap(spacing: 12, runSpacing: 12, children: allMedias),
        const SizedBox(height: 16),
        if (allMedias.isNotEmpty)
          Text(
            'Tip: Toca el ícono de estrella para establecer como imagen principal',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildMediaItem({
    required String imageUrl,
    required bool isPrimary,
    required bool isNew,
    required VoidCallback onRemove,
    required VoidCallback onSetPrimary,
  }) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPrimary ? Colors.blue : Colors.grey.shade300,
              width: isPrimary ? 3 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),

        // Badge de "Nueva" imagen
        if (isNew)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NUEVA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Badge de imagen principal
        if (isPrimary)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 16),
            ),
          ),

        // Botones de acción
        Positioned(
          bottom: 4,
          right: 4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón establecer como principal
              if (!isPrimary)
                GestureDetector(
                  onTap: onSetPrimary,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              const SizedBox(width: 4),

              // Botón eliminar
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminProductosBloc, AdminProductosState>(
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
        } else if (state is AdminProductoOperationLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is AdminProductosError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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

              // Sección de imágenes y medios
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildMediaSection(),
                ),
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
                          _isEditing ? 'Actualizar Producto' : 'Crear Producto',
                          style: const TextStyle(fontSize: 16),
                        ),
              ),
            ],
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
