import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service_new.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  final SupabaseClient _supabase = Supabase.instance.client;

  AuthProvider() {
    _initializeAuth();
  }

  /// Inicializar el sistema de autenticación
  Future<void> _initializeAuth() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Obtener la sesión actual si existe
      final session = _supabase.auth.currentSession;
      _user = session?.user;

      // Escuchar cambios en el estado de autenticación
      _supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        switch (event) {
          case AuthChangeEvent.signedIn:
            _user = session?.user;
            break;
          case AuthChangeEvent.signedOut:
            _user = null;
            break;
          case AuthChangeEvent.tokenRefreshed:
            _user = session?.user;
            break;
          case AuthChangeEvent.userUpdated:
            _user = session?.user;
            break;
          case AuthChangeEvent.passwordRecovery:
            // Manejar recuperación de contraseña si es necesario
            break;
          case AuthChangeEvent.userDeleted:
            _user = null;
            break;
          default:
            break;
        }

        _isLoading = false;
        notifyListeners();
      });

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error inicializando autenticación: $e');
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Iniciar sesión con email y contraseña
  Future<AuthResult> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AuthService.signInWithEmail(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// Registrar nuevo usuario
  Future<AuthResult> signUp(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AuthService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// Cerrar sesión
  Future<AuthResult> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AuthService.signOut();

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// Recuperar contraseña
  Future<AuthResult> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await AuthService.resetPassword(email: email);

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// Refrescar la sesión actual
  Future<void> refreshSession() async {
    try {
      await _supabase.auth.refreshSession();
    } catch (e) {
      debugPrint('Error refrescando sesión: $e');
    }
  }

  /// Obtener información del usuario actual
  Map<String, dynamic>? get userMetadata => _user?.userMetadata;
  String? get userEmail => _user?.email;
  String? get userId => _user?.id;
  String? get userFullName => _user?.userMetadata?['full_name'];
}
