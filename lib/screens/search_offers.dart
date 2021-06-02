import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:frontend_mobile/components/offer.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:frontend_mobile/services/user_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchOffer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchOfferState();
  }
}

class _SearchOfferState extends State<SearchOffer> {
  final _offerService = OfferService();
  final _userService = UserService();

  var priceFormatBegin = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: '€');
  var priceFormatEnd = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: '€');
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _categories = <DropdownMenuItem>[];
  var _universities = <DropdownMenuItem>[];
  var _order = <DropdownMenuItem>[];
  int _showPrice;

  String _searchUniversity;
  String _searchText;
  String _searchCategory;
  String _searchOrder;
  double _searchPriceBegin;
  double _searchPriceEnd;

  TextEditingController _searchQueryController = TextEditingController();

  bool _loading = false;
  List<Offer> _offers;

  Future<void> _loadOffers() async {
    setState(() {
      _loading = true;
    });

    try {
      await _offerService.searchOffers(
          category: _searchCategory,
          text: _searchText,
          university: _searchUniversity,
          priceBegin: _searchPriceBegin,
          priceEnd: _searchPriceEnd).then((result) {
        setState(() {
          _offers = result;
        });
      });
    } catch (error) {
      NotificationOverlay.error(error.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }

    if(_searchOrder == "descPrice") {
      _offers.sort((a, b) => -a.price.compareTo(b.price));
    } else if (_searchOrder == "ascPrice") {
      _offers.sort((a, b) => a.price.compareTo(b.price));
    }
  }

  Future <void> _loadFilterData() async {
    setState(() {
      _loading = true;
    });

    _order.add(DropdownMenuItem(child: Text("Preis absteigend"), value: "descPrice"));
    _order.add(DropdownMenuItem(child: Text("Preis aufsteigend"), value: "ascPrice"));

    try {
      List<String> _fetchedUniversities = await _userService.fetchUniversities();
      List<String> _fetchedCategories = await _offerService.fetchCategories();

      for (String university in _fetchedUniversities) {
        setState(() {
          _universities.add(
              DropdownMenuItem(child: Text(university), value: university));
        });
      }

      for (String category in _fetchedCategories) {
        setState(() {
          _categories.add(
              DropdownMenuItem(child: Text(category), value: category));
        });
      }
    } catch (error) {

    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _filterDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Filter",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.category),
              ),
              items: _categories,
              value: _searchCategory,
              hint: Text("Kategorie"),
              onChanged: (value) {
                setState(() {
                  _searchCategory = value;
                });
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.apartment),
              ),
              items: _universities,
              hint: Text("Standort"),
              value: _searchUniversity,
              onChanged: (value) {
                setState(() {
                  _searchUniversity = value;
                });
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: Text(
              "Verkaufsart",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: ListTile(
              title: Text("Bar"),
              leading: Radio(
                value: 1,
                onChanged: (value) {
                  setState(() {
                    _showPrice = value;
                  });
                },
                groupValue: _showPrice,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: ListTile(
              title: Text("Tausch"),
              leading: Radio(
                value: 0,
                onChanged: (value) {
                  setState(() {
                    _showPrice = value;
                    _searchPriceBegin = null;
                    _searchPriceEnd = null;
                  });
                },
                groupValue: _showPrice,
              ),
            ),
          ),
          Visibility(
            visible: _showPrice == 1 ? true : false,
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "von Preis",
                    icon: Icon(Icons.euro)),
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: priceFormatBegin,
                onSaved: (value) => _searchPriceBegin = priceFormatBegin.numberValue,
              ),
            ),
          ),
          Visibility(
            visible: _showPrice == 1 ? true : false,
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "bis Preis",
                    icon: Icon(Icons.euro)),
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: priceFormatEnd,
                onSaved: (value) => _searchPriceEnd = priceFormatEnd.numberValue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.reorder),
              ),
              items: _order,
              value: _searchOrder,
              hint: Text("Sortieren nach"),
              onChanged: (value) {
                setState(() {
                  _searchOrder = value;
                });
              }),
          ),
        ],
      )
    );
  }

  Widget _searchField(BuildContext context) {
    return TextField(
      controller: _searchQueryController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Suche nach Text...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onSubmitted: (query) {
        setState(() {
          _searchText = query;
        });

        _loadOffers();
      },
    );
  }

  @override
  initState() {
    super.initState();
    _loadOffers();
    _loadFilterData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: _filterDrawer(context),
        appBar: AppBar(
          title: _searchField(context),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.filter_alt),
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
            ),
          ],
        ),
        body: ListView(
          children: [
            if(_loading == false)
              _offers == null ?
              ListTile(
                  title: Text("Keine Angebote gefunden", style: TextStyle(fontSize: 20)),
                  subtitle: Text("Es wurden keine Angebote gefunden oder der Server ist nicht erreichbar."),
                  leading: Icon(Icons.cancel)
              )
              :
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Gefundene Angebote',
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
        onEndDrawerChanged: (isOpen) {
          if(isOpen == false) {
            _loadOffers();
          }
        },
      ),
    );
  }
}
