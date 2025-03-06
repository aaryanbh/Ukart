import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_to_cart_page.dart';  // Import the AddToCartPage

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});

  // Factory constructor to create Product from JSON, with null safety
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['title'] ?? 'Unnamed Product',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // List to hold products fetched from the API
  List<Product> products = [];

  // List to hold items added to the cart
  List<Product> cart = [];

  // Flag for loading state
  bool isLoading = true;

  // Fetch products from the API
  Future<void> fetchProducts() async {
    const String apiUrl = 'https://fakestoreapi.com/products'; // Using Fake Store API

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> productJson = json.decode(response.body);

        setState(() {
          products = productJson.map((json) => Product.fromJson(json)).toList();
          isLoading = false;  // Set loading to false once data is fetched
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show an error message)
      print('Error fetching products: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();  // Fetch the products when the screen is loaded
  }

  // Method to add a product to the cart
  void _addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.greenAccent,
        actions: [
          // Cart Icon Button to view added items
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the AddToCartPage when the cart icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddToCartPage(cart: cart),  // Pass the cart to the AddToCartPage
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())  // Show loading spinner
            : GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,  // Aspect ratio for each item (adjust as needed)
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onAddToCart: _addToCart,
            );
          },
        ),
      ),
      // Add "Go to Cart" button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddToCartPage when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddToCartPage(cart: cart),
            ),
          );
        },
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onAddToCart;

  const ProductCard({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(  // Make the content of the card scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image with reduced height (adjusted from 150 to 120)
            Container(
              height: 120,  // Decreased height for the image
              width: double.infinity,  // Full width of the card
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,  // Ensures the image covers the container
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Truncate long text
                maxLines: 2, // Limit the text to 2 lines
              ),
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  onAddToCart(product); // Add the product to cart
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${product.name} added to cart!'),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // Background color
                ),
                child: Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
