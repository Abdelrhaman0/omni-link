import '../../../../models/product_model.dart';

abstract class ProductsStates {}

class ProductsInitialState extends ProductsStates {}

// Get product details states
class GetProductDetailsLoadingState extends ProductsStates {}

class GetProductDetailsSuccessState extends ProductsStates {
  final ProductModel product;
  GetProductDetailsSuccessState(this.product);
}

class GetProductDetailsErrorState extends ProductsStates {
  final String error;
  GetProductDetailsErrorState(this.error);
}

// Add to cart states
class AddToCartLoadingState extends ProductsStates {}

class AddToCartSuccessState extends ProductsStates {
  final int productId;
  final int quantity;
  AddToCartSuccessState(this.productId, this.quantity);
}

class AddToCartErrorState extends ProductsStates {
  final String error;
  AddToCartErrorState(this.error);
}

// Toggle favorite states
class ToggleFavoriteLoadingState extends ProductsStates {}

class ToggleFavoriteSuccessState extends ProductsStates {
  final int productId;
  final bool isFavorite;
  ToggleFavoriteSuccessState(this.productId, this.isFavorite);
}

class ToggleFavoriteErrorState extends ProductsStates {
  final String error;
  ToggleFavoriteErrorState(this.error);
}
