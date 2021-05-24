import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/services/offer_service.dart';
import 'package:frontend_mobile/util/notification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CreateOffer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateOffer();
  }
}

class _CreateOffer extends State<CreateOffer> {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final _offerService = OfferService();

  Offer _offer = new Offer();
  bool _loading = false;
  int _showPrice = 1;

  var _categories = <DropdownMenuItem>[];
  var priceFormat = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: '€');
  var _textControllerTitle = TextEditingController();
  var _textControllerDescription = TextEditingController();

  Future<void> _loadCategories() async {
    List<String> _fetchedCategories = await _offerService.fetchCategories();

    for (String category in _fetchedCategories) {
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category), value: category));
      });
    }
  }

  Future<void> _createOffer() async {
    var form = formKey.currentState;

    //Closes Keyboard
    FocusScope.of(context).unfocus();

    if (form.validate()) {
      form.save();

      setState(() {
        _loading = true;

        if(_showPrice == 1) {
          _offer.compensationType = "Bar";
        } else {
          _offer.compensationType = "Tausch";
        }

        _offer.price = priceFormat.numberValue;
        _offer.title = _textControllerTitle.text;
        _offer.description = _textControllerDescription.text;
      });

      try {
        await _offerService.createOffer(_offer);

        setState(() {
          _loading = false;
        });

        Navigator.pushNamed(context, "/createdOffers");
        NotificationOverlay.success("Angebot wurde erstellt");
      } catch (error) {
        setState(() {
          _loading = false;
        });

        NotificationOverlay.error(error.toString());
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (_offer.pictures == null) {
          _offer.pictures = [];
        }

        final bytes = File(pickedFile.path).readAsBytesSync();
        _offer.pictures.add(base64Encode(bytes));
      });
    }
  }

  _removeImage(index) {
    setState(() {
      _offer.pictures.removeAt(index);
    });
  }

  @override
  initState() {
    super.initState();

    setState(() {
      _loading = true;
    });

    try {
      _loadCategories();
    } catch (error) {
      NotificationOverlay.error(error.toString());
      Navigator.pushNamed(context, "/home");
    } finally {
      setState(() {
        _loading = false;
      });
    }
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
                      child: Image.memory(
                          Base64Codec().decode(_offer.pictures[index]),
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
                    autocorrect: false,
                    controller: _textControllerTitle,
                    validator: (value) =>
                      value.isEmpty ? "Titel darf nicht leer sein" : null,
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
                    controller: _textControllerDescription,
                    validator: (value) => value.isEmpty
                        ? "Beschreibung darf nicht leer sein"
                        : null,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 50, right: 60),
                  child: DropdownButtonFormField(
                      value: _offer.category,
                      decoration: InputDecoration(
                        icon: Icon(Icons.category),
                      ),
                      items: _categories,
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
                    onPressed: _createOffer,
                    child: Text("Angebot erstellen"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
