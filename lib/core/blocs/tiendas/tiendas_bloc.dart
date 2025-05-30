import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/tienda.dart';
import '../../models/ubicacion.dart';
import '../../models/contacto.dart';
import 'tiendas_event.dart';
import 'tiendas_state.dart';

class TiendasBloc extends Bloc<TiendasEvent, TiendasState> {
  TiendasBloc() : super(TiendasInitial()) {
    on<LoadTiendas>(_onLoadTiendas);
    on<SelectTienda>(_onSelectTienda);
  }

  void _onLoadTiendas(LoadTiendas event, Emitter<TiendasState> emit) async {
    emit(TiendasLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Datos de prueba
      final tiendas = _getMockTiendas();

      emit(TiendasLoaded(tiendas: tiendas));
    } catch (e) {
      emit(TiendasError('Error al cargar las tiendas: $e'));
    }
  }

  void _onSelectTienda(SelectTienda event, Emitter<TiendasState> emit) {
    if (state is TiendasLoaded) {
      final currentState = state as TiendasLoaded;
      emit(currentState.copyWith(selectedTienda: event.tienda));
    }
  }

  List<Tienda> _getMockTiendas() {
    return [
      Tienda(
        id: "puesto_001",
        nombrePropietario: "Juan Pérez",
        ubicacion: const Ubicacion(lat: -16.500123, lng: -68.123456),
        rubroPrincipal: "Ropa usada americana",
        productos: ["prod_001", "prod_002", "prod_003"],
        contacto: const Contacto(
          telefono: "71234567",
          whatsapp: "71234567",
          redesSociales: RedesSociales(
            facebook: "facebook.com/juanropa",
            instagram: "@juanropa",
          ),
        ),
        horario: "Lunes y jueves, 08:00 - 18:00",
        calificacion: 4.5,
      ),
      Tienda(
        id: "puesto_002",
        nombrePropietario: "María González",
        ubicacion: const Ubicacion(lat: -16.501234, lng: -68.124567),
        rubroPrincipal: "Comida rápida",
        productos: ["prod_004", "prod_005", "prod_006"],
        contacto: const Contacto(
          telefono: "72345678",
          whatsapp: "72345678",
          redesSociales: RedesSociales(
            facebook: "facebook.com/mariacomida",
            instagram: "@mariacomida",
          ),
        ),
        horario: "Martes a sábado, 10:00 - 20:00",
        calificacion: 4.2,
      ),
      Tienda(
        id: "puesto_003",
        nombrePropietario: "Carlos Mamani",
        ubicacion: const Ubicacion(lat: -16.502345, lng: -68.125678),
        rubroPrincipal: "Accesorios de celular",
        productos: ["prod_007", "prod_008", "prod_009"],
        contacto: const Contacto(
          telefono: "73456789",
          whatsapp: "73456789",
          redesSociales: RedesSociales(
            facebook: "facebook.com/carlosaccesorios",
            instagram: "@carlosaccesorios",
          ),
        ),
        horario: "Lunes a viernes, 09:00 - 19:00",
        calificacion: 4.8,
      ),
      Tienda(
        id: "puesto_004",
        nombrePropietario: "Ana Torres",
        ubicacion: const Ubicacion(lat: -16.503456, lng: -68.126789),
        rubroPrincipal: "Artesanías",
        productos: ["prod_010", "prod_011", "prod_012"],
        contacto: const Contacto(
          telefono: "74567890",
          whatsapp: "74567890",
          redesSociales: RedesSociales(
            facebook: "facebook.com/anaartesanias",
            instagram: "@anaartesanias",
          ),
        ),
        horario: "Miércoles a domingo, 08:30 - 17:30",
        calificacion: 4.6,
      ),
      Tienda(
        id: "puesto_005",
        nombrePropietario: "Roberto Silva",
        ubicacion: const Ubicacion(lat: -16.504567, lng: -68.127890),
        rubroPrincipal: "Zapatos y calzado",
        productos: ["prod_013", "prod_014", "prod_015"],
        contacto: const Contacto(
          telefono: "75678901",
          whatsapp: "75678901",
          redesSociales: RedesSociales(
            facebook: "facebook.com/robertozapatos",
            instagram: "@robertozapatos",
          ),
        ),
        horario: "Lunes a sábado, 09:30 - 18:30",
        calificacion: 4.3,
      ),
    ];
  }
}
