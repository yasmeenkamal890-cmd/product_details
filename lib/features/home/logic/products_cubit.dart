import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/products_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState());

  final ProductsRepository _repository;

  Future<void> loadProducts() async {
    emit(state.copyWith(status: ProductsStatus.loading, errorMessage: null));
    try {
      final products = await _repository.getProducts();
      emit(state.copyWith(status: ProductsStatus.success, products: products));
    } catch (error) {
      emit(state.copyWith(
        status: ProductsStatus.failure,
        errorMessage: 'Could not load products. Check your internet connection and try again.',
      ));
    }
  }
}
