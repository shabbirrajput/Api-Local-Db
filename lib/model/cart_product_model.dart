class CartProductModel {
  int? cartId;
  int? cartUserId;
  String? cartDate;
  List<CartProducts>? cartProducts;
  int? id;
  String? title;
  dynamic price;
  String? description;
  String? image;

  CartProductModel(
      {this.cartId,
      this.cartUserId,
      this.cartDate,
      this.cartProducts,
      this.id,
      this.title,
      this.price,
      this.description,
      this.image});

  CartProductModel.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    cartUserId = json['cartUserId'];
    cartDate = json['cartDate'];
    if (json['cartProducts'] != null) {
      cartProducts = <CartProducts>[];
      json['cartProducts'].forEach((v) {
        cartProducts!.add(CartProducts.fromJson(v));
      });
    }
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartId'] = cartId;
    data['cartUserId'] = cartUserId;
    data['cartDate'] = cartDate;
    if (cartProducts != null) {
      data['cartProducts'] = cartProducts!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}

class CartProducts {
  int? productId;
  int? quantity;

  CartProducts({this.productId, this.quantity});

  CartProducts.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['quantity'] = quantity;
    return data;
  }
}
