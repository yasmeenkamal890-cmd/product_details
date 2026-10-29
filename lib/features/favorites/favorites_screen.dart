import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 112, height: 112,
            decoration: BoxDecoration(color: const Color(0xFFFFE8EE), borderRadius: BorderRadius.circular(32)),
            child: const Icon(Icons.favorite_rounded, size: 54, color: Color(0xFFE94B77)),
          ),
          const SizedBox(height: 22),
          const Text('Your Favorites', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Products you love will appear here.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
          const SizedBox(height: 18),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.explore_outlined), label: const Text('Explore products')),
        ]),
      ),
    );
  }
}
