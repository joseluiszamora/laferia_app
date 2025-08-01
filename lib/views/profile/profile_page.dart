import 'package:flutter/material.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';
import 'package:laferia/views/design/components/custom_text_field.dart';
import 'package:laferia/core/services/auth_service.dart';
import 'package:laferia/core/providers/theme_provider.dart';
import 'package:laferia/core/providers/auth_provider.dart';
import 'package:laferia/core/widgets/auth_wrapper.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isEditing = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      _nameController.text =
          _authService.userDisplayName ??
          user.userMetadata?['full_name'] ??
          'Usuario sin nombre';
      _emailController.text = user.email ?? 'Sin email';
      _phoneController.text = user.userMetadata?['phone'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.textTheme.titleMedium?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Perfil",
          style: TextStyle(
            color: theme.textTheme.headlineMedium?.color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kodchasan',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  // Save changes
                  _saveProfile();
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile picture and basic info
            _buildProfileHeader(theme),
            const SizedBox(height: 32),

            // Personal information
            _buildPersonalInfoSection(theme),
            const SizedBox(height: 24),

            // Quick actions
            _buildQuickActionsSection(theme),
            const SizedBox(height: 24),

            // Settings
            _buildSettingsSection(theme),
            const SizedBox(height: 24),

            // Logout button
            SecondaryButton(
              text: "Cerrar Sesión",
              onPressed: () => _signOut(context),
              margin: EdgeInsets.zero,
              backgroundColor: Colors.red.shade50,
              textColor: Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // try {
    //   final result = await authProvider.signOut();

    //   if (!result.isSuccess && context.mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(result.message), backgroundColor: Colors.red),
    //     );
    //   }
    //   // Si el signOut es exitoso, el AuthWrapper se encargará de navegar al login automáticamente
    // } catch (e) {
    //   if (context.mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Error al cerrar sesión: ${e.toString()}'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // }
    try {
      // Primero cerrar la sesión
      await _authService.signOut();

      if (mounted) {
        // Usar AuthProvider para actualizar el estado
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.signOut();

        // Navegar al AuthWrapper que manejará automáticamente mostrar login
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cerrar sesión: ${e.toString()}")),
        );
      }
    }
  }

  Widget _buildProfileHeader(ThemeData theme) {
    final user = _authService.currentUser;
    final avatarUrl = user?.userMetadata?['avatar_url'];

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              backgroundImage:
                  avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
              child:
                  avatarUrl == null || avatarUrl.isEmpty
                      ? Icon(
                        Icons.person,
                        size: 60,
                        color: theme.colorScheme.primary,
                      )
                      : null,
            ),
            if (_isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _changeProfilePicture(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _nameController.text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineMedium?.color,
            fontFamily: 'Kodchasan',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _emailController.text,
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyMedium?.color,
            fontFamily: 'Kodchasan',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                user?.emailConfirmedAt != null
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                user?.emailConfirmedAt != null ? Icons.verified : Icons.warning,
                size: 16,
                color:
                    user?.emailConfirmedAt != null
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                user?.emailConfirmedAt != null
                    ? "Cuenta Verificada"
                    : "Email sin verificar",
                style: TextStyle(
                  color:
                      user?.emailConfirmedAt != null
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: 'Kodchasan',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Información Personal",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: "Nombre Completo",
            controller: _nameController,
            enabled: _isEditing,
            prefixIcon: Icon(
              Icons.person_outline,
              color: theme.textTheme.bodyMedium?.color,
            ),
            margin: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: "Correo Electrónico",
            controller: _emailController,
            enabled: false, // El email no se puede editar
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: theme.textTheme.bodyMedium?.color,
            ),
            margin: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: "Número de Teléfono",
            controller: _phoneController,
            enabled: _isEditing,
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: theme.textTheme.bodyMedium?.color,
            ),
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Acciones Rápidas",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.history,
                  label: "Historial",
                  theme: theme,
                  onTap: () => _navigateToOrderHistory(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.favorite_outline,
                  label: "Favoritos",
                  theme: theme,
                  onTap: () => _navigateToFavorites(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.location_on_outlined,
                  label: "Direcciones",
                  theme: theme,
                  onTap: () => _navigateToAddresses(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.payment,
                  label: "Pagos",
                  theme: theme,
                  onTap: () => _navigateToPaymentMethods(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(ThemeData theme) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Configuración",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 16),

          // Selector de tema
          _buildThemeSelector(theme, themeProvider),
          const SizedBox(height: 8),

          _buildSettingItem(
            theme,
            Icons.notifications_outlined,
            "Notificaciones",
            "Gestiona tus preferencias de notificación",
            () => _navigateToNotifications(),
          ),
          _buildSettingItem(
            theme,
            Icons.security,
            "Privacidad y Seguridad",
            "Gestiona tu configuración de privacidad",
            () => _navigateToPrivacy(),
          ),
          _buildSettingItem(
            theme,
            Icons.help_outline,
            "Ayuda y Soporte",
            "Obtén ayuda y contacta con soporte",
            () => _navigateToSupport(),
          ),
          _buildSettingItem(
            theme,
            Icons.info_outline,
            "Acerca de",
            "Versión de la app e información",
            () => _showAboutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    ThemeData theme,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Kodchasan'),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: theme.textTheme.bodySmall?.color,
          fontFamily: 'Kodchasan',
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.textTheme.bodySmall?.color,
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeSelector(ThemeData theme, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema ${themeProvider.isDarkMode ? 'Oscuro' : 'Claro'}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Kodchasan',
                  ),
                ),
                Text(
                  'Cambia entre tema claro y oscuro',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                    fontFamily: 'Kodchasan',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (_) {
              themeProvider.toggleTheme();
            },
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Funcionalidad de galería próximamente"),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Funcionalidad de cámara próximamente"),
                    ),
                  );
                },
              ),
              if (_authService.currentUser?.userMetadata?['avatar_url'] != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Eliminar foto actual',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfilePicture();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _removeProfilePicture() async {
    try {
      await _authService.updateProfile(additionalData: {'avatar_url': null});

      setState(() {
        _loadUserData(); // Recargar datos para actualizar UI
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto de perfil eliminada")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar foto: ${e.toString()}")),
        );
      }
    }
  }

  void _saveProfile() async {
    try {
      // Validar que el nombre no esté vacío
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El nombre no puede estar vacío")),
        );
        return;
      }

      // Actualizar el perfil del usuario
      await _authService.updateProfile(
        displayName: _nameController.text.trim(),
        additionalData: {'phone': _phoneController.text.trim()},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perfil actualizado exitosamente")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al actualizar perfil: ${e.toString()}"),
          ),
        );
      }
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Cerrar Sesión",
              style: TextStyle(fontFamily: 'Kodchasan'),
            ),
            content: Text(
              "¿Estás seguro de que quieres cerrar sesión?",
              style: TextStyle(fontFamily: 'Kodchasan'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    // Primero cerrar la sesión
                    await _authService.signOut();

                    if (mounted) {
                      // Usar AuthProvider para actualizar el estado
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      await authProvider.signOut();

                      // Navegar al AuthWrapper que manejará automáticamente mostrar login
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const AuthWrapper(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Error al cerrar sesión: ${e.toString()}",
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  "Cerrar Sesión",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _navigateToOrderHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navegar a Historial de Pedidos")),
    );
  }

  void _navigateToFavorites() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navegar a Favoritos")));
  }

  void _navigateToAddresses() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navegar a Direcciones")));
  }

  void _navigateToPaymentMethods() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navegar a Métodos de Pago")));
  }

  void _navigateToNotifications() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navegar a Notificaciones")));
  }

  void _navigateToPrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navegar a Configuración de Privacidad")),
    );
  }

  void _navigateToSupport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navegar a Soporte")));
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "LaFeria",
      applicationVersion: "1.0.0",
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.store, color: Colors.white, size: 30),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                fontFamily: 'Kodchasan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
