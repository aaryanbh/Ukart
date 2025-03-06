import 'package:flutter/material.dart';
import 'dashboard.dart';  // Import the Dashboard file for the Product model

class AddToCartPage extends StatelessWidget {
  final List<Product> cart;  // The list of products passed from Dashboard

  const AddToCartPage({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = cart.fold(0.0, (sum, product) => sum + product.price);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Colors.greenAccent,
      ),
      body: cart.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final product = cart[index];
                  return ListTile(
                    leading: Image.network(product.imageUrl, width: 50),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total: \$${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement checkout functionality if needed
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Checkout"),
                    content: Text("Proceed to checkout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Checkout action here
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Proceed to checkout action here
                        },
                        child: Text("Proceed"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Checkout"),
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.greenAccent, // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
