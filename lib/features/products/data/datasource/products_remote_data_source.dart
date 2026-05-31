import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<ProductModel> getProductDetails(int id);
  Future<void> addToCart(int id, int quantity);
  Future<void> toggleFavorite(int id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  @override
  Future<ProductModel> getProductDetails(int id) async {
    final response = await DioHelper.getData(
      url: '$productsEndpoint/$id',
    );
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<void> addToCart(int id, int quantity) async {
    await DioHelper.postData(
      url: cartAddEndpoint,
      data: {
        'product_id': id,
        'quantity': quantity,
      },
    );
  }

  @override
  Future<void> toggleFavorite(int id) async {
    await DioHelper.postData(
      url: favoriteToggleEndpoint,
      data: {
        'product_id': id,
      },
    );
  }
}
