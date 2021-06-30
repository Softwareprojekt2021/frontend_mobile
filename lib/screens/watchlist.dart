import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/offer.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/screens/view_offer.dart';
import 'package:frontend_mobile/services/watchlist_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Watchlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WatchlistState();
  }
}

class _WatchlistState extends State<Watchlist> {
  final _watchlistService = WatchlistService();
  bool _inAsyncCall = false;

  void _showDeleteDialog(Offer offer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Angebot von der Watchlist entfernen?"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.pop(context, true);

                setState(() {
                  _inAsyncCall = true;
                });

                try {
                  await _watchlistService.deleteOffer(offer.id);

                  NotificationOverlay.success("Angebot entfernt");
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

  Widget createWatchlistCard(BuildContext context, Offer offer) {
    return Card(
        child: Column(
          children: [
            ListTile(
                title: Text(offer.title, style: TextStyle(fontSize: 20)),
                subtitle: offer.compensationType == "Bar"
                    ? Text("Preis: " + euro.format(offer.price), style: TextStyle(fontSize: 16))
                    : Text(offer.compensationType, style: TextStyle(fontSize: 16)),
                leading: Icon(Icons.local_offer),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.blue),
                      onPressed: () {
                        _showDeleteDialog(offer);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewOffer(offerId: offer.id)
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            Image.memory(Base64Codec().decode(offer.pictures[0])),
          ],
        )
    );
  }

  Widget buildBody(BuildContext context) {
    return FutureBuilder<List<Offer>>(
      future: _watchlistService.fetchOffers(),
      builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Align(
                alignment: Alignment.center,
                child: ListTile(
                    title: Text("Du hast keine Angebote in deiner Watchlist",
                        style: TextStyle(fontSize: 20)),
                    leading: Icon(Icons.cancel))
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return createWatchlistCard(context, snapshot.data[index]);
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
    return ModalProgressHUD(
      inAsyncCall: _inAsyncCall,
      child: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text("Watchlist"),
          centerTitle: true,
        ),
        body: buildBody(context)
      ),
    );
  }
}