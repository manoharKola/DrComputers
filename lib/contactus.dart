import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      color: Colors.grey[100],
      child: isMobile
          ? Column(
        children: [
          _buildProfiles(),
          const SizedBox(height: 32),
          _buildContactInfo(),
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildProfiles()),
          const SizedBox(width: 48),
          Expanded(child: _buildContactInfo()),
        ],
      ),
    );
  }

  Widget _buildProfiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meet Our Team',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildProfileCard('Madeena', 'Founder & CEO', 'assets/images/madeena.png'),
        const SizedBox(height: 16),
        _buildProfileCard('Siva', 'Founder & CEO', 'assets/images/siva.png'),
      ],
    );
  }

  Widget _buildProfileCard(String name, String role, String imagePath) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(role, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        )
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Us',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        const Text('📍 Dr. Computers, 2-6-7/1, RTC Complex Rd, opposite Kokila Restaurant, Bhanugudi Junction, Kakinada, 533003'),
        const SizedBox(height: 12),
        const Text('📞 +91 9876543210'),
        const SizedBox(height: 12),
        const Text('✉️ contact@drcomputers.com'),
        const SizedBox(height: 24),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
          child: const Center(child: Text('Google Maps Embed Placeholder')),
        ),
        const SizedBox(height: 24),
        const Text('⏰ Timings:'),
        const Text('Mon - Sat: 9:00 AM - 7:00 PM'),
        const Text('Sun: Closed'),
      ],
    );
  }
}
