class Api {
  Api._();
  static const String _host = 'flutter-shop.techbycrowd.com';
  static const String base = '/api/V1';

  // static String get products => '$base/products';
  static Uri products({Map<String, String>? query}) {
    return Uri.https(_host, '$base/products', query);
  }

  // static String productDetail(int id) => '$base/products/$id';
  static Uri productDetail(int id) {
    return Uri.https(_host, '$base/products/$id');
  }

  static Uri brands() {
    return Uri.https(_host, '$base/brands');
  }
}
