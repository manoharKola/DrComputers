import 'package:flutter/material.dart';

class WhoWeAreSection extends StatelessWidget {
  const WhoWeAreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: Colors.grey.shade100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Who We Are',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Dr. Computers is a trusted name in technology solutions, serving our community for over a decade. '
                'We specialize in providing high-quality refurbished laptops and desktops, as well as a wide range of services '
                'including printer and accessory sales, CC camera installations, rental systems, and third-level technical support. '
                'Our mission is to make advanced computing accessible and affordable for everyone, whether you are a student, a business, or a home user. '
                'We pride ourselves on our customer-first approach, expert service, and long-term support to ensure your devices run efficiently and securely.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 40),

          // Google Maps Rating
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_half, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    '4.5 on Google Reviews',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Testimonials
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: const [
                  TestimonialCard(
                    name: 'Amit S.',
                    comment:
                    'Excellent service and very knowledgeable staff! Helped me fix my laptop quickly and at a good price.',
                  ),
                  TestimonialCard(
                    name: 'Sneha R.',
                    comment:
                    'Highly recommend Dr. Computers! Bought a refurbished laptop and it works like new.',
                  ),
                  TestimonialCard(
                    name: 'Rajeev T.',
                    comment:
                    'Installed CCTV at my home. Great support and installation service. Very professional team.',
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String name;
  final String comment;

  const TestimonialCard({super.key, required this.name, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            '- $name',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
