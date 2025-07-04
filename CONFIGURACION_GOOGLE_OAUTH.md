# Configuración de Google OAuth para La Feria App

## Problema Actual

La aplicación muestra el error: `"code":400,"error_code":"validation_failed","msg":"Unsupported provider: missing OAuth secret"}` al intentar hacer login con Google.

**Problema adicional identificado**: El OAuth redirige a `localhost:3000` en lugar de usar el deep link configurado (`com.example.laferia://oauth/callback`).

## Solución: Configurar Google OAuth en Supabase

### Paso 1: Crear credenciales OAuth en Google Cloud Console

1. **Accede a Google Cloud Console**:

   - URL: `https://console.cloud.google.com/`

2. **Crear o seleccionar proyecto**:

   - Si no tienes un proyecto, crea uno nuevo
   - Selecciona el proyecto para La Feria App

3. **Habilitar Google+ API**:

   - Ve a "APIs & Services" > "Library"
   - Busca "Google+ API" y habilítala

4. **Crear credenciales OAuth 2.0**:

   - Ve a "APIs & Services" > "Credentials"
   - Haz clic en "Create Credentials" > "OAuth 2.0 Client ID"
   - Selecciona "Configure consent screen" si es la primera vez
   - Completa la información básica requerida

5. **Configurar OAuth 2.0 Client ID**:

   - **Application type**: Web application
   - **Name**: La Feria App - Supabase OAuth
   - **Authorized JavaScript origins**:
     ```
     https://sfporjwgzplyckosbdqx.supabase.co
     ```
   - **Authorized redirect URIs**:
     ```
     https://sfporjwgzplyckosbdqx.supabase.co/auth/v1/callback
     ```

6. **Copiar credenciales**:
   - Guarda el **Client ID** y **Client Secret** que se generan

### Paso 2: Configurar Google OAuth en Supabase

1. **Accede a Supabase Dashboard**:

   - URL: `https://app.supabase.com/`
   - Selecciona tu proyecto: `sfporjwgzplyckosbdqx`

2. **Configurar Provider de Google**:

   - Ve a **Authentication** > **Providers**
   - Busca **Google** en la lista de providers
   - Haz clic en **Google**

3. **Habilitar y configurar**:

   - Cambia el toggle para **habilitar** Google provider
   - **Client ID**: Pega el Client ID de Google Cloud Console
   - **Client Secret**: Pega el Client Secret de Google Cloud Console
   - **Redirect URL**: Debe estar preconfigurada como:
     ```
     https://sfporjwgzplyckosbdqx.supabase.co/auth/v1/callback
     ```

4. **Guardar configuración**:
   - Haz clic en **Save** para aplicar los cambios

### Paso 3: Configurar Site URL en Supabase (IMPORTANTE)

1. **Configurar Site URL**:

   - En el Dashboard de Supabase, ve a **Settings** > **General**
   - En la sección **Configuration**, busca **Site URL**
   - Cambia la URL de:
     ```
     http://localhost:3000
     ```
   - A tu dominio de producción o mantén localhost para desarrollo:
     ```
     http://localhost:3000
     ```
   - Para la app móvil, también añade en **Additional redirect URLs**:
     ```
     com.example.laferia://oauth/callback
     ```

2. **Configurar Redirect URLs adicionales**:
   - En **Authentication** > **URL Configuration**
   - Añade las siguientes URLs en **Additional redirect URLs**:
     ```
     com.example.laferia://oauth/callback
     http://localhost:3000
     https://tu-dominio.com (si tienes uno)
     ```

### Paso 4: Verificar configuración

1. **Probar el login con Google**:

   - Ejecuta la app Flutter
   - Intenta hacer login con Google
   - Debería redirigir correctamente a Google OAuth

2. **Verificar en Supabase**:

   - Ve a **Authentication** > **Users**
   - Después de un login exitoso, deberías ver el usuario creado

3. **Solución de problemas**:
   - Si sigue redirigiendo a localhost:3000, verifica la configuración de Site URL
   - Si aparece error de configuración, verifica que Client ID y Secret estén correctos

### Configuración adicional para Flutter (Android)

Si planeas compilar para Android, también necesitarás:

1. **Crear credenciales para Android**:

   - En Google Cloud Console, crea otro OAuth 2.0 Client ID
   - **Application type**: Android
   - **Package name**: com.example.laferia_app (o el que uses)
   - **SHA-1 certificate fingerprint**: Obténlo con:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```

2. **Descargar google-services.json**:
   - Desde Google Cloud Console
   - Colocar en `android/app/google-services.json`

### Notas importantes

- **Entorno de desarrollo**: Las configuraciones actuales son para desarrollo/testing
- **Producción**: Para producción, necesitarás configurar dominios y certificados adicionales
- **URLs de callback**: Deben coincidir exactamente entre Google Cloud Console y Supabase
- **Seguridad**: Nunca compartir Client Secret en repositorios públicos

### Verificación del estado actual

El AuthService ya está configurado correctamente para usar Supabase OAuth. Una vez completada la configuración anterior, el Google Sign In debería funcionar sin problemas.

### Alternativas temporales

Mientras se configura Google OAuth, la app incluye un botón "Probar App (Sin Login)" para probar la funcionalidad sin autenticación.
