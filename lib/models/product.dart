class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? categoryId,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}