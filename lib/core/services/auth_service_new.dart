import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Obtener usuario actual
  static User? get currentUser => _supabase.auth.currentUser;

  // Stream de cambios de autenticación
  static Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  // Verificar si el usuario está autenticado
  static bool get isAuthenticated => currentUser != null;

  // Obtener información del perfil del usuario
  static Map<String, dynamic>? get userProfile {
    final user = currentUser;
    if (user == null) return null;

    return {
      'id': user.id,
      'email': user.email,
      'name':
          user.userMetadata?['display_name'] ??
          user.userMetadata?['full_name'] ??
          'Usuario',
      'avatar_url': user.userMetadata?['avatar_url'],
      'provider': user.appMetadata['provider'] ?? 'email',
      'created_at': user.createdAt,
    };
  }

  /// REGISTRO CON EMAIL Y CONTRASEÑA
  static Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Validaciones básicas
      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        return AuthResult.error('Todos los campos son obligatorios');
      }

      if (!_isValidEmail(email)) {
        return AuthResult.error('Email no válido');
      }

      if (password.length < 6) {
        return AuthResult.error(
          'La contraseña debe tener al menos 6 caracteres',
        );
      }

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': fullName, 'full_name': fullName},
      );

      if (response.user != null) {
        return AuthResult.success(
          'Cuenta creada exitosamente. Revisa tu email para confirmar tu cuenta.',
        );
      } else {
        return AuthResult.error('Error desconocido al crear la cuenta');
      }
    } on AuthException catch (e) {
      return AuthResult.error(_handleAuthException(e));
    } catch (e) {
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// LOGIN CON EMAIL Y CONTRASEÑA
  static Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return AuthResult.error('Email y contraseña son obligatorios');
      }

      if (!_isValidEmail(email)) {
        return AuthResult.error('Email no válido');
      }

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return AuthResult.success('Bienvenido de vuelta!');
      } else {
        return AuthResult.error('Credenciales incorrectas');
      }
    } on AuthException catch (e) {
      return AuthResult.error(_handleAuthException(e));
    } catch (e) {
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// LOGIN CON GOOGLE (Temporalmente deshabilitado - se implementará después)
  static Future<AuthResult> signInWithGoogle() async {
    return AuthResult.error(
      'Autenticación con Google temporalmente no disponible',
    );
  }

  /// CERRAR SESIÓN
  static Future<AuthResult> signOut() async {
    try {
      // Cerrar sesión en Supabase
      await _supabase.auth.signOut();

      return AuthResult.success('Sesión cerrada exitosamente');
    } catch (e) {
      return AuthResult.error('Error al cerrar sesión: ${e.toString()}');
    }
  }

  /// RESTABLECER CONTRASEÑA
  static Future<AuthResult> resetPassword({required String email}) async {
    try {
      if (email.isEmpty) {
        return AuthResult.error('Email es obligatorio');
      }

      if (!_isValidEmail(email)) {
        return AuthResult.error('Email no válido');
      }

      await _supabase.auth.resetPasswordForEmail(email);

      return AuthResult.success(
        'Se ha enviado un enlace de restablecimiento a tu email',
      );
    } on AuthException catch (e) {
      return AuthResult.error(_handleAuthException(e));
    } catch (e) {
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// ACTUALIZAR PERFIL DE USUARIO
  static Future<AuthResult> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (displayName != null && displayName.isNotEmpty) {
        updates['display_name'] = displayName;
        updates['full_name'] = displayName;
      }

      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        updates['avatar_url'] = avatarUrl;
      }

      if (updates.isEmpty) {
        return AuthResult.error('No hay cambios para actualizar');
      }

      final response = await _supabase.auth.updateUser(
        UserAttributes(data: updates),
      );

      if (response.user != null) {
        return AuthResult.success('Perfil actualizado exitosamente');
      } else {
        return AuthResult.error('Error al actualizar el perfil');
      }
    } catch (e) {
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  /// CAMBIAR CONTRASEÑA
  static Future<AuthResult> updatePassword({
    required String newPassword,
  }) async {
    try {
      if (newPassword.length < 6) {
        return AuthResult.error(
          'La nueva contraseña debe tener al menos 6 caracteres',
        );
      }

      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      return AuthResult.success('Contraseña actualizada exitosamente');
    } on AuthException catch (e) {
      return AuthResult.error(_handleAuthException(e));
    } catch (e) {
      return AuthResult.error('Error inesperado: ${e.toString()}');
    }
  }

  // MÉTODOS PRIVADOS AUXILIARES

  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static String _handleAuthException(AuthException e) {
    switch (e.message.toLowerCase()) {
      case 'invalid login credentials':
        return 'Credenciales incorrectas';
      case 'email not confirmed':
        return 'Debes confirmar tu email antes de iniciar sesión';
      case 'user already registered':
        return 'Este email ya está registrado';
      case 'email address not authorized':
        return 'Email no autorizado';
      case 'signup is disabled':
        return 'El registro está temporalmente deshabilitado';
      case 'invalid email':
        return 'Email no válido';
      case 'password is too short':
        return 'La contraseña es demasiado corta';
      case 'password is too weak':
        return 'La contraseña es demasiado débil';
      default:
        return e.message;
    }
  }
}

/// CLASE PARA RESULTADOS DE AUTENTICACIÓN
class AuthResult {
  final bool isSuccess;
  final String message;
  final dynamic data;

  AuthResult._({required this.isSuccess, required this.message, this.data});

  factory AuthResult.success(String message, {dynamic data}) {
    return AuthResult._(isSuccess: true, message: message, data: data);
  }

  factory AuthResult.error(String message) {
    return AuthResult._(isSuccess: false, message: message);
  }
}
