import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_detail.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/services/product_service.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedSize = 0;
  Product product = Product(
    data: Data(
      type: '',
      id: 0,
      attributes: Attributes(
        title: '',
        imageUrl: '',
        price: 0,
        sizes: [],
        colors: [],
        category: '',
        brand: '',
      ),
    ),
  );
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProductDetail(widget.productId);
  }

  Future<void> _loadProductDetail(productId) async {
    try {
      final response = await ProductService().productDetail(productId);
      setState(() {
        product = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void onTap() {
    if (selectedSize != 0) {
      context.read<CartProvider>().addProduct({
        'id': product.data.id,
        'title': product.data.attributes.title,
        'price': product.data.attributes.price,
        'company': product.data.attributes.brand,
        'imageURL': product.data.attributes.imageUrl,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product added to cart')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a size')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product details'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(
                  product.data.attributes.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    product.data.attributes.imageUrl,
                    height: 500,
                  ),
                ),
                const Spacer(flex: 2),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 234, 237, 239),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$${product.data.attributes.price}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: product.data.attributes.sizes.length,
                          itemBuilder: (context, index) {
                            final size =
                                (product.data.attributes.sizes)[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSize = index;
                                  });
                                },
                                child: Chip(
                                  label: Text(size.toString()),
                                  backgroundColor: selectedSize == index
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                      : Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
