import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laferia/core/routes/app_routes.dart';
import 'package:laferia/core/themes/design_theme.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({Key? key, required this.email})
    : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: DesignTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: DesignTheme.textPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: DesignTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.email_outlined,
                  size: 50,
                  color: DesignTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                "Verify your Email",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: DesignTheme.textPrimaryColor,
                  fontFamily: 'Kodchasan',
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                "Please enter the 6-digit code sent to ${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: DesignTheme.textSecondaryColor,
                  height: 1.5,
                  fontFamily: 'Kodchasan',
                ),
              ),
              const SizedBox(height: 40),
              // OTP Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: DesignTheme.textPrimaryColor,
                        fontFamily: 'Kodchasan',
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: DesignTheme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: DesignTheme.grayLightColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: DesignTheme.grayLightColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: DesignTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              // Resend code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't get the email? ",
                    style: TextStyle(
                      color: DesignTheme.textSecondaryColor,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                  TextButton(
                    onPressed: _resendCode,
                    child: const Text(
                      "Resend now",
                      style: TextStyle(
                        color: DesignTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Verify button
              PrimaryButton(
                text: "Verify",
                isLoading: _isLoading,
                onPressed: _handleVerification,
                margin: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _handleVerification() async {
    String code = _codeControllers.map((c) => c.text).join();

    if (code.length == 6) {
      setState(() {
        _isLoading = true;
      });

      // Simulate verification process
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success and navigate
      _showSuccessDialog();
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: DesignTheme.errorColor,
        ),
      );
    }
  }

  void _resendCode() {
    // Simulate resend code
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification code sent again'),
        backgroundColor: DesignTheme.successColor,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: DesignTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 50,
                    color: DesignTheme.successColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Registration Success",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: DesignTheme.textPrimaryColor,
                    fontFamily: 'Kodchasan',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your account has been created successfully. Start using our app now!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DesignTheme.textSecondaryColor,
                    fontFamily: 'Kodchasan',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go(AppRoutes.cuisineSelection);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Get Started!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
