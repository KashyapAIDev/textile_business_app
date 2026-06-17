class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final List<String> images;
  final String category;

  // Textile details
  final String fabricType;
  final String pattern;
  final String width;
  final int gsm;
  final String color;
  final String minOrderQty;

  // Stats & Status
  final double rating;
  final int reviewsCount;
  final bool isAvailable;
  final int stockQuantity;
  final String stockStatus; // e.g. "In Stock", "Low Stock", "Out of Stock"

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    required this.images,
    required this.category,
    required this.fabricType,
    required this.pattern,
    required this.width,
    required this.gsm,
    required this.color,
    required this.minOrderQty,
    this.rating = 4.5,
    this.reviewsCount = 12,
    this.isAvailable = true,
    this.stockQuantity = 100,
    required this.stockStatus,
  });

  // Helper to check if product has discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  // Helper to calculate discount percentage
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((price - discountPrice!) / price) * 100).round();
  }
}
