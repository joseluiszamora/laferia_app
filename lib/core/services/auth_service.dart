import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // Login con Google - Temporalmente deshabilitado hasta resolver compatibilidad
  Future<AuthResponse> signInWithGoogle() async {
    throw Exception(
      'Google Sign In temporalmente deshabilitado - requiere configuración adicional',
    );

    /* 
    // TODO: Implementar cuando se resuelva compatibilidad con google_sign_in
    try {
      // Generar nonce para seguridad
      final rawNonce = _generateNonce();
      
      // Iniciar Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Login con Google cancelado');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Error obteniendo tokens de Google');
      }

      // Autenticar con Supabase usando OAuth
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
        nonce: rawNonce,
      );

      return response;
    } catch (e) {
      throw Exception('Error en Google Sign In: ${e.toString()}');
    }
    */
  }

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
      // TODO: Cerrar sesión en Google cuando esté implementado
      /*
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        await _googleSignIn.signOut();
      }
      */

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
}
