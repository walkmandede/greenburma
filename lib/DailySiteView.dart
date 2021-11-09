import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/SiteAdd.dart';
import 'package:greenburma/SiteDetail.dart';
import 'package:greenburma/globals.dart';

class DailySiteView extends StatefulWidget {
  @override
  _DailySiteViewState createState() => _DailySiteViewState();
}

class _DailySiteViewState extends State<DailySiteView> {

  DateTime selectedDate = DateTime.now();
  Map allSitesMap = {};
  Map dailySitesMap = {};

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getThisDateSites(DateTime dt)
  {
    setState(() {
      dailySitesMap.clear();
    });

    allSitesMap.keys.forEach((element) {
      Timestamp idtTs = allSitesMap[element]['ReceivedDateTime'];
      if(idtTs.toDate().toString().substring(0,10)==dt.toString().substring(0,10))
      {
        setState(() {
          dailySitesMap.addEntries(
              [MapEntry(element, allSitesMap[element])]
          );
        });
      }
    });
  }



  Future<void> getData()async{
    await getCollectionData('Sites', allSitesMap);
    getThisDateSites(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Sites View'),
        actions: [
          TextButton.icon(onPressed: () {
            showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000), lastDate: DateTime(2100)).then((date) {
              setState(() {
                selectedDate = date!;
              });
              getThisDateSites(selectedDate);
            });
          }, icon: Icon(Icons.calendar_today,color: Colors.white,), label: Text(selectedDate.toString().substring(0,10),style: TextStyle(color: Colors.white),)),
        ],
      ),
      body: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              setState(() {
                selectedDate = selectedDate.subtract(Duration(days: 1));
              });
              getThisDateSites(selectedDate);
            } else if (details.primaryVelocity! < 0) {
              setState(() {
                selectedDate = selectedDate.add(Duration(days: 1));
              });
              getThisDateSites(selectedDate);
            }
          },
        child: Container(
          margin: EdgeInsets.all(5),
          child: ListView(
            children: dailySitesMap.keys.map((e) {
              Map siteData = dailySitesMap[e];
                return ExpansionTile(
                  title: Text(dailySitesMap[e]['CustomerName'],style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                  trailing: Text(e,style: TextStyle(color: dailySitesMap[e]['Status']=='Remaining'?Colors.grey:dailySitesMap[e]['Status']=='Cancel'?Colors.red:Colors.green,fontWeight: FontWeight.bold),),
                  subtitle: Text(dailySitesMap[e]['Address'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  leading: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      push(context, SiteDetail(e));
                    },
                  ),
                  children: [
                    Row(
                      children: [
                        TextButton(onPressed: () async{
                          await FirebaseFirestore.instance.collection('Sites').doc(e).update({'Status':'Finished'});
                          pop(context);push(context,DailySiteView());
                        }, child: Text('Make Finished')),
                        TextButton(onPressed: () async{
                          await FirebaseFirestore.instance.collection('Sites').doc(e).update({'Status':'Cancel'});
                          pop(context);push(context,DailySiteView());
                        }, child: Text('Make Cancel')),
                      ],
                    ),
                  ],
                );
            }).toList()
          ),
        ),
      ),
    );
  }
}
