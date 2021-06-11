import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/offer.dart';

import '../components/side_bar.dart';
import '../models/offer.dart';
import '../services/offer_service.dart';

class CreatedOffers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatedOffers();
  }
}

class _CreatedOffers extends State<CreatedOffers> {
  final _offerService = OfferService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Offer>>(
      future: _offerService.fetchCreatedOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
        if(snapshot.hasData) {
          return Scaffold(
            drawer: SideBar(),
            appBar: AppBar(
              title: Text("Meine erstellten Angebote"),
              centerTitle: true,
            ),
            body: snapshot.data == null || snapshot.data.length == 0 ?
            ListTile(
                title: Text("Keine Angebote gefunden", style: TextStyle(fontSize: 20)),
                subtitle: Text("Klicke unten auf das Plus Zeichen, um eins zu erstellen."),
                leading: Icon(Icons.cancel)
            )
            : ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return createEditOfferCard(context, snapshot.data[index]);
                }
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, "/createOffer"),
              tooltip: 'Angebot erstellen',
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return Scaffold(
            drawer: SideBar(),
            appBar: AppBar(
              title: Text("Meine erstellten Angebote"),
              centerTitle: true,
            ),
            body: Align(
                alignment: Alignment.center,
                child: snapshot.hasError ?
                Text(snapshot.error.toString(), style: TextStyle(fontSize: 20)) :
                CircularProgressIndicator()
            )
          );
        }
      }
    );
  }
}