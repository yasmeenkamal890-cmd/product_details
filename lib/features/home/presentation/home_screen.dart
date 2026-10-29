import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_model.dart';
import '../logic/products_cubit.dart';
import '../logic/products_state.dart';
import '../../product_details/logic/product_details_cubit.dart';
import '../../product_details/presentation/product_details_screen.dart';
import '../../favorites/favorites_screen.dart';
import '../../offers/offers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildProducts(),
      const FavoritesScreen(),
      const OffersScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Shop', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () => context.read<ProductsCubit>().loadProducts(),
              icon: const Icon(Icons.refresh_rounded), tooltip: 'Refresh'),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.local_offer_outlined), selectedIcon: Icon(Icons.local_offer), label: 'Offers'),
        ],
      ),
    );
  }

  Widget _buildProducts() {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state.status == ProductsStatus.loading || state.status == ProductsStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProductsStatus.failure) {
          return _MessageState(message: state.errorMessage ?? 'Something went wrong',
              onRetry: () => context.read<ProductsCubit>().loadProducts());
        }
        if (state.products.isEmpty) return const Center(child: Text('No products found'));
        return RefreshIndicator(
          onRefresh: () => context.read<ProductsCubit>().loadProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: .62,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) => _ProductCard(product: state.products[index]),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(productId: product.id),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'product-${product.id}',
                  child: Image.network(product.thumbnail, fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, size: 48, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 5),
            Text('\$${product.discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5559D9))),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star_rounded, size: 17, color: Colors.amber),
              Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded, size: 17),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ]),
    ),
  );
}
