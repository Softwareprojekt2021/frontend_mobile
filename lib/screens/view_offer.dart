import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ViewOffer extends StatefulWidget {
  final Offer offer;
  ViewOffer({this.offer});

  @override
  State<StatefulWidget> createState() {
    return _ViewOfferState();
  }
}

class _ViewOfferState extends State<ViewOffer> {
  var euro = NumberFormat.currency(symbol: "€", locale: "de_DE");

  bool _loading = false;
  Offer _offer;

  @override
  initState() {
    super.initState();

    _offer = widget.offer;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _loading,
        child: Scaffold(
          appBar: AppBar(
          title: Text("Angebot"),
          centerTitle: true,
        ),
        body: Center(
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _offer.title,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _offer.compensationType == "Bar"
                        ? "Preis: " + euro.format(_offer.price)
                        : _offer.compensationType,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Kategorie: " + _offer.category,
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
                  itemCount: _offer.pictures == null ? 0 : _offer.pictures.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.memory(Base64Codec().decode(_offer.pictures[index]))
                    );
                  }
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Beschreibung: " + _offer.description,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              _offer.sold == true
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
        ),
      ),
    );
  }
}