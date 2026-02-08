import 'package:shop_app/configs/api_url.dart';
import 'package:shop_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/product_detail.dart';

class ProductService {
  Future<Products> products(String? cursor) async {
    final uri = Uri.parse('${ApiUrl.baseUrl}/products');
    if (cursor != null) {
      uri.replace(queryParameters: {cursor: cursor});
    }
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return productsFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> productDetail(productId) async {
    final response = await http.get(
      Uri.parse('${ApiUrl.baseUrl}/products/$productId'),
    );
    if (response.statusCode == 200) {
      return productFromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
