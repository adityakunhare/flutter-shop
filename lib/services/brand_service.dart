import 'package:http/http.dart' as http;
import 'package:shop_app/configs/api.dart';
import 'package:shop_app/models/brand_list.dart';

class BrandService {
  Future<BrandList> brands() async {
    final urlString = '${Api.brands()}';
    final uri = Uri.parse(urlString);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return brandsFromJson(response.body);
    } else {
      throw Exception('Failed to load brands');
    }
  }
}
