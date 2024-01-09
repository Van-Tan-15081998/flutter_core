import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}



class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
      // Các cài đặt khác của MaterialApp
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Sử dụng dữ liệu từ Providers
    // Ví dụ: userProvider.currentUser và productProvider.products

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        // Hiển thị dữ liệu từ Providers
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
        child: Text('User Name: ${userProvider.currentUser?.name ?? "No user"}'),
      ),
    );
  }
}

class EditUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Cập nhật dữ liệu trong UserProvider
            userProvider.setCurrentUser(User(id: '1', name: 'New Name'));
          },
          child: Text('Change User Name'),
        ),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) => Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: ListView.builder(
          itemCount: productProvider.products.length,
          itemBuilder: (context, index) {
            final product = productProvider.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            );
          },
        ),
      ),
    );
  }
}
