import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_catalog/models/product.dart';
import 'package:product_catalog/services/product_api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductApiService _productApiService = ProductApiService();
  final List<Product> _products = [];
  int _skip = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final products = await _productApiService.fetchProducts(_skip);
      setState(() {
        _products.addAll(products);
        _skip += products.length;
      });
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
            _fetchProducts();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _products.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _products.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final product = _products[index];
            return ListTile(
              leading: Image.network(product.thumbnail),
              title: Text(product.title),
              subtitle: Text('\$${product.price}'),
            );
          },
        ),
      ),
    );
  }
}
