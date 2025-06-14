import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laferia/core/routes/app_routes.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';
import 'package:laferia/views/design/components/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Center(
                    child: Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.headlineMedium?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Center(
                    child: Text(
                      "Welcome back! Sign in using your social account or email to continue us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Username field
                  CustomTextField(
                    label: "Username / Email",
                    hint: "Enter your username or email",
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username or email';
                      }
                      return null;
                    },
                    margin: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  // Password field
                  CustomTextField(
                    label: "Password",
                    hint: "Enter your password",
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    margin: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to forgot password
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontFamily: 'Kodchasan',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Login button
                  PrimaryButton(
                    text: "Login",
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                    margin: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
                  // Social login section
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: theme.colorScheme.outline),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Social buttons
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.g_mobiledata,
                          label: "Google",
                          onPressed: () => _handleSocialLogin('google'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.apple,
                          label: "Apple",
                          onPressed: () => _handleSocialLogin('apple'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SocialButton(
                          icon: Icons.facebook,
                          label: "Facebook",
                          onPressed: () => _handleSocialLogin('facebook'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Sign up link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push(AppRoutes.register);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Kodchasan',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate login process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to main app
      context.go(AppRoutes.navigation);
    }
  }

  void _handleSocialLogin(String provider) {
    // Handle social login
    print('Social login with $provider');
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.textTheme.titleMedium?.color,
        side: BorderSide(color: theme.colorScheme.outline),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Icon(icon, size: 24, color: theme.textTheme.bodyMedium?.color),
    );
  }
}
