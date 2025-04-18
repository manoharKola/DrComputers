import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class Product {
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final List<dynamic> dynamicFields;

  Product({
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.dynamicFields,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? 'Others',
      dynamicFields: json['dynamic_fields'] ?? [],
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String sortOption = 'None';
  String selectedCategory = 'All';
  List<String> categories = ['All'];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/manoharKola/DrComputers/refs/heads/main/products%20(1).json'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        products = jsonData.map((e) => Product.fromJson(e)).toList();
        categories = ['All', ...products.map((p) => p.category).toSet().toList()];
        applyFilters();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void applyFilters() {
    List<Product> updated = [...products];

    if (selectedCategory != 'All') {
      updated = updated.where((p) => p.category == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      updated = updated.where((p) =>
      p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    if (sortOption == 'Price: Low to High') {
      updated.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == 'Price: High to Low') {
      updated.sort((a, b) => b.price.compareTo(a.price));
    }

    setState(() {
      filteredProducts = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width < 800
        ? (MediaQuery.of(context).size.width / 200).floor()
        : (MediaQuery.of(context).size.width / 300).floor();

    return Scaffold(
        backgroundColor: const Color(0xFFEAE9E9),
    appBar: AppBar(
    title: const Text(
    'Product List',
    // style: TextStyle(color: Colors.white),
    ),
    // backgroundColor: Colors.red,
    elevation: 4,
    // iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                searchQuery = val;
                applyFilters();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black, width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: sortOption,
                      items: ['None', 'Price: Low to High', 'Price: High to Low']
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (val) {
                        sortOption = val!;
                        applyFilters();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.black, width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      items: categories
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (val) {
                        selectedCategory = val!;
                        applyFilters();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () => context.go('/product/${Uri.encodeComponent(product.title)}'),
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: MediaQuery.of(context).size.width < 800 ? 6 : 8,
                          child: ImageSlideshow(
                            indicatorColor: Colors.blue,
                            indicatorBackgroundColor: Colors.grey,
                            autoPlayInterval: 0,
                            isLoop: true,
                            children: product.images
                                .map((img) => Image.network(
                              "https://i38utvd5exkamac5ywqnda.on.drv.tw/www.drcomputers.com/upload/$img",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                            ))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          flex: MediaQuery.of(context).size.width < 800 ? 4 : 2,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text("₹${product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(color: Colors.green)),
                                const SizedBox(height: 2),
                                Text(product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final String? productTitle;

  const ProductDetailPage({super.key, this.product, this.productTitle});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _product = widget.product;
    } else if (widget.productTitle != null) {
      _fetchProduct(widget.productTitle!);
    }
  }

  Future<void> _fetchProduct(String title) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/manoharKola/DrComputers/refs/heads/main/products%20(1).json'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final products = jsonData.map((e) => Product.fromJson(e)).toList();
        final product = products.firstWhere(
              (p) => p.title == Uri.decodeComponent(title),
          orElse: () => Product(
            title: 'Not Found',
            description: '',
            price: 0,
            images: [],
            category: '',
            dynamicFields: [],
          ),
        );
        setState(() => _product = product);
      }
    } catch (e) {
      // handle error
    }
    setState(() => _isLoading = false);
  }

  void showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    if (_isLoading || _product == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final imageSlideshow = ImageSlideshow(
      height: isWide ? 400 : 250,
      indicatorColor: Colors.blue,
      indicatorBackgroundColor: Colors.grey,
      isLoop: true,
      children: _product!.images
          .map((img) => GestureDetector(
        onTap: () => showFullImage(
          context,
          "https://i38utvd5exkamac5ywqnda.on.drv.tw/www.drcomputers.com/upload/$img",
        ),
        child: Image.network(
          "https://i38utvd5exkamac5ywqnda.on.drv.tw/www.drcomputers.com/upload/$img",
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
        ),
      ))
          .toList(),
    );

    final detailsSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_product!.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("₹${_product!.price.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 20, color: Colors.green)),
        const SizedBox(height: 10),
        Text(_product!.description,
            style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 16),
        const Text('Specifications:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._product!.dynamicFields.map((field) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text("${field['name']}: ${field['value']}",
              style: const TextStyle(fontSize: 16)),
        )),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(_product!.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isWide
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: imageSlideshow),
            const SizedBox(width: 20),
            Expanded(child: detailsSection),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageSlideshow,
            const SizedBox(height: 20),
            detailsSection,
          ],
        ),
      ),
    );
  }
}
