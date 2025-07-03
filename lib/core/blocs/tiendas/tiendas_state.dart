import 'package:equatable/equatable.dart';
import '../../models/tienda.dart';

abstract class TiendasState extends Equatable {
  const TiendasState();

  @override
  List<Object?> get props => [];
}

class TiendasInitial extends TiendasState {}

class TiendasLoading extends TiendasState {}

class TiendasLoaded extends TiendasState {
  final List<Tienda> tiendas;
  final List<Tienda> todasLasTiendas; // Lista completa sin filtros
  final Tienda? selectedTienda;
  final Tienda? tiendaParaEditar;
  final String? terminoBusqueda;
  final int? categoriaFiltro;

  const TiendasLoaded({
    required this.tiendas,
    required this.todasLasTiendas,
    this.selectedTienda,
    this.tiendaParaEditar,
    this.terminoBusqueda,
    this.categoriaFiltro,
  });

  TiendasLoaded copyWith({
    List<Tienda>? tiendas,
    List<Tienda>? todasLasTiendas,
    Tienda? selectedTienda,
    Tienda? tiendaParaEditar,
    String? terminoBusqueda,
    int? categoriaFiltro,
    bool clearTiendaParaEditar = false,
    bool clearTerminoBusqueda = false,
    bool clearCategoriaFiltro = false,
  }) {
    return TiendasLoaded(
      tiendas: tiendas ?? this.tiendas,
      todasLasTiendas: todasLasTiendas ?? this.todasLasTiendas,
      selectedTienda: selectedTienda ?? this.selectedTienda,
      tiendaParaEditar:
          clearTiendaParaEditar
              ? null
              : (tiendaParaEditar ?? this.tiendaParaEditar),
      terminoBusqueda:
          clearTerminoBusqueda
              ? null
              : (terminoBusqueda ?? this.terminoBusqueda),
      categoriaFiltro:
          clearCategoriaFiltro
              ? null
              : (categoriaFiltro ?? this.categoriaFiltro),
    );
  }

  // Getter para obtener tiendas filtradas
  List<Tienda> get tiendasFiltradas {
    List<Tienda> resultado = List.from(todasLasTiendas);

    // Aplicar filtro de búsqueda por texto
    if (terminoBusqueda != null && terminoBusqueda!.isNotEmpty) {
      resultado =
          resultado.where((tienda) {
            final searchLower = terminoBusqueda!.toLowerCase();
            return tienda.nombre.toLowerCase().contains(searchLower) ||
                tienda.nombrePropietario.toLowerCase().contains(searchLower) ||
                (tienda.direccion?.toLowerCase().contains(searchLower) ??
                    false);
          }).toList();
    }

    // Aplicar filtro por categoría
    if (categoriaFiltro != null) {
      resultado =
          resultado
              .where((tienda) => tienda.categoryId == categoriaFiltro)
              .toList();
    }

    return resultado;
  }

  @override
  List<Object?> get props => [
    tiendas,
    todasLasTiendas,
    selectedTienda,
    tiendaParaEditar,
    terminoBusqueda,
    categoriaFiltro,
  ];
}

class TiendasError extends TiendasState {
  final String message;

  const TiendasError(this.message);

  @override
  List<Object> get props => [message];
}

// Estados específicos para operaciones CRUD
class TiendaCreandose extends TiendasState {}

class TiendaCreada extends TiendasState {
  final Tienda tienda;

  const TiendaCreada(this.tienda);

  @override
  List<Object> get props => [tienda];
}

class TiendaActualizandose extends TiendasState {}

class TiendaActualizada extends TiendasState {
  final Tienda tienda;

  const TiendaActualizada(this.tienda);

  @override
  List<Object> get props => [tienda];
}

class TiendaEliminandose extends TiendasState {}

class TiendaEliminada extends TiendasState {
  final int tiendaId;

  const TiendaEliminada(this.tiendaId);

  @override
  List<Object> get props => [tiendaId];
}

class TiendaOperacionError extends TiendasState {
  final String message;

  const TiendaOperacionError(this.message);

  @override
  List<Object> get props => [message];
}
