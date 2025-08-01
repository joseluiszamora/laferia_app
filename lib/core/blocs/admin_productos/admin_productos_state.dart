import 'package:equatable/equatable.dart';
import '../../models/producto.dart';

abstract class AdminProductosState extends Equatable {
  const AdminProductosState();

  @override
  List<Object?> get props => [];
}

class AdminProductosInitial extends AdminProductosState {}

class AdminProductosLoading extends AdminProductosState {}

class AdminProductosLoaded extends AdminProductosState {
  final List<Producto> productos;
  final bool hasReachedMax;
  final int totalCount;
  final String? searchQuery;
  final int? selectedCategoryId;
  final ProductStatus? selectedStatus;

  const AdminProductosLoaded({
    this.productos = const [],
    this.hasReachedMax = false,
    this.totalCount = 0,
    this.searchQuery,
    this.selectedCategoryId,
    this.selectedStatus,
  });

  AdminProductosLoaded copyWith({
    List<Producto>? productos,
    bool? hasReachedMax,
    int? totalCount,
    String? searchQuery,
    int? selectedCategoryId,
    ProductStatus? selectedStatus,
  }) {
    return AdminProductosLoaded(
      productos: productos ?? this.productos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalCount: totalCount ?? this.totalCount,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [
    productos,
    hasReachedMax,
    totalCount,
    searchQuery,
    selectedCategoryId,
    selectedStatus,
  ];
}

class AdminProductoForEditLoaded extends AdminProductosState {
  final Producto producto;

  const AdminProductoForEditLoaded({required this.producto});

  @override
  List<Object?> get props => [producto];
}

class AdminProductosError extends AdminProductosState {
  final String message;

  const AdminProductosError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminProductoOperationSuccess extends AdminProductosState {
  final String message;
  final String operation; // 'create', 'update', 'delete'

  const AdminProductoOperationSuccess({
    required this.message,
    required this.operation,
  });

  @override
  List<Object?> get props => [message, operation];
}

class AdminProductoOperationLoading extends AdminProductosState {
  final String operation; // 'create', 'update', 'delete'

  const AdminProductoOperationLoading({required this.operation});

  @override
  List<Object?> get props => [operation];
}
