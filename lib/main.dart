import 'package:flutter/material.dart';
import 'home_screen.dart';

// نقطة البداية للمشروع
void main() {
  runApp(MyApp());
}

// هذا الكلاس الأساسي للتطبيق
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // إخفاء علامة الـ debug من الزاوية
      title: 'Fetch Products API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // تحديد الشاشة الأولى التي ستظهر للمستخدم
      home: HomeScreen(),
    );
  }
}
