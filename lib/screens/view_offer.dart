import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:intl/intl.dart';

class ViewOffer extends StatefulWidget {
  final int offerId;
  ViewOffer({this.offerId});

  @override
  State<StatefulWidget> createState() {
    return _ViewOfferState();
  }
}

class _ViewOfferState extends State<ViewOffer> {
  final _offerService = OfferService();
  var euro = NumberFormat.currency(symbol: "€", locale: "de_DE");

  Widget buildBody(BuildContext context) {
    return FutureBuilder<Offer>(
      future: _offerService.fetchOffer(widget.offerId),
      builder: (BuildContext context, AsyncSnapshot<Offer> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator()
          );
        } else {
          if(snapshot.hasError) {
            return Align(
                alignment: Alignment.center,
                child: Text(snapshot.error.toString(), style: TextStyle(fontSize: 20))
            );
          } else {
            return Center(
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        snapshot.data.title,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        snapshot.data.compensationType == "Bar"
                            ? "Preis: " + euro.format(snapshot.data.price)
                            : snapshot.data.compensationType,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Kategorie: " + snapshot.data.category,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Bilder", style: TextStyle(fontSize: 25)),
                    ),
                  ),
                  ListView.builder(
                      itemCount: snapshot.data.pictures == null ? 0 : snapshot.data.pictures.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.memory(Base64Codec().decode(snapshot.data.pictures[index]))
                        );
                      }
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Beschreibung: " + snapshot.data.description,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  snapshot.data.sold == true
                      ? Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Leider schon verkauft",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Anbieter kontaktieren"),
                    ),
                  ),
                ],
              )
            );
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
          title: Text("Angebot"),
          centerTitle: true,
        ),
        body: buildBody(context),
    );
  }
}