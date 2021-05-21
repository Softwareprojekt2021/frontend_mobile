import 'package:frontend_mobile/models/offer.dart';

//TODO Get Data from Backend
class OfferService {
  fetchCategories() async {
    //Mockup
    return ["Elektronik", "Computer", "Buch", "Sonstiges"];
  }

  createOffer(Offer offer) async {
    return;
  }

  offerSold(int offerId) async {

  }

  deleteOffer(int offerId) async {

  }

  updateOffer(Offer offer) async {

  }

  fetchCreatedOffers() async {
    //Mockup
    return [
      Offer(id: 0, title: "Test 1 (Ohne Bilder)", description: "Test Angebot", compensationType: "Bar", category: "Elektronik", price: 14.99, sold: 0),
      Offer(id: 1, title: "Test 2 (1 Bild)", description: "Test Angebot", compensationType: "Tausch", category: "Elektronik", sold: 0,
          pictures: ["https://cdn.prod.www.spiegel.de/images/d1f0d7fc-99e9-45a9-939b-5abc7a8ee11d_w718_r1.77_fpx45.75_fpy50.jpg"]),
      Offer(id: 2, title: "Test 3 (Mehrere Bilder)", description: "Test Angebot", compensationType: "Bar", category: "Elektronik", price: 14.99, sold: 0,
          pictures: [
            "https://cdn.prod.www.spiegel.de/images/d1f0d7fc-99e9-45a9-939b-5abc7a8ee11d_w718_r1.77_fpx45.75_fpy50.jpg",
            "https://ais.badische-zeitung.de/piece/0b/00/fd/92/184614290-h-720.jpg",
            "https://img.br.de/c73cabf1-ea20-4cbe-8137-1c9d7a7f2a57.jpeg?q=80&rect=327,200,847,477&w=1600&h=900",
            "https://www.wwf-junior.de/fileadmin/_processed_/4/0/csm_Original_WW1113726_webklein_d3a208de5f.jpg",
            "https://veganworld.de/wp-content/uploads/pexels-photo-802112-e1523269735680.jpeg"
          ]),
    ];
  }
}