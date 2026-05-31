import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/products_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsStates> {
  final ProductsRepository repository;

  ProductsCubit(this.repository) : super(ProductsInitialState());

  static ProductsCubit get(BuildContext context) => BlocProvider.of<ProductsCubit>(context);

  Future<void> fetchProductDetails(int id) async {
    emit(GetProductDetailsLoadingState());
    try {
      final product = await repository.getProductDetails(id);
      emit(GetProductDetailsSuccessState(product));
    } catch (e) {
      emit(GetProductDetailsErrorState(e.toString()));
    }
  }

  Future<void> addToCart(int id, int quantity) async {
    emit(AddToCartLoadingState());
    try {
      await repository.addToCart(id, quantity);
      emit(AddToCartSuccessState(id, quantity));
    } catch (e) {
      emit(AddToCartErrorState(e.toString()));
    }
  }

  Future<void> toggleFavorite(int id) async {
    // In a clean architecture, favorites are typically loaded or updated reactively.
    emit(ToggleFavoriteLoadingState());
    try {
      await repository.toggleFavorite(id);
      emit(ToggleFavoriteSuccessState(id, true));
    } catch (e) {
      emit(ToggleFavoriteErrorState(e.toString()));
    }
  }
}
