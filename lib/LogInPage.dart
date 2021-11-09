import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/AllSitesView.dart';
import 'package:greenburma/DailySiteView.dart';
import 'package:greenburma/HomePage.dart';
import 'package:greenburma/RegisterPage.dart';
import 'package:greenburma/SiteAdd.dart';
import 'package:greenburma/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController txtEmployeeID = new TextEditingController(text: '');
  TextEditingController txtPassword = new TextEditingController(text: '');
  Map peopleMap = {};

  @override
  void initState() {
    getData();
    super.initState();
  }


  Future<void> getData()async{
    await Firebase.initializeApp();
    getCollectionData('People', peopleMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Log In To Continue'),
            SizedBox(height: 10,),
            TextField(
              controller: txtEmployeeID,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtPassword,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                peopleMap.keys.forEach((element) async{
                  if(element==txtEmployeeID.text)
                    {
                      if(peopleMap[element]['Password']==txtPassword.text)
                        {
                          SharedPreferences sp = await SharedPreferences.getInstance();
                          await sp.setString('Username', txtEmployeeID.text);
                          pushReplacement(context, HomePage());
                        }
                      else{
                        showAlertDialog(context, 'Invalid Username or Password', Text(''), []);
                      }
                    }
                  else{
                    showAlertDialog(context, 'Invalid Username or Password', Text(''), []);
                  }
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: Colors.green,
                child: Text('Log In',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                push(context, RegisterPage());
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Text('Register',textAlign: TextAlign.end,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      )
    );
  }
}
