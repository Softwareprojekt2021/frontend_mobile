

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../models/offer.dart';
import '../services/offer_service.dart';
import '../util/notification.dart';

class EditOffer extends StatefulWidget {
  final Offer offer;
  EditOffer({this.offer});

  @override
  State<StatefulWidget> createState() {
    return _EditOffer();
  }
}

class _EditOffer extends State<EditOffer> {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final _offerService = OfferService();
  final priceFormat = new MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: '€');

  Offer _offer;
  bool _loading = false;
  int _showPrice;

  var _categories = <DropdownMenuItem>[];

  Future<void> _loadCategories() async {
    List<String> _fetchedCategories = await _offerService.fetchCategories();

    for (String category in _fetchedCategories) {
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category), value: category));
      });
    }
  }

  //TODO
  Future<void> _updateOffer() async {}

  //TODO
  Future<void> _deleteOffer() async {}

  //TODO
  Future<void> _setSold() async {}

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (_offer.pictures == null) {
          _offer.pictures = [];
        }

        _offer.pictures.add(File(pickedFile.path).path);
      });
    }
  }

  _removeImage(index) {
    setState(() {
      _offer.pictures.removeAt(index);
    });
  }

  Widget imageViewer(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
      child: GridView.builder(
        itemCount: _offer.pictures == null ? 1 : _offer.pictures.length + 1,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int index) {
          if (index == (_offer.pictures == null ? 0 : _offer.pictures.length)) {
            return Stack(
              children: [
                Positioned.fill(
                    child: IconButton(
                        icon: Icon(Icons.upload_rounded,
                            color: Colors.blue, size: 50),
                        onPressed: getImage
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("Bild hochladen")
                )
              ],
            );
          } else {
            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: _offer.pictures[index].substring(0, 4) == "http"
                          ? Image.network(
                          _offer.pictures[index],
                          fit: BoxFit.cover)
                          : Image.file(
                          File(_offer.pictures[index]),
                          fit: BoxFit.cover)),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.close,
                          color: Colors.blue),
                      onPressed: () {
                        _removeImage(index);
                      },
                    ))
              ],
            );
          }
        },
      ),
    );
  }

  @override
  initState() {
    super.initState();

    //Clone Object because Flutter would instead call by Reference
    _offer = widget.offer.clone();
    _showPrice = _offer.compensationType == "Bar" ? 1 : 0;

    if(_offer.price != null)
      priceFormat.updateValue(_offer.price);

    setState(() {
      _loading = true;
    });

    try {
      _loadCategories();
    } catch (error) {
      NotificationOverlay.error(error.toString());
      Navigator.pushNamed(context, "/createdOffers");
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
          appBar: AppBar(
            title: Text("Angebot erstellen"),
            centerTitle: true,
          ),
          body: Form(
            key: formKey,
            child: ListView(
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Titel",
                      icon: Icon(Icons.title),
                    ),
                    initialValue: _offer.title,
                    autocorrect: false,
                    validator: (value) => value.isEmpty ? "Titel darf nicht leer sein" : null,
                    onSaved: (value) => _offer.title = value,
                  ),
                ),
                Padding(
                    padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                      leading: Icon(Icons.image),
                      title: Text("Bilder"),
                    )
                ),
                imageViewer(context),
                Padding(
                    padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                      leading: Icon(Icons.assignment),
                      title: Text("Verkaufsart"),
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 60),
                  child: ListTile(
                    title: Text("Bar"),
                    leading: Radio(
                      value: 1,
                      onChanged: (value) {
                        setState(() {
                          _offer.compensationType = "Bar";
                          _showPrice = value;
                        });
                      },
                      groupValue: _showPrice,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 60),
                  child: ListTile(
                    title: Text("Tausch"),
                    leading: Radio(
                      value: 0,
                      onChanged: (value) {
                        setState(() {
                          _offer.compensationType = "Tausch";
                          _showPrice = value;
                          _offer.price = null;
                        });
                      },
                      groupValue: _showPrice,
                    ),
                  ),
                ),
                Visibility(
                  visible: _showPrice == 1 ? true : false,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Preis",
                          icon: Icon(Icons.euro)),
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      controller: priceFormat,
                      validator: (value) => priceFormat.numberValue < 0.01 ? "Preis muss mindestens 0,01€ sein" : null,
                      onSaved: (value) => _offer.price = priceFormat.numberValue,
                    ),
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Beschreibung",
                      icon: Icon(Icons.description),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autocorrect: false,
                    initialValue: _offer.description,
                    validator: (value) => value.isEmpty
                        ? "Beschreibung darf nicht leer sein"
                        : null,
                    onSaved: (value) => _offer.description = value,
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.category),
                      ),
                      items: _categories,
                      value: _offer.category,
                      hint: Text("Kategorie"),
                      validator: (value) => value == null
                          ? "Kategorie darf nicht leer sein"
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _offer.category = value;
                        });
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: _updateOffer,
                    child: Text("Änderungen speichern"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: _setSold,
                    child: Text("Als verkauft markieren"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: ElevatedButton(
                    onPressed: _deleteOffer,
                    child: Text("Angebot löschen"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}