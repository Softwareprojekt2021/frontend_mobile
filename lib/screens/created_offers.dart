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

  Widget buildBody(BuildContext context) {
    return FutureBuilder<List<Offer>>(
        future: _offerService.fetchCreatedOffers(),
        builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data == null || snapshot.data.length == 0) {
              return ListTile(
                  title: Text("Keine Angebote gefunden", style: TextStyle(fontSize: 20)),
                  subtitle: Text("Klicke unten auf das Plus Zeichen, um eins zu erstellen."),
                  leading: Icon(Icons.cancel)
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return createEditOfferCard(context, snapshot.data[index]);
                }
              );
            }
          } else {
             return Align(
                alignment: Alignment.center,
                child: snapshot.hasError ?
                Text(snapshot.error.toString(), style: TextStyle(fontSize: 20)) :
                CircularProgressIndicator()
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
          appBar: AppBar(
          title: Text("Meine erstellten Angebote"),
          centerTitle: true,
          ),
        body: buildBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, "/createOffer"),
          tooltip: 'Angebot erstellen',
          child: const Icon(Icons.add),
        ),
    );
  }
}