import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/HomePage.dart';
import 'package:greenburma/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlng/latlng.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {

  Map peopleMap = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async{
    await getCollectionData('People', peopleMap);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People'),
        actions: [
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: peopleMap.keys.map((e) {
            return Card(
              child: ListTile(
                title: Text(peopleMap[e]['Name']),
                subtitle: Text(e),
                trailing: CachedNetworkImageBuilder(url: peopleMap[e]['Photo'], builder: (image) => Image.file(image),),
              ),
            );
          }).toList(),
        )
      ),
    );
  }
}

