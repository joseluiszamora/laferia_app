import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import '../../../core/models/producto.dart';
import '../../../core/models/producto_medias.dart';
import '../../../core/models/producto_atributos.dart';
import '../../../core/models/categoria.dart';
import '../../../core/blocs/admin_productos/admin_productos.dart';
import '../../../core/services/supabase_categoria_service.dart';

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

  // Lista de categorías disponibles
  List<Categoria> _categorias = [];
  bool _isLoadingCategorias = true;

  // Campos para manejo de imágenes y medios
  List<ProductoMedias> _existingMedias = [];
  List<Map<String, dynamic>> _newMedias = [];
  List<int> _mediasToDelete = [];
  bool _isUploadingImage = false;
  final ImagePicker _imagePicker = ImagePicker();

  // Campos para manejo de atributos
  List<ProductoAtributos> _existingAtributos = [];
  List<Map<String, dynamic>> _newAtributos = [];
  List<int> _atributosToDelete = [];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.producto != null;

    // Inicializar valores por defecto
    _lowStockAlertController.text = '5';

    // Cargar categorías
    _loadCategorias();

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

    // Cargar atributos existentes
    _existingAtributos = List.from(producto.atributos);
  }

  Future<void> _loadCategorias() async {
    try {
      final categorias = await SupabaseCategoriaService.getAllCategorias();
      setState(() {
        _categorias = categorias;
        _isLoadingCategorias = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategorias = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar categorías: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            _categoryId, // Ahora es obligatorio seleccionar categoría
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
        // Agregar información de atributos
        'atributos': _newAtributos, // Solo atributos completamente nuevos
        'atributos_existentes':
            _existingAtributos
                .map((attr) => attr.toJson())
                .toList(), // Atributos existentes (editados o no)
        'atributos_to_delete': _atributosToDelete,
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
          'url': imageUrl,
          'type': 'image',
          'is_main': _newMedias.isEmpty && _existingMedias.isEmpty,
          'is_active': true,
          'alt_text': 'Imagen del producto',
          'order': _newMedias.length + _existingMedias.length,
          'file_name': fileName, // Guardar nombre para posible eliminación
          'file_size': fileSize,
          'created_at': DateTime.now().toIso8601String(),
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
        media['is_main'] = false;
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
        _newMedias[newIndex]['is_main'] = true;
      }
    });
  }

  // Métodos para gestión de atributos
  void _addAtributo() {
    showDialog(
      context: context,
      builder:
          (context) => _AtributoDialog(
            onSave: (atributo) {
              setState(() {
                _newAtributos.add(atributo);
              });
            },
          ),
    );
  }

  void _editAtributo(int index, bool isExisting) {
    Map<String, dynamic> atributoData;

    if (isExisting) {
      final atributo = _existingAtributos[index];
      atributoData = {
        'name': atributo.name,
        'value': atributo.value,
        'type': atributo.type,
        'unity': atributo.unity,
        'is_visible': atributo.isVisible,
      };
    } else {
      atributoData = Map<String, dynamic>.from(_newAtributos[index]);
    }

    showDialog(
      context: context,
      builder:
          (context) => _AtributoDialog(
            initialData: atributoData,
            onSave: (atributo) {
              setState(() {
                if (isExisting) {
                  // Para atributos existentes, marcamos para actualización
                  _existingAtributos[index] = _existingAtributos[index]
                      .copyWith(
                        name: atributo['name'],
                        value: atributo['value'],
                        type: atributo['type'],
                        unity: atributo['unity'],
                        isVisible: atributo['is_visible'],
                      );
                } else {
                  _newAtributos[index] = atributo;
                }
              });
            },
          ),
    );
  }

  void _removeExistingAtributo(int index) {
    setState(() {
      final atributo = _existingAtributos[index];
      _atributosToDelete.add(atributo.id);
      _existingAtributos.removeAt(index);
    });
  }

  void _removeNewAtributo(int index) {
    setState(() {
      _newAtributos.removeAt(index);
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
          imageUrl: media['url'],
          isPrimary: media['is_main'] ?? false,
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

  Widget _buildAtributosSection() {
    final allAtributos = <Widget>[];

    // Agregar atributos existentes
    for (int i = 0; i < _existingAtributos.length; i++) {
      final atributo = _existingAtributos[i];
      allAtributos.add(
        _buildAtributoItem(
          name: atributo.name,
          value: atributo.value,
          type: atributo.type,
          unity: atributo.unity,
          isNew: false,
          onEdit: () => _editAtributo(i, true),
          onRemove: () => _removeExistingAtributo(i),
        ),
      );
    }

    // Agregar nuevos atributos
    for (int i = 0; i < _newAtributos.length; i++) {
      final atributo = _newAtributos[i];
      allAtributos.add(
        _buildAtributoItem(
          name: atributo['name'] ?? '',
          value: atributo['value'] ?? '',
          type: atributo['type'] ?? 'text',
          unity: atributo['unity'],
          isNew: true,
          onEdit: () => _editAtributo(i, false),
          onRemove: () => _removeNewAtributo(i),
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
              'Atributos del producto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: _addAtributo,
              icon: const Icon(Icons.add),
              label: const Text('Agregar Atributo'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (allAtributos.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(Icons.tune, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'No hay atributos agregados',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _addAtributo,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Primer Atributo'),
                ),
              ],
            ),
          )
        else
          Column(children: allAtributos),
        const SizedBox(height: 16),
        if (allAtributos.isNotEmpty)
          Text(
            'Ejemplo: Color: Azul, Talla: M, Material: Algodón',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildAtributoItem({
    required String name,
    required String value,
    required String type,
    String? unity,
    required bool isNew,
    required VoidCallback onEdit,
    required VoidCallback onRemove,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isNew ? Colors.green.shade100 : Colors.blue.shade100,
          child: Icon(
            _getAtributoIcon(type),
            color: isNew ? Colors.green.shade700 : Colors.blue.shade700,
            size: 20,
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          unity != null ? '$value $unity' : value,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNew)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'NUEVO',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAtributoIcon(String type) {
    switch (type.toLowerCase()) {
      case 'color':
        return Icons.palette;
      case 'size':
      case 'talla':
        return Icons.straighten;
      case 'weight':
      case 'peso':
        return Icons.scale;
      case 'material':
        return Icons.texture;
      case 'number':
        return Icons.numbers;
      case 'boolean':
        return Icons.check_box;
      default:
        return Icons.text_fields;
    }
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

              const SizedBox(height: 16),

              // Selector de categoría
              _isLoadingCategorias
                  ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Cargando categorías...'),
                      ],
                    ),
                  )
                  : _categorias.isEmpty
                  ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('No se pudieron cargar categorías'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoadingCategorias = true;
                            });
                            _loadCategorias();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                  : DropdownButtonFormField<int>(
                    value: _categoryId,
                    decoration: const InputDecoration(
                      labelText: 'Categoría *',
                      border: OutlineInputBorder(),
                      helperText: 'Selecciona la categoría del producto',
                    ),
                    items:
                        _categorias
                            .map(
                              (categoria) => DropdownMenuItem<int>(
                                value: categoria.id,
                                child: Text(categoria.name),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _categoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecciona una categoría';
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

              // Sección de atributos del producto
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildAtributosSection(),
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

// Diálogo para agregar/editar atributos
class _AtributoDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;

  const _AtributoDialog({this.initialData, required this.onSave});

  @override
  State<_AtributoDialog> createState() => _AtributoDialogState();
}

class _AtributoDialogState extends State<_AtributoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _unityController = TextEditingController();

  String _selectedType = 'text';
  bool _isVisible = true;

  final List<Map<String, String>> _atributoTypes = [
    {'value': 'text', 'label': 'Texto'},
    {'value': 'number', 'label': 'Número'},
    {'value': 'color', 'label': 'Color'},
    {'value': 'size', 'label': 'Talla/Tamaño'},
    {'value': 'material', 'label': 'Material'},
    {'value': 'weight', 'label': 'Peso'},
    {'value': 'boolean', 'label': 'Sí/No'},
  ];

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _valueController.text = widget.initialData!['value'] ?? '';
      _unityController.text = widget.initialData!['unity'] ?? '';
      _selectedType = widget.initialData!['type'] ?? 'text';
      _isVisible = widget.initialData!['is_visible'] ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _unityController.dispose();
    super.dispose();
  }

  void _saveAtributo() {
    if (_formKey.currentState?.validate() ?? false) {
      final atributoData = {
        'name': _nameController.text.trim(),
        'value': _valueController.text.trim(),
        'type': _selectedType,
        'unity':
            _unityController.text.trim().isEmpty
                ? null
                : _unityController.text.trim(),
        'is_visible': _isVisible,
        'order': 0,
        'created_at': DateTime.now().toIso8601String(),
      };

      widget.onSave(atributoData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialData != null ? 'Editar Atributo' : 'Agregar Atributo',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nombre del atributo
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del atributo *',
                  hintText: 'Ej: Color, Talla, Material',
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

              // Valor del atributo
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor del atributo *',
                  hintText: 'Ej: Azul, M, Algodón',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El valor es obligatorio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Tipo de atributo
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de atributo',
                  border: OutlineInputBorder(),
                ),
                items:
                    _atributoTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type['value'],
                            child: Text(type['label']!),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value ?? 'text';
                  });
                },
              ),

              const SizedBox(height: 16),

              // Unidad de medida (opcional)
              TextFormField(
                controller: _unityController,
                decoration: const InputDecoration(
                  labelText: 'Unidad de medida (opcional)',
                  hintText: 'Ej: kg, cm, litros, %',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Switch para visibilidad
              SwitchListTile(
                title: const Text('Visible al público'),
                subtitle: const Text('¿Mostrar este atributo en el producto?'),
                value: _isVisible,
                onChanged: (value) {
                  setState(() {
                    _isVisible = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveAtributo,
          child: Text(widget.initialData != null ? 'Actualizar' : 'Agregar'),
        ),
      ],
    );
  }
}
