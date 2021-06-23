import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:frontend_mobile/services/watchlist_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  final _watchlistService = WatchlistService();
  var euro = NumberFormat.currency(symbol: "€", locale: "de_DE");
  bool _inAsyncCall = false;

  void _addBookmarkDialog(int offerId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Angebot zur Watchlist hinzufügen?"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () async {
                  Navigator.pop(context, true);

                  setState(() {
                    _inAsyncCall = true;
                  });

                  try {
                    await _watchlistService.addOffer(offerId);
                    NotificationOverlay.success("Angebot gespeichert");
                  } catch (error) {
                    NotificationOverlay.error(error.toString());
                  } finally {
                    setState(() {
                      _inAsyncCall = false;
                    });
                  }
                },
              ),
              TextButton(
                child: Text("Abbrechen"),
                onPressed: () => Navigator.pop(context, false),
              )
            ],
          );
        }
    );
  }

  Widget buildBar(BuildContext context, Offer offer) {
    return AppBar(
      title: Text("Angebot"),
      centerTitle: true,
      actions: [
        if(offer != null && offer.sold == false)
        IconButton(
          icon: Icon(Icons.bookmark),
          onPressed: () {
            _addBookmarkDialog(offer.id);
          }
        ),
        if(offer != null && offer.sold == false)
        IconButton(
          icon: Icon(Icons.message),
          onPressed: () {

          }
        ),
      ],
    );
  }

  Widget buildOffer(BuildContext context) {
    return FutureBuilder<Offer>(
      future: _offerService.fetchOffer(widget.offerId),
      builder: (BuildContext context, AsyncSnapshot<Offer> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: buildBar(context, snapshot.data),
            body: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator()
            ),
          );
        } else {
          if(snapshot.hasError) {
            return Scaffold(
              appBar: buildBar(context, snapshot.data),
              body: Align(
                alignment: Alignment.center,
                child: Text(snapshot.error.toString(), style: TextStyle(fontSize: 20))
              )
            );
          } else {
            return Scaffold(
              appBar: buildBar(context, snapshot.data),
              body: Center(
                child: ListView(
                  children: [
                    if(snapshot.data.sold == true)
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Achtung: Das Angebot wurde schon verkauft!",
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
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
                    if(snapshot.data.pictures != null && snapshot.data.pictures.length > 0)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return DetailScreen(image: snapshot.data.pictures[0]);
                            }));
                          },
                          child: Image.memory(
                              Base64Codec().decode(snapshot.data.pictures[0])
                          ),
                        ),
                      ),
                    if(snapshot.data.pictures != null && snapshot.data.pictures.length > 1)
                      GridView.builder(
                          itemCount: snapshot.data.pictures == null ? 0 : snapshot.data.pictures.length - 1,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                      return DetailScreen(image: snapshot.data.pictures[index + 1]);
                                    }));
                                  },
                                  child: Image.memory(
                                      Base64Codec().decode(snapshot.data.pictures[index + 1])
                                  ),
                                ),
                            );
                          }
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
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Beschreibung: " + snapshot.data.description,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Anbieter",
                                  style: TextStyle(fontSize: 22),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Icon(Icons.person),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  child: Text(
                                    snapshot.data.user.firstName + " " + snapshot.data.user.lastName,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "Bewertung",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Icon(Icons.star),
                                Icon(Icons.star),
                                Icon(Icons.star),
                                Icon(Icons.star),
                                Icon(Icons.star_half),
                              ],
                            )
                          ],
                        )
                      ),
                    ),
                  ],
                )
              )
            );
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _inAsyncCall,
      child: buildOffer(context),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String image;
  DetailScreen({this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bild"),
        centerTitle: true,
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.memory(
                Base64Codec().decode(image)
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}