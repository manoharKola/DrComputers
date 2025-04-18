import 'dart:ui';
import 'package:drcomputer/HomeSection.dart';
import 'package:drcomputer/aboutus.dart';
import 'package:drcomputer/dashboard.dart';
import 'package:drcomputer/router.dart';
import 'package:drcomputer/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addProduct.dart';
import 'contactus.dart';
import 'loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Dr. Computers Web',
      routerConfig: router,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey servicesKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  String _activeSection = 'Home';
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final positions = {
      'Home': _getOffsetForKey(homeKey),
      'About': _getOffsetForKey(aboutKey),
      'Services': _getOffsetForKey(servicesKey),
      'Contact': _getOffsetForKey(contactKey),
    };

    final scrollOffset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;

    final visibleSection = positions.entries
        .map((entry) => MapEntry(entry.key, (entry.value - scrollOffset).abs()))
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    if (visibleSection.isNotEmpty && _activeSection != visibleSection.first.key) {
      setState(() {
        _activeSection = visibleSection.first.key;
      });
    }
  }

  double _getOffsetForKey(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return double.infinity;
    final box = context.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero).dy + _scrollController.offset;
  }

  void scrollToSection(GlobalKey key, String sectionName) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _activeSection = sectionName;
        _isMenuOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 80),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      HomeSection(key: homeKey,),
                      WhoWeAreSection(key: aboutKey),
                      ServicesSection(key: servicesKey),
                      ContactSection(key: contactKey),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Image.asset(
                          'assets/logo3.png',
                          height: 40,
                        ),
                        const SizedBox(width: 12),
                        RichText(text: TextSpan(
                          children: [TextSpan(
                          text: 'DR',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                            TextSpan(
                              text: '.COMPUTERS',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ],)),
                      ],
                    ),
                    const Spacer(),
                    if (!isMobile) ...[
                      NavItem(
                        text: 'Home',
                        isActive: _activeSection == 'Home',
                        onTap: () => scrollToSection(homeKey, 'Home'),
                      ),
                      NavItem(
                        text: 'About',
                        isActive: _activeSection == 'About',
                        onTap: () => scrollToSection(aboutKey, 'About'),
                      ),
                      NavItem(
                        text: 'Services',
                        isActive: _activeSection == 'Services',
                        onTap: () => scrollToSection(servicesKey, 'Services'),
                      ),
                      NavItem(
                        text: 'Contact',
                        isActive: _activeSection == 'Contact',
                        onTap: () => scrollToSection(contactKey, 'Contact'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () async {
                          context.go("/products");
                          },
                        child: const Text(
                          'View Products',
                          style: TextStyle(
                            color: Colors.white, // White text
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 25,)
                    ] else
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
                      )
                  ],
                ),
              ),
            ),
          ),
          if (_isMenuOpen)
            Positioned(
              top: 80,
              right: 0,
              child: Container(
                color: Colors.white,
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NavItem(
                      text: 'Home',
                      isActive: _activeSection == 'Home',
                      onTap: () => scrollToSection(homeKey, 'Home'),
                    ),
                    NavItem(
                      text: 'About',
                      isActive: _activeSection == 'About',
                      onTap: () => scrollToSection(aboutKey, 'About'),
                    ),
                    NavItem(
                      text: 'Services',
                      isActive: _activeSection == 'Services',
                      onTap: () => scrollToSection(servicesKey, 'Services'),
                    ),
                    NavItem(
                      text: 'Contact',
                      isActive: _activeSection == 'Contact',
                      onTap: () => scrollToSection(contactKey, 'Contact'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          context.go("/products");
                        },
                        child: const Text(
                          'View Products',
                          style: TextStyle(
                            color: Colors.white, // White text
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}



class NavItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isActive;
  const NavItem({super.key, required this.text, required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? Colors.red.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.red : Colors.black87,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}