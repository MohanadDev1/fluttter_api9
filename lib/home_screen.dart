import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://fakestoreapi.com/products');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Product> products = data
          .map((json) => Product.fromJson(json))
          .toList();

      return products;
    } else {
      throw Exception('فشل في جلب المنتجات. كود الخطأ: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APIالمنتجات من الـ   (Exercise 3)'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Product> products = snapshot.data!;

            return GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, 
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10, 
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return Card(
                  elevation: 3, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            product.image,
                            fit: BoxFit
                                .contain, 
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          else {
            return Center(child: Text('لا توجد منتجات لعرضها.'));
          }
        },
      ),
    );
  }
}
