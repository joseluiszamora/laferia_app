import 'package:flutter/material.dart';
import '../../../core/models/producto.dart';

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
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _skuController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.producto != null;

    if (_isEditing) {
      _loadProductoData();
    }
  }

  void _loadProductoData() {
    final producto = widget.producto!;
    _nameController.text = producto.name;
    _descriptionController.text = producto.description;
    _priceController.text = producto.price.toString();
    _stockController.text = producto.stock.toString();
    _skuController.text = producto.sku ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  void _saveProducto() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implementar guardado usando el bloc
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Producto actualizado' : 'Producto creado',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Producto' : 'Nuevo Producto'),
        actions: [
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
                labelText: 'Nombre del producto',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
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
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción es obligatoria';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Precio
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El precio es obligatorio';
                }
                if (double.tryParse(value) == null) {
                  return 'Ingresa un precio válido';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Stock
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El stock es obligatorio';
                }
                if (int.tryParse(value) == null) {
                  return 'Ingresa un stock válido';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // SKU
            TextFormField(
              controller: _skuController,
              decoration: const InputDecoration(
                labelText: 'SKU (opcional)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // Botón de guardar
            ElevatedButton(
              onPressed: _saveProducto,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isEditing ? 'Actualizar Producto' : 'Crear Producto',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
