class Offer {
  int id;
  bool sold;
  double price;
  String title, compensationType, description, category;
  List<String> pictures;

  Offer({this.id, this.title, this.description, this.compensationType, this.category, this.price, this.sold, this.pictures});

  Offer.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        title = json['title'],
        description = json['description'],
        compensationType = json['compensation_type'],
        category = json['category'],
        price = json['price'] == "None" ? null : double.parse(json['price']),
        sold = json['sold'],
        pictures = List<String>.from(json['pictures']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'compensation_type': compensationType,
    'category': category,
    'price': price,
    'sold': sold == true ? 1 : 0,
    'pictures': pictures
  };

  Offer clone() => Offer(
      id: id,
      title: title,
      description: description,
      compensationType: compensationType,
      category: category,
      price: price,
      sold: sold,
      pictures: pictures != null
          ? new List<String>.from(pictures)
          : null);
}