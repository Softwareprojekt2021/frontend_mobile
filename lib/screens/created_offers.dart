import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/offer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/side_bar.dart';
import '../models/offer.dart';
import '../services/offer_service.dart';
import '../util/notification.dart';

class CreatedOffers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatedOffers();
  }
}

class _CreatedOffers extends State<CreatedOffers> {
  final _offerService = OfferService();

  List<Offer> _offers;
  bool _loading = false;

  Future<void> _loadOffers() async {
    await _offerService.fetchCreatedOffers().then((result) {
      setState(() {
        _offers = result;
      });
    });
  }

  @override
  initState() {
    super.initState();

    setState(() {
      _loading = true;
    });

    try {
      _loadOffers();
    } catch (error) {
      NotificationOverlay.error(error.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          title: Text("Meine erstellten Angebote"),
          centerTitle: true,
        ),
        body:
          _offers == null ? ListTile(
              title: Text("Keine Angebote gefunden", style: TextStyle(fontSize: 20)),
              subtitle: Text("Klicke unten auf das Plus Zeichen, um eins zu erstellen."),
              leading: Icon(Icons.cancel)
            )
          : ListView.builder(
            itemCount: _offers.length,
            itemBuilder: (context, index) {
              return createOfferCard(context, _offers[index], index);
            }
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, "/createOffer"),
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}