import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:frontend_mobile/components/offer.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:frontend_mobile/services/user_service.dart';

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
  var _order = <DropdownMenuItem>[];

  Map _search = new Map();

  TextEditingController _searchQueryController = TextEditingController();

  Widget buildDropdownCategory(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _offerService.fetchCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if(snapshot.hasData) {
          var list = <DropdownMenuItem>[];

          for(String category in snapshot.data) {
            list.add(DropdownMenuItem(child: Text(category), value: category));
          }

          return DropdownButtonFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.category),
              labelText: "Kategorie"
            ),
            items: list,
            value: _search["category"],
            onChanged: (value) {
              setState(() {
                _search["category"] = value;
              });
            });
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

  Widget buildDropdownUniversity(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _userService.fetchUniversities(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if(snapshot.hasData) {
            var list = <DropdownMenuItem>[];

            for(String university in snapshot.data) {
              list.add(DropdownMenuItem(child: Text(university), value: university));
            }

            return DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.apartment),
                labelText: "Standort"
              ),
              items: list,
              value: _search["university"],
              onChanged: (value) {
                setState(() {
                  _search["university"] = value;
                });
              });
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

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.filter_alt, size: 30),
                Text(
                  "Filter",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: buildDropdownCategory(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: buildDropdownUniversity(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5, left: 16, right: 16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(Icons.attach_money, color: Colors.grey, size: 25),
                ),
                Text(
                  "Verkaufsart",
                  style: TextStyle(fontSize: 16, color: Colors.black45),
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: ListTile(
              title: Text("Bar"),
              leading: Radio(
                value: 1,
                onChanged: (value) {
                  setState(() {
                    _search["type"] = value;
                  });
                },
                groupValue: _search["type"],
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
                    _search["type"] = value;
                    _search["priceEnd"] = null;
                    _search["priceBegin"] = null;
                  });
                },
                groupValue: _search["type"],
              ),
            ),
          ),
          Visibility(
            visible: _search["type"] == 1 ? true : false,
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "von Preis",
                    icon: Icon(Icons.euro)),
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: priceFormatBegin,
                onSaved: (value) => _search["priceBegin"] = priceFormatBegin.numberValue,
              ),
            ),
          ),
          Visibility(
            visible: _search["type"] == 1 ? true : false,
            child: Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "bis Preis",
                    icon: Icon(Icons.euro)),
                autocorrect: false,
                keyboardType: TextInputType.number,
                controller: priceFormatEnd,
                onSaved: (value) => _search["priceEnd"] = priceFormatEnd.numberValue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.reorder),
                labelText: "Sortieren nach"
              ),
              items: _order,
              value: _search["order"],
              onChanged: (value) {
                setState(() {
                  _search["order"] = value;
                });
              }),
          ),
        ],
      )
    );
  }

  Widget buildSearchField(BuildContext context) {
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
          _search["text"] = query;
        });
      },
    );
  }

  Widget buildBody(BuildContext context, Map search) {
    return FutureBuilder<List<Offer>>(
      future: _offerService.searchOffers(search),
      builder: (BuildContext context, AsyncSnapshot<List<Offer>> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data == null || snapshot.data.length == 0) {
            return ListTile(
              title: Text("Keine Angebote gefunden", style: TextStyle(fontSize: 20)),
              subtitle: Text("Es wurden keine Angebote gefunden oder der Server ist nicht erreichbar."),
              leading: Icon(Icons.cancel)
            );
          } else {

            if(_search["order"] == "descPrice") {
              snapshot.data.sort((a, b) => -a.price.compareTo(b.price));
            } else if (_search["order"] == "ascPrice") {
              snapshot.data.sort((a, b) => a.price.compareTo(b.price));
            }

            return ListView(
              children: [
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
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return createOfferCard(context, snapshot.data[index]);
                  }
                ),
              ],
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
  void initState() {
    super.initState();

    setState(() {
      _order.add(DropdownMenuItem(child: Text("Preis absteigend"), value: "descPrice"));
      _order.add(DropdownMenuItem(child: Text("Preis aufsteigend"), value: "ascPrice"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: buildDrawer(context),
      appBar: AppBar(
        title: buildSearchField(context),
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
      body: buildBody(context, _search)
    );
  }
}