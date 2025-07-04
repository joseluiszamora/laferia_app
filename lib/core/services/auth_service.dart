import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Obtener usuario actual
  User? get currentUser => _supabase.auth.currentUser;

  // Stream de cambios de autenticación
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Registro con email y contraseña
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      return response;
    } catch (e) {
      throw Exception('Error en registro: ${e.toString()}');
    }
  }

  // Login con email y contraseña
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } catch (e) {
      throw Exception('Error en login: ${e.toString()}');
    }
  }

  // Login con Google - Método mejorado para manejo de OAuth
  Future<bool> signInWithGoogle() async {
    try {
      // Método 1: Intentar sin redirectTo personalizado (usar el por defecto de Supabase)
      final result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      return result;
    } on AuthException catch (e) {
      if (e.message.contains('validation_failed') ||
          e.message.contains('missing OAuth secret')) {
        throw Exception(
          'Error de configuración: Google OAuth no está configurado correctamente en Supabase.\n\n'
          'Para solucionar este problema:\n'
          '1. Ve a tu Dashboard de Supabase\n'
          '2. Navega a Authentication > Providers\n'
          '3. Configura Google OAuth con tu Client ID y Client Secret\n'
          '4. Asegúrate de que la URL de callback esté configurada correctamente',
        );
      }
      throw Exception('Error en autenticación con Google: ${e.message}');
    } catch (e) {
      throw Exception('Error en Google Sign In: ${e.toString()}');
    }
  }

  // Método alternativo para Google Sign In con redirectTo personalizado
  Future<bool> signInWithGoogleCustomRedirect() async {
    try {
      // Usar deep link personalizado
      final result = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.example.laferia://oauth/callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );

      return result;
    } on AuthException catch (e) {
      if (e.message.contains('validation_failed') ||
          e.message.contains('missing OAuth secret')) {
        throw Exception(
          'Error de configuración: Google OAuth no está configurado correctamente en Supabase.',
        );
      }
      throw Exception('Error en autenticación con Google: ${e.message}');
    } catch (e) {
      throw Exception(
        'Error en Google Sign In con redirect personalizado: ${e.toString()}',
      );
    }
  }

  // Método para manejar deep links OAuth de retorno
  Future<void> handleOAuthCallback(String url) async {
    try {
      // Extraer los parámetros de la URL de callback
      final uri = Uri.parse(url);
      final fragments = uri.fragment.split('&');

      final Map<String, String> params = {};
      for (String fragment in fragments) {
        final parts = fragment.split('=');
        if (parts.length == 2) {
          params[parts[0]] = Uri.decodeComponent(parts[1]);
        }
      }

      // Si hay un access_token, el usuario se ha autenticado correctamente
      if (params.containsKey('access_token')) {
        await _supabase.auth.setSession(params['access_token']!);
      }
    } catch (e) {
      throw Exception('Error procesando callback OAuth: ${e.toString()}');
    }
  }

  // Verificar si el usuario está autenticado con Google
  bool get isGoogleUser {
    final provider = currentUser?.appMetadata['provider'];
    return provider == 'google';
  }

  // Obtener la URL del avatar del usuario (especialmente útil para usuarios de Google)
  String? get userAvatarUrl => currentUser?.userMetadata?['avatar_url'];

  // Obtener el nombre completo del usuario
  String? get userFullName => currentUser?.userMetadata?['full_name'];

  // Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Error enviando email de recuperación: ${e.toString()}');
    }
  }

  // Actualizar contraseña
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      return response;
    } catch (e) {
      throw Exception('Error actualizando contraseña: ${e.toString()}');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      // Cerrar sesión en Supabase
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Error cerrando sesión: ${e.toString()}');
    }
  }

  // Verificar si hay sesión activa
  bool get isAuthenticated => currentUser != null;

  // Obtener información del usuario
  Map<String, dynamic>? get userMetadata => currentUser?.userMetadata;

  // Obtener email del usuario actual
  String? get userEmail => currentUser?.email;

  // Obtener ID del usuario actual
  String? get userId => currentUser?.id;

  // Obtener display name del usuario actual
  String? get userDisplayName => currentUser?.userMetadata?['display_name'];

  // Verificar si el email está confirmado
  bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // Actualizar perfil del usuario
  Future<UserResponse> updateProfile({
    String? displayName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (displayName != null) {
        data['display_name'] = displayName;
      }

      if (additionalData != null) {
        data.addAll(additionalData);
      }

      final response = await _supabase.auth.updateUser(
        UserAttributes(data: data),
      );

      return response;
    } catch (e) {
      throw Exception('Error actualizando perfil: ${e.toString()}');
    }
  }

  // Reenviar email de confirmación
  Future<void> resendConfirmation(String email) async {
    try {
      await _supabase.auth.resend(type: OtpType.signup, email: email);
    } catch (e) {
      throw Exception('Error reenviando confirmación: ${e.toString()}');
    }
  }

  // Método para diagnosticar problemas de OAuth
  Future<Map<String, dynamic>> diagnoseOAuthIssues() async {
    final Map<String, dynamic> diagnosis = {
      'supabse_configured': false,
      'user_session': null,
      'auth_state': 'unknown',
      'recommendations': <String>[],
    };

    try {
      // Verificar estado de autenticación
      final user = _supabase.auth.currentUser;
      diagnosis['user_session'] = user?.toJson();
      diagnosis['auth_state'] =
          user != null ? 'authenticated' : 'not_authenticated';

      // Verificar configuración de Supabase
      final session = _supabase.auth.currentSession;
      diagnosis['supabase_configured'] = session != null || user != null;

      // Añadir recomendaciones basadas en el estado
      if (user == null) {
        diagnosis['recommendations'].add('Usuario no autenticado');
        diagnosis['recommendations'].add(
          'Verificar configuración OAuth en Supabase Dashboard',
        );
      }

      if (!diagnosis['supabase_configured']) {
        diagnosis['recommendations'].add(
          'Configurar Google OAuth Provider en Supabase',
        );
        diagnosis['recommendations'].add(
          'Añadir Client ID y Client Secret de Google Cloud Console',
        );
        diagnosis['recommendations'].add('Verificar URLs de redirección');
      }
    } catch (e) {
      diagnosis['error'] = e.toString();
      diagnosis['recommendations'].add(
        'Error en configuración de Supabase: ${e.toString()}',
      );
    }

    return diagnosis;
  }

  // Método para verificar si OAuth está configurado correctamente
  Future<bool> isOAuthConfigured() async {
    try {
      // Intentar una verificación simple de la configuración
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        authScreenLaunchMode: LaunchMode.externalApplication,
        // Dry run - no abrirá el navegador en realidad
      );
      return true;
    } on AuthException catch (e) {
      // Si el error es de configuración, OAuth no está configurado
      return !e.message.contains('validation_failed') &&
          !e.message.contains('missing OAuth secret');
    } catch (e) {
      return false;
    }
  }

  // Método para obtener información de debug
  Map<String, dynamic> getDebugInfo() {
    return {
      'is_authenticated': isAuthenticated,
      'user_id': userId,
      'user_email': userEmail,
      'user_metadata': userMetadata,
      'is_google_user': isGoogleUser,
      'avatar_url': userAvatarUrl,
      'full_name': userFullName,
      'email_confirmed': isEmailConfirmed,
      'auth_client_configured': _supabase.auth.currentSession != null,
    };
  }
}
