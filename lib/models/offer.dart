//TODO Check json fields if login backend has been implemented
class Offer {
  int id, sold;
  double price;
  String title, compensationType, description, category;
  List<String> pictures;

  Offer({this.id, this.title, this.description, this.compensationType, this.category, this.price, this.sold, this.pictures});

  Offer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['decscription'],
        compensationType = json['compensation_type'],
        category = json['category'],
        price = json['price'],
        sold = json['sold'],
        pictures = json['pictures'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'compensation_type': compensationType,
    'category': category,
    'price': price,
    'sold': sold,
    'pictures': pictures
  };

  Offer clone() => Offer(id: id, title: title, description: description, compensationType: compensationType, category: category, price: price, sold: sold, pictures: pictures);
}