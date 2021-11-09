import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/SiteAdd.dart';
import 'package:greenburma/SiteDetail.dart';
import 'package:greenburma/globals.dart';

class AllSitesView extends StatefulWidget {
  @override
  _AllSitesViewState createState() => _AllSitesViewState();
}

class _AllSitesViewState extends State<AllSitesView> {

  Map allSitesMap = {};
  Map showSitesMap = {};
  Map<String,List>  dailySitesMap = {};

  @override
  void initState() {
    getData();
    super.initState();
  }


  Future<void> getData()async{
    QuerySnapshot teamDs = await FirebaseFirestore.instance.collection('Sites').orderBy('ReceivedDateTime',descending: true).get();
    teamDs.docs.forEach((element) {
      setState(() {
        allSitesMap.addEntries(
            [
              MapEntry(element.id, element.data())
            ]
        );
      });
    });
    setState(() {
      showSitesMap.addAll(allSitesMap);
    });
    allSitesMap.keys.forEach((element) {
      Timestamp ts = allSitesMap[element]['ReceivedDateTime'];
      String myOrderedDate = ts.toDate().toString().substring(0,10);
      List? dailySites = [];
      if(dailySitesMap[myOrderedDate]==null)
      {
        dailySites.add(element);
      }
      else
      {
        dailySites = dailySitesMap[myOrderedDate];
        dailySites?.add(element);
      }
        dailySitesMap.addEntries(
            [
              MapEntry(myOrderedDate, dailySites!)
            ]
        );
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Site Views'),

      ),
      body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,fillColor: colorTextFieldBG,
                  suffixIcon: Icon(Icons.search),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Search',
                ),
                style: TextStyle(color: Colors.green),
                onChanged: (value) async{
                  setState(() {
                    showSitesMap.clear();
                    dailySitesMap.clear();
                  });
                  allSitesMap.keys.forEach((element) {
                    Map eachSiteData = allSitesMap[element];
                    eachSiteData.values.forEach((fieldData) {
                      String data = fieldData.toString().replaceAll(' ', '');
                      if(data.toLowerCase().contains(value.toLowerCase()))
                      {
                        setState(() {
                          showSitesMap.addEntries([
                            MapEntry(element, allSitesMap[element])
                          ]);
                        });
                      }
                    });
                  });
                  showSitesMap.keys.forEach((element) {
                    Timestamp ts = showSitesMap[element]['ReceivedDateTime'];
                    String myOrderedDate = ts.toDate().toString().substring(0,10);
                    List? dailySites = [];
                    if(dailySitesMap[myOrderedDate]==null)
                    {
                      dailySites.add(element);
                    }
                    else
                    {
                      dailySites = dailySitesMap[myOrderedDate];
                      dailySites?.add(element);
                    }
                    dailySitesMap.addEntries(
                        [
                          MapEntry(myOrderedDate, dailySites!)
                        ]
                    );
                  });
                },
              ),
              showSitesMap.isEmpty?Container():Expanded(
                child: ListView(
                    children: dailySitesMap.keys.map((tdy) {
                      List tdySites=  dailySitesMap[tdy]!;
                      int totalRemaining=0;
                      int totalFinished=0;
                      int totalCancel=0;
                      tdySites.forEach((element) {
                        if(showSitesMap[element]['Status']=='Remaining')
                        {
                          totalRemaining++;
                        }
                        else if(showSitesMap[element]['Status']=='Finished')
                        {
                          totalFinished++;
                        }
                        if(showSitesMap[element]['Status']=='Cancel')
                        {
                          totalCancel++;
                        }
                      });
                      return ExpansionTile(
                        title: Text('Total Sites : ' +dailySitesMap[tdy]!.length.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text('F:${totalFinished.toString()}  R:${totalRemaining.toString()}  C:${totalCancel.toString()}'),
                        trailing: Text(tdy,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        children: showSitesMap.keys.map((e) {
                          Timestamp rDt = showSitesMap[e]['ReceivedDateTime'];
                          String status = showSitesMap[e]['Status'];
                          String type = showSitesMap[e]['Type'];

                          return rDt.toDate().toString().substring(0,10)!=tdy?Container():ExpansionTile(
                            title: Text(showSitesMap[e]['CustomerName'],style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                            trailing: Text(e,style: TextStyle(color: status=='Remaining'?Colors.grey:status=='Cancel'?Colors.red:Colors.green,fontWeight: FontWeight.bold),),
                            subtitle: Text(showSitesMap[e]['Address'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
                                    pop(context);push(context,AllSitesView());
                                  }, child: Text('Make Finished')),
                                  TextButton(onPressed: () async{
                                    await FirebaseFirestore.instance.collection('Sites').doc(e).update({'Status':'Cancel'});
                                    pop(context);push(context,AllSitesView());
                                  }, child: Text('Make Cancel')),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }).toList()
                ),
              ),
            ],
          )
      ),
    );
  }
}
