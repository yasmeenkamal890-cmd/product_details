import '../data/product_model.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  final ProductsStatus status;
  final List<Product> products;
  final String? errorMessage;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage,
    );
  }
}
