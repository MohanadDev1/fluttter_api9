import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

// هذه هي الشاشة الرئيسية التي ستعرض قائمة المنتجات
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // دالة لجلب البيانات من الـ API
  Future<List<Product>> fetchProducts() async {
    // رابط الـ API
    final url = Uri.parse('https://fakestoreapi.com/products');

    // إرسال طلب GET
    final response = await http.get(url);

    // التحقق من نجاح الطلب (كود 200 يعني نجاح)
    if (response.statusCode == 200) {
      // تحويل النص (JSON) إلى قائمة
      List<dynamic> data = jsonDecode(response.body);

      // تحويل كل عنصر في القائمة إلى كائن Product
      List<Product> products = data
          .map((json) => Product.fromJson(json))
          .toList();

      return products;
    } else {
      // في حالة الفشل نُظهر خطأ واضح
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
      // استخدام FutureBuilder للتعامل مع البيانات التي تأخذ وقتاً للتحميل
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          // أثناء انتظار البيانات نعرض مؤشر تحميل
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // في حال حدوث خطأ أثناء الجلب
          else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          // في حال نجاح جلب البيانات ولم تكن فارغة
          else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Product> products = snapshot.data!;

            // عرض المنتجات في شبكة (مربعات) لتشبه المتاجر الإلكترونية
            return GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الأعمدة (منتجين في كل صف)
                childAspectRatio: 0.75, // نسبة العرض إلى الطول للبطاقة
                crossAxisSpacing: 10, // المسافة الأفقية بين المنتجات
                mainAxisSpacing: 10, // المسافة العمودية بين المنتجات
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return Card(
                  elevation: 3, // إضافة ظل خفيف للبطاقة
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // عرض صورة المنتج
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            product.image,
                            fit: BoxFit
                                .contain, // لجعل الصورة تناسب المربع بدون قص
                          ),
                        ),
                      ),
                      // النصوص (الاسم والسعر)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2, // السماح بسطرين للاسم
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
          // في حال كانت البيانات فارغة
          else {
            return Center(child: Text('لا توجد منتجات لعرضها.'));
          }
        },
      ),
    );
  }
}
