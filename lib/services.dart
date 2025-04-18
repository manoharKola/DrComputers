import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final leftItems = [
      _buildServiceItem(
        icon: Icons.laptop_mac,
        title: 'Refurbished Systems',
        description: 'Affordable laptops and desktops, quality tested and reliable.',
        isIconLeft: true,
        backgroundColor: Colors.white,
      ),
      _buildServiceItem(
        icon: Icons.print,
        title: 'Printers & Accessories',
        description: 'All types of printers, cartridges, and computer accessories.',
        isIconLeft: false,
        backgroundColor: Colors.grey.shade100,
      ),
      _buildServiceItem(
        icon: Icons.videocam,
        title: 'CCTV & Security',
        description: 'Modern surveillance solutions for homes and businesses.',
        isIconLeft: true,
        backgroundColor: Colors.white,
      ),
    ];

    final rightItems = [
      _buildServiceItem(
        icon: Icons.build,
        title: 'Sales & Service',
        description: 'End-to-end computer system sales and maintenance support.',
        isIconLeft: false,
        backgroundColor: Colors.grey.shade100,
      ),
      _buildServiceItem(
        icon: Icons.desktop_windows,
        title: 'System Rentals',
        description: 'Short and long-term computer rentals for events or offices.',
        isIconLeft: true,
        backgroundColor: Colors.white,
      ),
      _buildServiceItem(
        icon: Icons.verified_user,
        title: 'Third Level Support',
        description: 'Advanced technical troubleshooting and resolution services.',
        isIconLeft: false,
        backgroundColor: Colors.grey.shade100,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Our Services',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          if (isMobile)
            Column(
              children: [...leftItems, ...rightItems],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(children: leftItems),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(children: rightItems),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isIconLeft,
    required Color backgroundColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(28),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment:
        isIconLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isIconLeft) ...[
            Icon(icon, size: 56, color: Colors.red),
            const SizedBox(width: 24),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment:
              isIconLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (!isIconLeft) ...[
            const SizedBox(width: 24),
            Icon(icon, size: 56, color: Colors.red),
          ],
        ],
      ),
    );
  }
}
