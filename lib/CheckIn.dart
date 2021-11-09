import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/HomePage.dart';
import 'package:greenburma/globals.dart';
import 'package:latlng/latlng.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInPage extends StatefulWidget {
  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {

  DateTime dt = DateTime.now();
  Map attendanceMap = {};
  String username = '';
  Map peopleMap ={};
  bool isAlreadyCheckedInTdy = false;
  List tdyCheckInPeople = [];
  List tdyLeavePeople = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async{
    await getCollectionData('Attendance', attendanceMap);
    await getCollectionData('People', peopleMap);
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      username = sp.getString('Username')!;
    });
    List tdyCheckIn = [];
    List tdyLeave = [];
    if(attendanceMap[dt.toString().substring(0,10)]['CheckedIn']!=null)
    {
      tdyCheckIn = attendanceMap[dt.toString().substring(0,10)]['CheckedIn'];
    }
    if(attendanceMap[dt.toString().substring(0,10)]['Leave']!=null)
    {
      tdyLeave = attendanceMap[dt.toString().substring(0,10)]['Leave'];
    }
    if(tdyCheckIn.contains(username)||tdyLeave.contains(username))
      {
        setState(() {
          isAlreadyCheckedInTdy = true;
        });
      }
    print(isAlreadyCheckedInTdy);
    setState(() {
      tdyCheckInPeople = attendanceMap[dt.toString().substring(0,10)]['CheckedIn'];
      tdyLeavePeople = attendanceMap[dt.toString().substring(0,10)]['Leave'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dt.toString().substring(0,10)),
        actions: [
          isAlreadyCheckedInTdy?Container():IconButton(onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text('What do you want to do?'),
                actions: [
                  TextButton(onPressed: () async{
                    if(attendanceMap[dt.toString().substring(0,10)]==null)//tdyNoOneCheckedInOrLeave
                        {
                      await FirebaseFirestore.instance.collection('Attendance').doc(dt.toString().substring(0,10)).set(
                          {
                            'Leave':[username],
                          }
                      );
                      pushReplacement(context, HomePage());
                      push(context, CheckInPage());
                    }
                    else if(attendanceMap[dt.toString().substring(0,10)]['Leave']==null)//tdyNoCheckIn
                        {
                      await FirebaseFirestore.instance.collection('Attendance').doc(dt.toString().substring(0,10)).update(
                          {
                            'Leave':[username],
                          }
                      );
                      pushReplacement(context, HomePage());
                      push(context, CheckInPage());
                    }
                    //tdySomebodyCheckIn
                    else{
                      List checkIns= attendanceMap[dt.toString().substring(0,10)]['CheckedIn'];
                      checkIns.add(username);
                      await FirebaseFirestore.instance.collection('Attendance').doc(dt.toString().substring(0,10)).update(
                          {
                            'CheckedIn':checkIns,
                          }
                      );
                      pushReplacement(context, HomePage());
                      push(context, CheckInPage());
                    }
                  }, child: Text('Leave!',style: TextStyle(color: Colors.red),)),
                  TextButton(onPressed: () async{
                    if(attendanceMap[dt.toString().substring(0,10)]==null)//tdyNoOneCheckedInOrLeave
                      {
                        await FirebaseFirestore.instance.collection('Attendance').doc(dt.toString().substring(0,10)).set(
                            {
                              'CheckedIn':[username],
                            }
                        );
                        pushReplacement(context, HomePage());
                        push(context, CheckInPage());
                      }
                    else if(attendanceMap[dt.toString().substring(0,10)]['CheckedIn']==null)//tdyNoCheckIn
                        {
                      await FirebaseFirestore.instance.collection('Attendance').doc(dt.toString().substring(0,10)).update(
                          {
                            'CheckedIn':[username],
                          }
                      );
                      pushReplacement(context, HomePage());
                      push(context, CheckInPage());
                    }
                    //tdySomebodyCheckIn
                    else{
                      List checkIns= attendanceMap[dt.toString().substring(0,10)]['CheckedIn'];
                      checkIns.add(username);
                      await FirebaseFirestore.instance.collection('Attendance').doc(dt.toString().substring(0,10)).update(
                          {
                            'CheckedIn':checkIns,
                          }
                      );
                      pushReplacement(context, HomePage());
                      push(context, CheckInPage());
                    }
                  }, child: Text('Check In!',style: TextStyle(color: Colors.green),)),
                ],
              );
            },);
          }, icon: Icon(Icons.alarm,color: Colors.white,))
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTile(
                title: Text('Checked In : ${tdyCheckInPeople.length.toString()}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                children: tdyCheckInPeople.map((e) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImageBuilder(url: peopleMap[e]['Photo']==''?'https://cdn2.iconfinder.com/data/icons/scenarium-vol-4/128/006_avatar_worker_employee_man_account_manager_clerk-512.png'
                            :peopleMap[e]['Photo'], builder: (image) => Image.file(image,height: 50,width: 50,),),
                        Text(peopleMap[e]['Name'],style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  );                }).toList(),
              ),
              ExpansionTile(
                title: Text('Leave : ${tdyLeavePeople.length.toString()}',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                children: tdyLeavePeople.map((e) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedNetworkImageBuilder(url: peopleMap[e]['Photo'], builder: (image) => Image.file(image,height: 50,width: 50,),),
                        Text(peopleMap[e]['Name'],style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
