import 'package:get_it/get_it.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/comentarios/comentarios_bloc.dart';
import 'package:laferia/core/blocs/ofertas/ofertas_bloc.dart';
import 'package:laferia/core/blocs/productos/productos_bloc.dart';
import 'package:laferia/core/blocs/rubros/rubros_bloc.dart';
import 'package:laferia/core/blocs/tiendas/tiendas_bloc.dart';

GetIt getIt = GetIt.instance;

void serviceLocatorInit() {
  getIt.registerLazySingleton<CategoriasBloc>(() => CategoriasBloc());
  getIt.registerLazySingleton<ComentariosBloc>(() => ComentariosBloc());
  getIt.registerLazySingleton<OfertasBloc>(() => OfertasBloc());
  getIt.registerLazySingleton<ProductosBloc>(() => ProductosBloc());
  getIt.registerLazySingleton<RubrosBloc>(() => RubrosBloc());
  getIt.registerLazySingleton<TiendasBloc>(() => TiendasBloc());
}
