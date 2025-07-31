# Sistema de Autenticación LaFeria

## 📋 Resumen

Este documento describe el nuevo sistema de autenticación implementado para LaFeria, que incluye login con email/contraseña, registro de usuarios, recuperación de contraseña y preparación para Google OAuth.

## 🚀 Funcionalidades Implementadas

### ✅ Completado

- **Login con Email/Contraseña**: Autenticación segura usando Supabase
- **Registro de Usuarios**: Creación de nuevas cuentas con validación
- **Recuperación de Contraseña**: Envío de enlaces de restablecimiento por email
- **Gestión de Sesiones**: Manejo automático de tokens y estado de autenticación
- **Interfaz Moderna**: Páginas con diseño Material Design actualizado
- **Validación Robusta**: Validación de formularios y manejo de errores
- **Navegación Integrada**: Rutas configuradas con GoRouter

### 🔄 En Desarrollo

- **Google OAuth**: Preparado pero temporalmente deshabilitado por problemas de configuración
- **Perfil de Usuario**: Gestión completa del perfil
- **Configuraciones Avanzadas**: Opciones adicionales de seguridad

## 📁 Estructura de Archivos

```
lib/
├── core/
│   ├── services/
│   │   └── auth_service_new.dart          # Servicio principal de autenticación
│   └── routes/
│       ├── app_routes.dart                # Definición de rutas
│       └── app_router.dart                # Configuración del router
└── views/
    └── auth/
        ├── login_page.dart                # Página de inicio de sesión
        ├── register_page.dart             # Página de registro
        ├── forgot_password_page.dart      # Página de recuperación
        └── home_page_demo.dart           # Página demo post-login
```

## 🔧 Configuración

### Supabase

El sistema está configurado para usar Supabase como backend de autenticación:

- URL: `https://sfporjwgzplyckosbdqx.supabase.co`
- Flujo de autenticación: PKCE
- Políticas de seguridad activadas

### Rutas Disponibles

- `/new-login` - Página de inicio de sesión
- `/new-register` - Página de registro
- `/new-forgot-password` - Recuperación de contraseña
- `/home-demo` - Página demo después del login

## 💻 Uso del Sistema

### AuthService

```dart
import '../../core/services/auth_service_new.dart';

// Login
final result = await AuthService.signInWithEmail(
  email: 'usuario@email.com',
  password: 'contraseña123',
);

// Registro
final result = await AuthService.signUpWithEmail(
  email: 'nuevo@email.com',
  password: 'contraseña123',
  fullName: 'Nombre Completo',
);

// Recuperar contraseña
final result = await AuthService.resetPassword(
  email: 'usuario@email.com',
);

// Cerrar sesión
final result = await AuthService.signOut();
```

### Navegación

```dart
// Ir a login
Navigator.of(context).pushNamed('/new-login');

// Ir a registro
Navigator.of(context).pushNamed('/new-register');

// Ir a recuperar contraseña
Navigator.of(context).pushNamed('/new-forgot-password');
```

## 🎯 Características Técnicas

### Validación de Formularios

- Email con regex validation
- Contraseñas mínimo 6 caracteres
- Confirmación de contraseña
- Nombres con longitud mínima

### Manejo de Errores

- Mensajes específicos para cada tipo de error
- UI feedback inmediato
- Estados de loading consistentes

### Seguridad

- Passwords nunca se almacenan en texto plano
- Tokens JWT manejados automáticamente por Supabase
- Validación del lado del servidor

### UX/UI

- Diseño moderno con Material Design
- Estados de loading visibles
- Mensajes de éxito y error claros
- Navegación intuitiva entre pantallas

## 🚦 Próximos Pasos

1. **Google OAuth**: Resolver configuración de OAuth en Supabase
2. **Perfil de Usuario**: Crear pantalla de gestión de perfil
3. **Persistencia Local**: Implementar cache de datos del usuario
4. **Notificaciones**: Integrar push notifications
5. **Validación Email**: Mejorar flujo de confirmación de email

## 🐛 Problemas Conocidos

1. **Google Sign-In**: Temporalmente deshabilitado por problemas de API
2. **Email Verification**: Flujo básico implementado, necesita mejoras UI
3. **Deep Links**: No configurados para reset de contraseña

## 🔍 Testing

Para probar el sistema:

1. Ejecutar la app: `flutter run`
2. La app iniciará en la página de login (`/new-login`)
3. Crear una cuenta nueva o usar credenciales existentes
4. Probar flujo de recuperación de contraseña
5. Verificar navegación entre pantallas

## 📞 Soporte

Para reportar problemas o solicitar nuevas funcionalidades:

- Crear un issue en el repositorio
- Documentar pasos para reproducir el problema
- Incluir logs de error si están disponibles

---

**Última actualización**: Julio 2025  
**Versión**: 1.0.0  
**Estado**: ✅ Funcional para producción (sin Google OAuth)
