import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/data/product_model.dart';
import '../../home/data/products_repository.dart';
import '../logic/product_details_cubit.dart';
import '../logic/product_details_state.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsCubit(context.read<ProductsRepository>())..loadProduct(productId),
      child: const _ProductDetailsView(),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state.status == ProductDetailsStatus.loading || state.status == ProductDetailsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProductDetailsStatus.failure || state.product == null) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text(state.errorMessage ?? 'Could not load product', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(onPressed: () => context.read<ProductDetailsCubit>().loadProduct(1),
                    child: const Text('Retry')),
              ]),
            ));
          }
          return _details(context, state.product!, state);
        },
      ),
    );
  }

  Widget _details(BuildContext context, Product product, ProductDetailsState state) {
    final images = product.images.isNotEmpty ? product.images : [product.thumbnail];
    final imageIndex = state.selectedImageIndex.clamp(0, images.length - 1);
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: double.infinity,
                height: constraints.maxWidth < 500 ? 280 : 360,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Stack(children: [
                  Center(
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: Image.network(images[imageIndex], fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey)),
                    ),
                  ),
                  if (product.discountPercentage > 0)
                    Positioned(top: 14, left: 14, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(20)),
                      child: Text('-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )),
                ]),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 76,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => context.read<ProductDetailsCubit>().selectImage(index),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 76,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: index == imageIndex ? const Color(0xFF5B5FEF) : Colors.grey.shade200,
                          width: index == imageIndex ? 2 : 1,
                        ),
                      ),
                      child: Image.network(images[index], fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(product.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                Text(' ${product.rating.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                Text('${product.stock} in stock', style: TextStyle(color: Colors.grey.shade600)),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Text('\$${product.discountedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Color(0xFF5559D9))),
                if (product.discountPercentage > 0) ...[
                  const SizedBox(width: 10),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade500, decoration: TextDecoration.lineThrough)),
                ],
              ]),
              const SizedBox(height: 22),
              const Text('Choose size', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(spacing: 10, children: ['S', 'M', 'L', 'XL'].map((size) {
                final selected = state.selectedSize == size;
                return ChoiceChip(
                  label: Text(size),
                  selected: selected,
                  onSelected: (_) => context.read<ProductDetailsCubit>().selectSize(size),
                );
              }).toList()),
              const SizedBox(height: 8),
              Text('Size selection is a UI option; this sample API does not provide size-specific images.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(height: 22),
              const Text('Description', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(product.description, style: TextStyle(fontSize: 15, height: 1.55, color: Colors.grey.shade700)),
              const SizedBox(height: 18),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _InfoChip(icon: Icons.category_outlined, label: product.category),
                if (product.brand.isNotEmpty) _InfoChip(icon: Icons.sell_outlined, label: product.brand),
              ]),
              const SizedBox(height: 26),
              SizedBox(width: double.infinity, child: FilledButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cart action is not part of this task.')),
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('Add to cart')),
              )),
            ]),
          ),
        ),
      );
    });
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 16),
    label: Text(label),
    backgroundColor: Colors.white,
    side: BorderSide(color: Colors.grey.shade200),
  );
}
