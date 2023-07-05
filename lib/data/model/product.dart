class Product {
  int? id;
  String? title;
  String? description;
  int? price;
  int? stock;
  String? thumbnail;
  bool isFavorite = false;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.stock,
      this.thumbnail});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['stock'] = stock;
    data['thumbnail'] = thumbnail;
    return data;
  }

  Product.fromMap(Map<String, dynamic> map)
      : this(
            id: map['id'],
            title: map['title'],
            description: map['description'],
            price: map['price'],
            stock: map['stock'],
            thumbnail: map['thumbnail']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'thumbnail': thumbnail
    };
  }
}
