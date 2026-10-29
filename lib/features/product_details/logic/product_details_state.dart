import '../../home/data/product_model.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState {
  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.selectedImageIndex = 0,
    this.selectedSize,
    this.errorMessage,
  });

  final ProductDetailsStatus status;
  final Product? product;
  final int selectedImageIndex;
  final String? selectedSize;
  final String? errorMessage;

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    Product? product,
    int? selectedImageIndex,
    String? selectedSize,
    String? errorMessage,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedSize: selectedSize ?? this.selectedSize,
      errorMessage: errorMessage,
    );
  }
}
