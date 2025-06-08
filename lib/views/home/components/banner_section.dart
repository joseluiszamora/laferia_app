import 'dart:async';

import 'package:flutter/material.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  final List<BannerItem> _banners = [
    BannerItem(
      title: "Happy Sunday",
      subtitle: "Get 50%+ Discount!",
      buttonText: "Get Now",
      backgroundColor: Color(0xFFFF8C69),
      imageUrl: "🥝", // Placeholder emoji
    ),
    BannerItem(
      title: "Fresh Fruits",
      subtitle: "Healthy & Delicious",
      buttonText: "Order Now",
      backgroundColor: Color(0xFF4CAF50),
      imageUrl: "🍓",
    ),
    BannerItem(
      title: "Pizza Special",
      subtitle: "Buy 1 Get 1 Free",
      buttonText: "Order",
      backgroundColor: Color(0xFFFF6B35),
      imageUrl: "🍕",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_banners.isNotEmpty) {
        _currentBannerIndex = (_currentBannerIndex + 1) % _banners.length;
        if (_bannerController.hasClients) {
          _bannerController.animateToPage(
            _currentBannerIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _navigateToBannerOffer(BannerItem banner) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opening offer: ${banner.title}')));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final banner = _banners[index];
          return Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: banner.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: banner.backgroundColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _navigateToBannerOffer(banner),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner.buttonText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Kodchasan',
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        banner.imageUrl,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BannerItem {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color backgroundColor;
  final String imageUrl;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.backgroundColor,
    required this.imageUrl,
  });
}
