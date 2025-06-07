import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laferia/core/routes/app_routes.dart';
import 'package:laferia/core/themes/design_theme.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';

class SetupCompletePage extends StatelessWidget {
  const SetupCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success illustration
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      DesignTheme.primaryColor.withOpacity(0.2),
                      DesignTheme.primaryLightColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: DesignTheme.primaryColor,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Title
              const Text(
                "Setup account completed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: DesignTheme.textPrimaryColor,
                  fontFamily: 'Kodchasan',
                ),
              ),
              const SizedBox(height: 16),
              // Description
              const Text(
                "Now you can start ordering your favorite foods from restaurants near you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: DesignTheme.textSecondaryColor,
                  height: 1.5,
                  fontFamily: 'Kodchasan',
                ),
              ),
              const Spacer(),
              // Start button
              PrimaryButton(
                text: "Start Ordering Now",
                onPressed: () {
                  context.go(AppRoutes.navigation);
                },
                margin: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
