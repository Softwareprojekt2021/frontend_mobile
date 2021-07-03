import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/chat_service.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:frontend_mobile/services/store_service.dart';
import 'package:frontend_mobile/services/watchlist_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat.dart';

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
  final _chatService = ChatService();
  var euro = NumberFormat.currency(symbol: "€", locale: "de_DE");
  bool _inAsyncCall = false;
  Future myFuture;

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
        if(offer != null
            && offer.sold == false
            && StoreService.store.state.user != null
            && StoreService.store.state.user.id != offer.user.id)
        IconButton(
          icon: Icon(Icons.bookmark),
          onPressed: () {
            _addBookmarkDialog(offer.id);
          }
        ),
        if(offer != null
            && offer.sold == false
            && StoreService.store.state.user != null
            && StoreService.store.state.user.id != offer.user.id)
        IconButton(
          icon: Icon(Icons.message),
          onPressed: () async {
            setState(() {
              _inAsyncCall = true;
            });

            try {
              int chatId = await _chatService.createChat(offer.id);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chatId)
                  )
              );
            } catch (error) {
              NotificationOverlay.error(error.toString());
            } finally {
              setState(() {
                _inAsyncCall = false;
              });
            }
          }
        ),
      ],
    );
  }

  List<Widget> buildRating(BuildContext context, double rating) {
    List<Widget> widgets = <Widget>[];
    double missing = 5 - rating;

    if(rating == 0) {
      widgets.add(Text("Keine", style: TextStyle(fontSize: 18)));

      return widgets;
    }

    for(int index = 0; index < rating.ceil(); index++) {
      if(index + 1 > rating && rating % rating.floor() >= 0.5) {
        widgets.add(Icon(Icons.star_half));
      } else {
        widgets.add(Icon(Icons.star));
      }
    }

    for(int index = 0; index < missing.floor(); index++) {
      widgets.add(Icon(Icons.star_border));
    }

    return widgets;
  }

  Widget buildOffer(BuildContext context) {
    return FutureBuilder<Offer>(
      future: myFuture,
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
                            "Achtung: Das Angebot wurde verkauft!",
                            style: TextStyle(fontSize: 25, color: Colors.deepOrangeAccent),
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
                    if(snapshot.data.pictures != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bilder",
                          style: TextStyle(fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.image),
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Informationen",
                          style: TextStyle(fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(Icons.info_rounded),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          snapshot.data.compensationType == "Bar"
                              ? "Preis: " + euro.format(snapshot.data.price)
                              : "Art: " + snapshot.data.compensationType,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Standort: " + snapshot.data.user.university,
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
                                    "Name: " + snapshot.data.user.firstName + " " + snapshot.data.user.lastName,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "Bewertung:",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                ...buildRating(context, snapshot.data.user.rating)
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
  void initState() {
    super.initState();
    myFuture = _offerService.fetchOffer(widget.offerId);
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