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

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String eid = '';
  Map peopleMap = {};
  String profileKey = '';
  bool isEdit = false;
  TextEditingController txtName = new TextEditingController(text: '');
  TextEditingController txtPassword = new TextEditingController(text: '');
  TextEditingController txtPhone = new TextEditingController(text: '');
  TextEditingController txtAddress = new TextEditingController(text: '');
  Map attendance = {};
  String photo = '';
  String url ="";
  var profileImage;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      eid = sp.getString('Username')!;
    });
    await getCollectionData('People', peopleMap);
    peopleMap.keys.forEach((element) {
      if(element==eid)
        {
          setState(() {
            profileKey = element;
          });
        }
    });
    Map kk = peopleMap[profileKey]['Attendance'];
    setState(() {
      txtName.text = peopleMap[profileKey]['Name'];
      txtPassword.text = peopleMap[profileKey]['Password'];
      txtPhone.text = peopleMap[profileKey]['Phone'];
      txtAddress.text = peopleMap[profileKey]['Address'];
      photo = peopleMap[profileKey]['Photo'];
      attendance.addAll(kk);
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(peopleMap[profileKey]['Name']),
        actions: [
          Switch(value: isEdit, onChanged: (value) {
            setState(() {
              isEdit = value;
            });
          },)
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(5),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width*0.3,
              height: MediaQuery.of(context).size.width*0.3,
              padding: EdgeInsets.all(5),
              child: profileImage==null?Container(
                child: CachedNetworkImageBuilder(url: photo, builder: (image) {
                  return Image.file(image);
                },)
              ):
              Container(
                child: Image.file(profileImage),
              ),
            ),
            !isEdit?Container():ElevatedButton(onPressed: () async {
              final ImagePicker _picker = ImagePicker();
              final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
              setState(() {
                profileImage = File(image!.path);
              });
              print(profileImage);
            }, child: Text('Choose Image')),
            TextField(
              enabled: isEdit,
              controller: txtName,
              decoration: InputDecoration(
                border: isEdit?OutlineInputBorder():InputBorder.none,
                labelText: 'Name',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              enabled: isEdit,
              controller: txtPhone,
              decoration: InputDecoration(
                border: isEdit?OutlineInputBorder():InputBorder.none,
                labelText: 'Phone',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              enabled: isEdit,
              controller: txtAddress,
              decoration: InputDecoration(
                border: isEdit?OutlineInputBorder():InputBorder.none,
                labelText: 'Address',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              enabled: isEdit,
              controller: txtPassword,
              decoration: InputDecoration(
                border: isEdit?OutlineInputBorder():InputBorder.none,
                labelText: 'Password',
              ),
            ),     SizedBox(height: 10,),
            isEdit?
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () async{
                    if(profileImage!=null)
                    {
                      url = await uploadImageCloud(profileImage, DateTime.now());
                    }
                    else{
                      setState(() {
                        url = peopleMap[profileKey]['Photo'];
                      });
                    }

                    // if(txtName.text)
                    //   {
                    //
                    //   }
                    await FirebaseFirestore.instance.collection('People').doc(profileKey).update({
                      'Name':txtName.text,
                      'Phone':txtPhone.text,
                      'Address':txtAddress.text,
                      'Password':txtPassword.text,
                      'Attendance':{},
                      'Photo':url,
                    });
                    pop(context);
                    push(context, ProfilePage());
                  },
                )
                :Container(),
          ],
        ),
      ),
    );
  }
}
