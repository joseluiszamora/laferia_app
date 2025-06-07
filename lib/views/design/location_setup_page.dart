import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laferia/core/routes/app_routes.dart';
import 'package:laferia/core/themes/design_theme.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';
import 'package:laferia/views/design/components/custom_text_field.dart';

class LocationSetupPage extends StatefulWidget {
  const LocationSetupPage({Key? key}) : super(key: key);

  @override
  State<LocationSetupPage> createState() => _LocationSetupPageState();
}

class _LocationSetupPageState extends State<LocationSetupPage> {
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  bool _isLoading = false;
  String _selectedAddressType = "Personal";

  @override
  void dispose() {
    _addressController.dispose();
    _landmarkController.dispose();
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
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Setup your delivery location",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.headlineMedium?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Map placeholder
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          // Map placeholder
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 48,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Map View",
                                  style: TextStyle(
                                    color: theme.textTheme.bodyMedium?.color,
                                    fontFamily: 'Kodchasan',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Location marker
                          Center(
                            child: Icon(
                              Icons.location_pin,
                              color: theme.colorScheme.primary,
                              size: 32,
                            ),
                          ),
                          // Set location button
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton.small(
                              onPressed: _getCurrentLocation,
                              backgroundColor: theme.colorScheme.primary,
                              child: const Icon(
                                Icons.my_location,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Primary address field
                    CustomTextField(
                      label: "Primary address",
                      hint: "Enter your address",
                      controller: _addressController,
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      margin: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    // Landmark field
                    CustomTextField(
                      label: "Landmark detail",
                      hint: "Enter landmark",
                      controller: _landmarkController,
                      prefixIcon: Icon(
                        Icons.place_outlined,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      margin: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),
                    // Address type selection
                    Text(
                      "Address type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.titleMedium?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _AddressTypeButton(
                            icon: Icons.home_outlined,
                            label: "Personal",
                            isSelected: _selectedAddressType == "Personal",
                            onTap: () {
                              setState(() {
                                _selectedAddressType = "Personal";
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AddressTypeButton(
                            icon: Icons.business_outlined,
                            label: "Business",
                            isSelected: _selectedAddressType == "Business",
                            onTap: () {
                              setState(() {
                                _selectedAddressType = "Business";
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AddressTypeButton(
                            icon: Icons.location_on_outlined,
                            label: "Other",
                            isSelected: _selectedAddressType == "Other",
                            onTap: () {
                              setState(() {
                                _selectedAddressType = "Other";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                text: "Save address",
                isLoading: _isLoading,
                onPressed: _handleSaveAddress,
                margin: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    // Simulate getting current location
    _addressController.text = "123 Main Street, City Center";
    _landmarkController.text = "Near Central Park";
  }

  void _handleSaveAddress() async {
    if (_addressController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Simulate saving address
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success and navigate to completion
      context.push(AppRoutes.setupComplete);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your address'),
          backgroundColor: DesignTheme.errorColor,
        ),
      );
    }
  }
}

class _AddressTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyMedium?.color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.textTheme.titleMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
