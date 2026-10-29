import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = [
      _OfferData('WEEKEND DEAL', 'Up to 40% off', 'Refresh your favorites with special weekend prices.', Icons.weekend_rounded, const Color(0xFF5B5FEF), const Color(0xFFE9E9FF)),
      _OfferData('NEW SEASON', 'New arrivals', 'Discover fresh picks selected just for you.', Icons.auto_awesome_rounded, const Color(0xFF0D9488), const Color(0xFFDDF8F3)),
      _OfferData('LIMITED TIME', 'Extra savings', 'Find selected items at a special price.', Icons.bolt_rounded, const Color(0xFFEA580C), const Color(0xFFFFEAD9)),
    ];
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Special Offers', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('A little something special for your next find.', style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 18),
        ...offers.map((offer) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: offer.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: .75), borderRadius: BorderRadius.circular(20)),
                child: Text(offer.kicker, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: offer.foreground)),
              ),
              const SizedBox(height: 12),
              Text(offer.title, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: offer.foreground)),
              const SizedBox(height: 6),
              Text(offer.description, style: TextStyle(color: offer.foreground.withValues(alpha: .85), height: 1.35)),
              const SizedBox(height: 14),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: offer.foreground, foregroundColor: Colors.white),
                onPressed: () {},
                child: const Text('Explore'),
              ),
            ])),
            const SizedBox(width: 8),
            Container(
              width: 76, height: 76,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .7), shape: BoxShape.circle),
              child: Icon(offer.icon, size: 42, color: offer.foreground),
            ),
          ]),
        )),
      ],
    );
  }
}

class _OfferData {
  const _OfferData(this.kicker, this.title, this.description, this.icon, this.foreground, this.background);
  final String kicker;
  final String title;
  final String description;
  final IconData icon;
  final Color foreground;
  final Color background;
}
