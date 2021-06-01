
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile/models/offer.dart';
import 'package:frontend_mobile/screens/edit_offer.dart';
import 'package:intl/intl.dart';

var euro = NumberFormat.currency(symbol: "€", locale: "de_DE");

Widget createOfferCard(BuildContext context, Offer offer, int index) {
  return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(offer.title),
            leading: offer.pictures == null
                ? CircleAvatar(
                child: Icon(
                    Icons.image
                )
            )
                : CircleAvatar(
              backgroundImage: Image.memory(
                  Base64Codec().decode(offer.pictures[0])).image,
            ),
            subtitle: offer.compensationType == "Bar"
                ? Text("Preis: " + euro.format(offer.price))
                : Text(offer.compensationType),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditOffer(offer: offer)
                    )
                );
              },
            ),
          ),
        ],
      )
  );
}