import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/services/product_service.dart';
import 'package:shop_app/widgets/product_card.dart';
import 'package:shop_app/pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // need api for filters as well.
  final List<String> filters = const [
    'All',
    'Addidas',
    'Nike',
    'Puma',
    'Jordan',
    'Bata',
  ];

  List<SingleProduct> products = [];
  late Meta meta;
  bool isLoading = false;
  String? errorMessage;
  String? _nextCursor;

  final ScrollController _scrollController = ScrollController();
  bool hasMore = true;

  final ProductService productService = ProductService();

  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    _loadProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (hasMore && !isLoading) {
          _loadProducts(query:{'cursor':'$_nextCursor'});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts({Map<String, String>? query}) async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
      if (query?['cursor'] == null) {
        errorMessage = null;
      }
    });
    try {
      final response = await productService.products(query: {'cursor':query?['cursor'] ?? ''});
      setState(() {
        if (query?['cursor'] == null) {
          products = response.data;
        } else {
          products = [...products, ...response.data];
        }
        meta = response.meta;
        _nextCursor = response.meta.nextCursor.isNotEmpty
            ? response.meta.nextCursor
            : null;
        hasMore = _nextCursor != null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Shoes\nCollection',
                  style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(28),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Chip(
                      shape: StadiumBorder(
                        side: BorderSide(color: Colors.grey.shade100),
                      ),
                      backgroundColor: selectedFilter == filter
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.grey.shade100,
                      labelStyle: TextStyle(fontSize: 16),
                      label: Text(filter),
                      padding: EdgeInsets.all(6),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            // Can use LayoutBuilder(widget) as well if you want parent height
            child: ListView.builder(
              controller: _scrollController,
              itemCount: products.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= products.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final product = products[index];
                final title = product.attributes.title;
                final price = product.attributes.price;
                final image = product.attributes.imageUrl;
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetailsPage(productId: product.id);
                        },
                      ),
                    );
                  },
                  child: ProductCard(title: title, price: price, image: image),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
