import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/offer.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/screens/search_offers.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:frontend_mobile/util/notification.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final _offerService = OfferService();

  List<Offer> _offers;

  Future<void> _loadOffers() async {
    try {
      await _offerService.fetchRecommendedOffers().then((result) {
        setState(() {
          _offers = result;
        });
      });
    } catch (error) {
      NotificationOverlay.error(error.toString());

    }
  }

  @override
  initState() {
    super.initState();
    _loadOffers();
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchOffer()
                        )
                    );
                  },
                  icon: Icon(Icons.search),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _loadOffers,
            child: ListView(
              children: [
                _offers == null ?
                ListTile(
                    title: Text("Keine Angebote gefunden", style: TextStyle(fontSize: 20)),
                    subtitle: Text("Es konnte keine Verbindung zum Server hergestellt werden."),
                    leading: Icon(Icons.cancel)
                )
                :
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Empfohlene Angebote',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: _offers == null ? 0 : _offers.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return createOfferCard(context, _offers[index]);
                    }
                ),
              ],
            ),
          ),
      );
  }
}
