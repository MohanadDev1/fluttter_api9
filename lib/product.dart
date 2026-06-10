// هذا الملف يحتوي على نموذج (Model) المنتج
// تم إنشاؤه لترتيب البيانات القادمة من الـ API وتسهيل استخدامها في التطبيق

class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  // دالة لتحويل بيانات JSON القادمة من الإنترنت إلى كائن Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      // تحويل السعر إلى double لأن بعض القيم قد تكون int في الـ JSON
      price: json['price'].toDouble(),
      image: json['image'],
      description: json['description'],
      category: json['category'],
    );
  }
}
