import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/offer.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/screens/search_offers.dart';
import 'package:frontend_mobile/services/offer_service.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final _offerService = OfferService();

  Widget buildBody(BuildContext context) {
    return FutureBuilder<List<Offer>>(
        future: _offerService.fetchRecommendedOffers(),
        builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null || snapshot.data.length == 0) {
              return Align(
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("Keine Angebote gefunden",
                      style: TextStyle(fontSize: 20)),
                  leading: Icon(Icons.cancel))
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return createOfferCard(context, snapshot.data[index]);
                  });
            }
          } else {
            return Align(
                alignment: Alignment.center,
                child: snapshot.hasError
                    ? Text(snapshot.error.toString(),
                        style: TextStyle(fontSize: 20))
                    : CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text("Startseite"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchOffer()));
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        body: buildBody(context));
  }
}