import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_catalog/models/product.dart';
import 'package:product_catalog/services/product_api_service.dart';

import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductApiService _productApiService = ProductApiService();
  final TextEditingController _searchController = TextEditingController();
  final List<Product> _products = [];
  int _skip = 0;
  bool _isLoading = false;
  Timer? _debounce;
  String? _errorMessage;
  String? _currentSearchQuery;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await _productApiService.fetchProducts(_skip);

      setState(() {
        _products.addAll(products);
        _skip += products.length;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products';
      });

      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        setState(() {
          _products.clear();
          _skip = 0;
          _currentSearchQuery = null;
        });
        _fetchProducts();
        return;
      }

      _searchProducts(query.trim());
    });
  }

  Future<void> _searchProducts(String query) async {
    _currentSearchQuery = query;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await _productApiService.searchProducts(query);

      setState(() {
        _products
          ..clear()
          ..addAll(products);
      });
    } catch (e) {
      setState(() {
        _products.clear();
        _errorMessage = 'Failed to search products';
      });

      if (kDebugMode) {
        print('Error searching products: $e');
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: _errorMessage != null && _products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_errorMessage!),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (_currentSearchQuery != null) {
                                _searchProducts(_currentSearchQuery!);
                              } else {
                                _fetchProducts();
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _products.isEmpty && !_isLoading
                      ? const Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : NotificationListener<ScrollNotification>(
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
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final product = _products[index];
                              return ListTile(
                                leading: Image.network(product.thumbnail),
                                title: Text(product.title),
                                subtitle: Text('\$${product.price}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                          productId: product.id),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
            ),
          ],
        ));
  }
}
