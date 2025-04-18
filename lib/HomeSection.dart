import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class HomeSection extends StatefulWidget {
  const HomeSection({super.key});

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  final List<Map<String, String>> services = [
    {
      'title': '🖥️ Custom PC Builds',
      'description': 'Tailored desktop solutions built to match your unique performance needs.From gaming rigs to workstations — we craft it your way.',
      'image': 'assets/images/custompc_bg.jpg',
    },
    {
      'title': '🛠️ Computer Services',
      'description': 'Comprehensive repair, upgrade, and maintenance services for all systems.Quick diagnostics and expert solutions, right when you need them.',
      'image': 'assets/images/home_bg.jpg',
    },
    {
      'title': '💻 Refurbished Laptops at Lowest Price',
      'description': 'High-quality, budget-friendly laptops backed by thorough testing.Perfect performance without breaking the bank',
      'image': 'assets/images/laptops_bg.jpg',
    },
    {
      'title': '📷 CCTV Installation',
      'description': 'Secure your home or business with smart surveillance setups.Professional installation with reliable, round-the-clock coverage.',
      'image': 'assets/images/cctv_bg.jpg',
    },
  ];
  int _serviceIndex = 0;
  Timer? _switchTimer;

  @override
  void initState() {
    super.initState();
    _switchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _serviceIndex = (_serviceIndex + 1) % services.length;
      });
    });
  }

  @override
  void dispose() {
    _switchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenHeight = MediaQuery.of(context).size.height;

    final currentService = services[_serviceIndex];

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: SizedBox(
            key: ValueKey(currentService['image']),
            width: double.infinity,
            height: screenHeight * 0.7,
            child: Image.asset(
              currentService['image']!,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Tweaked Overlay: darker + soft tint
        Container(
          width: double.infinity,
          height: screenHeight * 0.7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Optional gradient from left with more opacity
        Container(
          width: double.infinity,
          height: screenHeight * 0.7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        Positioned(
          left: isMobile ? 20 : 60,
          top: screenHeight * 0.22,
          right: 20,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Column(
              key: ValueKey(currentService['title']),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome to ',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 28 : 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.6),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: 'DR',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 28 : 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.6),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      TextSpan(
                        text: '.COMPUTERS',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 28 : 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.6),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currentService['title']!,
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 20 : 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentService['description']!,
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 14 : 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}