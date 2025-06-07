import 'package:flutter/material.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';
import 'package:laferia/views/design/components/custom_text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(
    text: "John Doe",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "john.doe@example.com",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+1 234 567 8900",
  );
  bool _isEditing = false;

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
          "Profile",
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
              text: "Logout",
              onPressed: _showLogoutDialog,
              margin: EdgeInsets.zero,
              backgroundColor: Colors.red.shade50,
              textColor: Colors.red.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 60,
                color: theme.colorScheme.primary,
              ),
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
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, size: 16, color: Colors.green.shade700),
              const SizedBox(width: 4),
              Text(
                "Verified Account",
                style: TextStyle(
                  color: Colors.green.shade700,
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
            "Personal Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            label: "Full Name",
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
            label: "Email",
            controller: _emailController,
            enabled: _isEditing,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: theme.textTheme.bodyMedium?.color,
            ),
            margin: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: "Phone Number",
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
            "Quick Actions",
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
                  label: "Order History",
                  theme: theme,
                  onTap: () => _navigateToOrderHistory(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.favorite_outline,
                  label: "Favorites",
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
                  label: "Addresses",
                  theme: theme,
                  onTap: () => _navigateToAddresses(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.payment,
                  label: "Payment",
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
            "Settings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 16),

          _buildSettingItem(
            theme,
            Icons.notifications_outlined,
            "Notifications",
            "Manage your notification preferences",
            () => _navigateToNotifications(),
          ),
          _buildSettingItem(
            theme,
            Icons.security,
            "Privacy & Security",
            "Manage your privacy settings",
            () => _navigateToPrivacy(),
          ),
          _buildSettingItem(
            theme,
            Icons.help_outline,
            "Help & Support",
            "Get help and contact support",
            () => _navigateToSupport(),
          ),
          _buildSettingItem(
            theme,
            Icons.info_outline,
            "About",
            "App version and information",
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

  void _changeProfilePicture() {
    // Implement image picker functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile picture update functionality")),
    );
  }

  void _saveProfile() {
    // Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Logout", style: TextStyle(fontFamily: 'Kodchasan')),
            content: Text(
              "Are you sure you want to logout?",
              style: TextStyle(fontFamily: 'Kodchasan'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implement logout functionality
                },
                child: Text("Logout", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _navigateToOrderHistory() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navigate to Order History")));
  }

  void _navigateToFavorites() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navigate to Favorites")));
  }

  void _navigateToAddresses() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navigate to Addresses")));
  }

  void _navigateToPaymentMethods() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navigate to Payment Methods")),
    );
  }

  void _navigateToNotifications() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navigate to Notifications")));
  }

  void _navigateToPrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navigate to Privacy Settings")),
    );
  }

  void _navigateToSupport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Navigate to Support")));
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "Tasty!",
      applicationVersion: "1.0.0",
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.restaurant, color: Colors.white, size: 30),
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
