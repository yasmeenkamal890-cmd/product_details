import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/data/products_repository.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._repository) : super(const ProductDetailsState());

  final ProductsRepository _repository;

  Future<void> loadProduct(int id) async {
    emit(state.copyWith(status: ProductDetailsStatus.loading, errorMessage: null));
    try {
      final product = await _repository.getProductById(id);
      emit(state.copyWith(
        status: ProductDetailsStatus.success,
        product: product,
        selectedImageIndex: 0,
        selectedSize: null,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ProductDetailsStatus.failure,
        errorMessage: 'تعذر تحميل تفاصيل المنتج. تأكدي من الاتصال بالإنترنت.',
      ));
    }
  }

  void selectImage(int index) {
    final product = state.product;
    if (product == null || index < 0 || index >= product.images.length) return;
    emit(state.copyWith(selectedImageIndex: index));
  }

  void selectSize(String size) => emit(state.copyWith(selectedSize: size));
}
