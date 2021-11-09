import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/AllSitesView.dart';
import 'package:greenburma/DailySiteView.dart';
import 'package:greenburma/HomePage.dart';
import 'package:greenburma/LogInPage.dart';
import 'package:greenburma/SiteAdd.dart';
import 'package:greenburma/globals.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController txtEmployeeID = new TextEditingController(text: '');
  TextEditingController txtUsername = new TextEditingController(text: '');
  TextEditingController txtPhone = new TextEditingController(text: '');
  TextEditingController txtAddress = new TextEditingController(text: '');
  TextEditingController txtPassword = new TextEditingController(text: '');

  @override
  void initState() {
    getData();
    super.initState();
  }


  Future<void> getData()async{
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Register',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            TextField(
              controller: txtEmployeeID,
              decoration: InputDecoration(
                  label: Text('Employee ID'),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtUsername,
              decoration: InputDecoration(
                  label: Text('Username'),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtPhone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  label: Text('Phone'),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtAddress,
              decoration: InputDecoration(
                  label: Text('Address'),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtPassword,
              obscureText: true,
              decoration: InputDecoration(
                  label: Text('Password'),
                  border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () async{
                showAlertDialog(context, 'Registering ...', Text(''), []);
                await FirebaseFirestore.instance.collection('People').doc(txtEmployeeID.text).set({
                  'Name':txtUsername.text,
                  'Phone':txtPhone.text,
                  'Address':txtAddress.text,
                  'Password':txtPassword.text,
                  'Attendance':{},
                  'Photo':'',
                });
                pushReplacement(context, LoginPage());
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: Colors.green,
                child: Text('Register',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
      )
    );
  }
}
