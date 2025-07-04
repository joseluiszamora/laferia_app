# Soluciones para Problemas de OAuth con Google en Flutter + Supabase

## Problema Principal

La aplicación Flutter con Supabase redirige a `localhost:3000` en lugar de manejar correctamente el OAuth flow para mobile.

## Soluciones Implementadas

### 1. Método Estándar (Recomendado)

**Archivo**: `AuthService.signInWithGoogle()`

```dart
await _supabase.auth.signInWithOAuth(
  OAuthProvider.google,
  authScreenLaunchMode: LaunchMode.externalApplication,
);
```

**Ventajas**:

- Usa la configuración por defecto de Supabase
- Más simple y mantenible
- Mejor compatibilidad

**Requisitos**:

- Configurar correctamente Site URL en Supabase Dashboard
- Google OAuth debe estar configurado en Supabase

### 2. Método con Deep Links Personalizados

**Archivo**: `AuthService.signInWithGoogleCustomRedirect()`

```dart
await _supabase.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: 'com.example.laferia://oauth/callback',
  authScreenLaunchMode: LaunchMode.externalApplication,
);
```

**Ventajas**:

- Control completo sobre la redirección
- Funciona sin configurar Site URL
- Ideal para apps móviles

**Requisitos**:

- Configurar deep links en AndroidManifest.xml
- Manejar los callbacks manualmente

### 3. Configuración en Supabase Dashboard

#### Paso 1: Site URL

```
Settings > General > Configuration
Site URL: http://localhost:3000 (desarrollo)
```

#### Paso 2: Redirect URLs

```
Authentication > URL Configuration
Additional redirect URLs:
- com.example.laferia://oauth/callback
- http://localhost:3000
```

#### Paso 3: Google Provider

```
Authentication > Providers > Google
- Enable: ON
- Client ID: [Tu Google Client ID]
- Client Secret: [Tu Google Client Secret]
```

### 4. Configuración de Google Cloud Console

#### OAuth 2.0 Client ID (Web)

```
Application type: Web application
Authorized JavaScript origins:
- https://sfporjwgzplyckosbdqx.supabase.co

Authorized redirect URIs:
- https://sfporjwgzplyckosbdqx.supabase.co/auth/v1/callback
```

#### OAuth 2.0 Client ID (Android) - Opcional

```
Application type: Android
Package name: com.example.laferia_app
SHA-1 certificate fingerprint: [Tu SHA-1]
```

## Diagnosis y Debug

### Página de Debug OAuth

La aplicación incluye una página de debug (`OAuthDebugPage`) accesible desde el botón "Debug OAuth" en la página de login.

**Funciones**:

- Verificar estado de autenticación
- Mostrar información de debug
- Probar diferentes métodos OAuth
- Mostrar recomendaciones

### Información de Debug

```dart
AuthService().getDebugInfo()
```

Devuelve:

- Estado de autenticación
- Información del usuario
- Metadatos de sesión
- Estado de configuración

### Diagnosis Automática

```dart
AuthService().diagnoseOAuthIssues()
```

Identifica:

- Problemas de configuración
- Estado de la sesión
- Recomendaciones específicas

## Errores Comunes y Soluciones

### Error: "missing OAuth secret"

**Causa**: Google OAuth no configurado en Supabase
**Solución**:

1. Ve a Supabase Dashboard
2. Authentication > Providers > Google
3. Añade Client ID y Client Secret

### Error: Redirección a localhost:3000

**Causa**: Site URL mal configurado
**Solución**:

1. Ve a Settings > General
2. Configura Site URL correctamente
3. Añade redirect URLs adicionales

### Error: "URI_VALIDATION" en Google

**Causa**: URLs de redirección no autorizadas
**Solución**:

1. Ve a Google Cloud Console
2. Credentials > OAuth 2.0 Client IDs
3. Añade la URL de callback de Supabase

### Error: Deep links no funcionan

**Causa**: AndroidManifest.xml mal configurado
**Solución**:

1. Verificar intent-filter en AndroidManifest.xml
2. Añadir esquema personalizado
3. Configurar data con scheme y host

## Archivos de Configuración

### AndroidManifest.xml

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="com.example.laferia"
          android:host="oauth" />
</intent-filter>
```

### pubspec.yaml

```yaml
dependencies:
  supabase_flutter: ^2.5.6
  # No necesita google_sign_in adicional
```

## Flujo de Autenticación Recomendado

1. **Usuario hace clic en "Continuar con Google"**
2. **App llama a `signInWithGoogle()`**
3. **Supabase abre Google OAuth en navegador externo**
4. **Usuario se autentica en Google**
5. **Google redirige a URL de callback de Supabase**
6. **Supabase procesa la autenticación**
7. **App recibe confirmación de autenticación**
8. **Usuario es redirigido a la app**

## Testing y Verificación

### 1. Usar Debug Page

- Acceder desde botón "Debug OAuth"
- Revisar estado de configuración
- Probar diferentes métodos

### 2. Verificar Logs

```bash
flutter run --verbose
```

### 3. Verificar en Supabase Dashboard

- Authentication > Users (ver usuarios creados)
- Authentication > Logs (ver intentos de autenticación)

## Métodos de Fallback

### 1. Login con Email

- Siempre disponible
- No requiere configuración OAuth
- Implementado en `signInWithEmail()`

### 2. Modo Demo

- Botón "Probar App (Sin Login)"
- Para testing sin autenticación
- Ideal para desarrollo

### 3. Método Alternativo OAuth

- Usar `signInWithGoogleCustomRedirect()`
- Con deep links personalizados
- Último recurso si método estándar falla

## Estado Actual de la Implementación

✅ **Implementado**:

- Método OAuth estándar
- Método OAuth con deep links
- Página de debug
- Manejo de errores
- Diagnosis automática
- Configuración AndroidManifest.xml

❌ **Pendiente**:

- Configuración real en Google Cloud Console
- Configuración real en Supabase Dashboard
- Testing con configuración real
- Navegación a home después del login
- iOS configuration (Info.plist)

## Próximos Pasos

1. **Configurar Google Cloud Console**

   - Crear proyecto OAuth
   - Configurar URLs de redirección

2. **Configurar Supabase Dashboard**

   - Habilitar Google provider
   - Añadir credenciales

3. **Testing Real**

   - Probar con configuración real
   - Verificar flujo completo

4. **Optimización**
   - Mejorar manejo de errores
   - Añadir más métodos de fallback
   - Implementar auto-retry
