import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/AllSitesView.dart';
import 'package:greenburma/CheckIn.dart';
import 'package:greenburma/DailySiteView.dart';
import 'package:greenburma/LogInPage.dart';
import 'package:greenburma/People.dart';
import 'package:greenburma/Profile.dart';
import 'package:greenburma/SiteAdd.dart';
import 'package:greenburma/SiteDetail.dart';
import 'package:greenburma/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String username = '';
  Map attendanceMap ={};
  Map sitesMap = {};
  Map peopleMap = {};
  Map remainingSites = {};
  Map thisMonthSites = {};
  List tdyCheckInPeople = [];
  List tdyLeavePeople = [];

  @override
  void initState() {
    getData();
    super.initState();
  }


  Future<void> getData()async{
    await Firebase.initializeApp();
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      username = sp.getString('Username')!;
    });
    await getCollectionData('Sites', sitesMap);
    await getCollectionData('Attendance', attendanceMap);
    await getCollectionData('People', peopleMap);
    sitesMap.keys.forEach((element) {
      if(sitesMap[element]['Status']=='Remaining')
      {
        setState(() {
          remainingSites.addEntries([
            MapEntry(element, sitesMap[element])
          ]);
        });
      }
    });
    sitesMap.keys.forEach((element) {
      Timestamp rdt = sitesMap[element]['ReceivedDateTime'];
      if(rdt.toDate().toString().substring(5,7)==DateTime.now().toString().substring(5,7))
      {
        setState(() {
          thisMonthSites.addEntries([
            MapEntry(element, sitesMap[element])
          ]);
        });
      }
    });
    setState(() {
      tdyCheckInPeople = attendanceMap[DateTime.now().toString().substring(0,10)]['CheckedIn'];
      tdyLeavePeople = attendanceMap[DateTime.now().toString().substring(0,10)]['Leave'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                push(context, ProfilePage());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImageBuilder(url: 'https://cdn0.iconfinder.com/data/icons/seo-web-4-1/128/Vigor_User-Avatar-Profile-Photo-01-256.png', builder: (image) {
                        return Image.file(image,width: 30,height: 30,);
                      },),
                      Text('Profile',style: TextStyle(color: Colors.white),),
                    ],
                  )
              ),
            ),
            GestureDetector(
              onTap: () {
                push(context, PeoplePage());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImageBuilder(url: 'https://cdn0.iconfinder.com/data/icons/seo-web-4-1/128/Vigor_Users-People-Friends-512.png', builder: (image) {
                        return Image.file(image,width: 30,height: 30,);
                      },),
                      Text('People',style: TextStyle(color: Colors.white),),
                    ],
                  )
              ),
            ),
            GestureDetector(
              onTap: () {
                push(context, CheckInPage());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImageBuilder(url: 'https://cdn2.iconfinder.com/data/icons/flat-pack-1/64/Clock-512.png', builder: (image) {
                        return Image.file(image,width: 30,height: 30,);
                      },),
                      Text('Daily Check In',style: TextStyle(color: Colors.white),),
                    ],
                  )
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                push(context, SiteAdd());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.green
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImageBuilder(url: 'https://cdn1.iconfinder.com/data/icons/web-design-development-25/100/add_new_article_web_site_development_creative-512.png', builder: (image) {
                        return Image.file(image,width: 30,height: 30,);
                      },),
                      Text('New Site',style: TextStyle(color: Colors.white),),
                    ],
                  )
              ),
            ),
            GestureDetector(
              onTap: () {
                push(context, AllSitesView());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.green
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImageBuilder(url: 'https://cdn4.iconfinder.com/data/icons/shopping-commerce-filled-outline-set-1/256/23-256.png', builder: (image) {
                        return Image.file(image,width: 30,height: 30,);
                      },),
                      Text('All Site View',style: TextStyle(color: Colors.white),),
                    ],
                  )
              ),
            ),
            GestureDetector(
              onTap: () {
                push(context, DailySiteView());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.green
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImageBuilder(url: 'https://cdn0.iconfinder.com/data/icons/ballicons/128/calendar-512.png', builder: (image) {
                        return Image.file(image,width: 30,height: 30,);
                      },),
                      Text('Daily Site View',style: TextStyle(color: Colors.white),),
                    ],
                  )
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () async{
                SharedPreferences sp = await SharedPreferences.getInstance();
                await sp.clear();
                push(context, LoginPage());
              },
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.red
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImageBuilder(url: 'https://cdn2.iconfinder.com/data/icons/top-search/128/_signout_common_door_exit_logout_out-512.png', builder: (image) {
                        return Image.file(image,width: 30,height: 30,);
                      },),
                      Text('Log Out',style: TextStyle(color: Colors.white),),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        child: ListView(
          children: [
            ExpansionTile(
              title: Text('Total Remaining Sites'),
              subtitle: Text(remainingSites.keys.length.toString(),style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
              children: remainingSites.keys.map((e) {
                Timestamp rDt = remainingSites[e]['ReceivedDateTime'];
                String status = remainingSites[e]['Status'];
                String type = remainingSites[e]['Type'];

                return ExpansionTile(
                  title: Text(remainingSites[e]['CustomerName'],style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                  trailing: Text(e,style: TextStyle(color: status=='Remaining'?Colors.grey:status=='Cancel'?Colors.red:Colors.green,fontWeight: FontWeight.bold),),
                  subtitle: Text(remainingSites[e]['Address'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
            ),
            ExpansionTile(
              title: Text('This Month Sites'),
              subtitle: Text(thisMonthSites.keys.length.toString(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              children: thisMonthSites.keys.map((e) {
                Timestamp rDt = thisMonthSites[e]['ReceivedDateTime'];
                String status = thisMonthSites[e]['Status'];
                String type = thisMonthSites[e]['Type'];

                return ExpansionTile(
                  title: Text(thisMonthSites[e]['CustomerName'],style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                  trailing: Text(e,style: TextStyle(color: status=='Remaining'?Colors.grey:status=='Cancel'?Colors.red:Colors.green,fontWeight: FontWeight.bold),),
                  subtitle: Text(thisMonthSites[e]['Address'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
            ),
            ExpansionTile(
              title: Text('Today Checked In : ${tdyCheckInPeople.length.toString()}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
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
              title: Text('Today Leave : ${tdyLeavePeople.length.toString()}',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
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
        )
      )
    );
  }
}
