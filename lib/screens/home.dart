import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/offer.dart';
import 'package:frontend_mobile/components/side_bar.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
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
            title: Text("Startseite"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
              ),
            ],
          ),
          body: Center(
            child: ListView.builder(
                itemCount: _offers == null ? 0 : _offers.length,
                itemBuilder: (context, index) {
                  return createOfferCard(context, _offers[index]);
                }
            ),
          ),
      )
    );
  }
}
