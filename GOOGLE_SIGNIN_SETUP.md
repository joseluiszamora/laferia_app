# Configuración de Google Sign-In con Supabase

## Resumen de Implementación

Se ha agregado la funcionalidad de **Google Sign-In** al archivo `LoginPage` usando **Supabase OAuth**. El sistema está preparado para funcionar, pero requiere configuración adicional en Google Cloud Console y Supabase.

## Archivos Modificados

### 1. `/lib/core/services/auth_service_new.dart`

- ✅ Agregado método `signInWithGoogle()` que usa Supabase OAuth
- ✅ Manejo de errores y excepciones
- ✅ Redirección usando deep links

### 2. `/lib/core/providers/auth_provider.dart`

- ✅ Agregado método `signInWithGoogle()` para gestión de estado
- ✅ Integración con la UI mediante Consumer pattern

### 3. `/lib/views/auth/login_page.dart`

- ✅ Agregado método `_signInWithGoogle()`
- ✅ Habilitado botón "Continuar con Google"
- ✅ Manejo de estados de carga y errores
- ✅ Mensajes de feedback al usuario

## Configuración Requerida

### 1. Google Cloud Console

1. **Crear proyecto en Google Cloud Console:**

   - Ve a [Google Cloud Console](https://console.cloud.google.com/)
   - Crea un nuevo proyecto o selecciona uno existente

2. **Habilitar Google+ API:**

   - En la consola, ve a "APIs & Services" > "Library"
   - Busca y habilita "Google+ API"

3. **Configurar OAuth 2.0:**

   - Ve a "APIs & Services" > "Credentials"
   - Crea credenciales OAuth 2.0
   - Configura los orígenes autorizados:
     - Para desarrollo: `http://localhost:3000`
     - Para producción: tu dominio

4. **Configurar redirección:**
   - Agregar URI de redirección: `https://your-project.supabase.co/auth/v1/callback`

### 2. Supabase Dashboard

1. **Habilitar Google Provider:**

   - Ve a Authentication > Providers
   - Habilita Google
   - Configura Client ID y Client Secret de Google Cloud Console

2. **Configurar URLs de redirección:**
   - Site URL: `https://your-app-domain.com`
   - Redirect URLs:
     - `io.supabase.laferia://login-callback` (para móvil)
     - `https://your-app-domain.com/auth-callback` (para web)

### 3. Configuración de la App

1. **Android (android/app/src/main/AndroidManifest.xml):**

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/LaunchTheme">

    <!-- Intent filter para deep links -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="io.supabase.laferia" />
    </intent-filter>
</activity>
```

2. **iOS (ios/Runner/Info.plist):**

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>io.supabase.laferia</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>io.supabase.laferia</string>
        </array>
    </dict>
</array>
```

## Flujo de Autenticación

1. **Usuario presiona "Continuar con Google"**
2. **La app abre el navegador** con la URL de Google OAuth
3. **Usuario se autentica** en Google
4. **Google redirecciona** a Supabase
5. **Supabase procesa** la autenticación
6. **Supabase redirecciona** de vuelta a la app
7. **AuthProvider detecta** el cambio de sesión automáticamente
8. **AuthWrapper navega** a la pantalla principal

## Pruebas y Debugging

### Para probar la funcionalidad:

1. **Verificar configuración:**

   ```bash
   flutter run
   ```

2. **Revisar logs de Supabase:**

   - Ve al dashboard de Supabase
   - Authentication > Logs
   - Busca errores de configuración

3. **Probar en dispositivo real:**
   - Los deep links no funcionan en simuladores/emuladores
   - Usa dispositivos físicos para pruebas completas

### Errores comunes:

- **"redirect_uri_mismatch"**: URIs de redirección mal configuradas
- **"invalid_client"**: Client ID/Secret incorrectos
- **"unauthorized_client"**: Dominio no autorizado en Google Console

## Estado Actual

✅ **Completado:**

- Implementación del método de Google Sign-In
- Integración con la UI del LoginPage
- Manejo de estados y errores
- Preparación para deep links

⚠️ **Pendiente (Configuración externa):**

- Configuración en Google Cloud Console
- Configuración en Supabase Dashboard
- Configuración de deep links en Android/iOS
- Pruebas en dispositivos reales

## Próximos Pasos

1. Completar la configuración externa mencionada arriba
2. Probar el flujo completo en dispositivos reales
3. Ajustar las URLs de redirección según tu dominio/esquema
4. Implementar manejo de deep links si es necesario
5. Considerar agregar Google Sign-In también a RegisterPage

La funcionalidad está **lista para usar** una vez completada la configuración externa.
