import 'package:flutter/material.dart';
import '../../../../core/models/producto.dart';

class ProductosFilterBar extends StatefulWidget {
  final Function(int?, ProductStatus?) onFilterChanged;

  const ProductosFilterBar({super.key, required this.onFilterChanged});

  @override
  State<ProductosFilterBar> createState() => _ProductosFilterBarState();
}

class _ProductosFilterBarState extends State<ProductosFilterBar> {
  int? _selectedCategoryId;
  ProductStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Filtro por categoría
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45 - 24,
              child: DropdownButtonFormField<int?>(
                value: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Todas', overflow: TextOverflow.ellipsis),
                  ),
                  // TODO: Cargar categorías reales desde el servicio
                  DropdownMenuItem<int?>(
                    value: 1,
                    child: Text('Alimentaria', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem<int?>(
                    value: 2,
                    child: Text('Textil', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem<int?>(
                    value: 3,
                    child: Text('Tecnología', overflow: TextOverflow.ellipsis),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                  widget.onFilterChanged(_selectedCategoryId, _selectedStatus);
                },
              ),
            ),

            const SizedBox(width: 16),

            // Filtro por estado
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45 - 8,
              child: DropdownButtonFormField<ProductStatus?>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem<ProductStatus?>(
                    value: null,
                    child: Text('Todos', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem<ProductStatus?>(
                    value: ProductStatus.draft,
                    child: Text('Borrador', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem<ProductStatus?>(
                    value: ProductStatus.published,
                    child: Text('Publicado', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem<ProductStatus?>(
                    value: ProductStatus.archived,
                    child: Text('Archivado', overflow: TextOverflow.ellipsis),
                  ),
                  DropdownMenuItem<ProductStatus?>(
                    value: ProductStatus.exhausted,
                    child: Text('Agotado', overflow: TextOverflow.ellipsis),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                  widget.onFilterChanged(_selectedCategoryId, _selectedStatus);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
