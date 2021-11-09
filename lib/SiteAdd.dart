import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenburma/HomePage.dart';
import 'package:greenburma/globals.dart';
import 'package:latlng/latlng.dart';

class SiteAdd extends StatefulWidget {
  @override
  _SiteAddState createState() => _SiteAddState();
}

class _SiteAddState extends State<SiteAdd> {

  DateTime receivedDateTime = DateTime.now();
  DateTime installDateTime = DateTime.now();

  TextEditingController txtCustomerId = new TextEditingController(text: '');
  TextEditingController txtTicket = new TextEditingController(text: '');
  TextEditingController txtCustomerName = new TextEditingController(text: '');
  TextEditingController txtAddress = new TextEditingController(text: '');
  TextEditingController txtPrimaryPhone = new TextEditingController(text: '');
  TextEditingController txtSecondaryPhone = new TextEditingController(text: '');
  TextEditingController txtBandwidth = new TextEditingController(text: '');

  TextEditingController txtZone = new TextEditingController(text: 'NoZone');
  TextEditingController txtDN = new TextEditingController(text: '0');
  TextEditingController txtSN = new TextEditingController(text: '0');
  TextEditingController txtPort = new TextEditingController(text: '0');
  TextEditingController txtEngineerComment = new TextEditingController(text: '');

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
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(5),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () async{
                  await showDatePicker(context: context, initialDate: receivedDateTime, firstDate: DateTime(2000), lastDate: DateTime(2100)).then((date) async{
                    await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                      setState(() {
                        if(date!=null&&time!=null)
                        {
                          receivedDateTime = new DateTime(date.year,date.month,date.day,time.hour,time.minute);
                        }
                      });
                    });
                  });
                }, child: Text('Received Date Time\n'+receivedDateTime.toString().substring(0,16))),

                ElevatedButton(onPressed: () async{
                  await showDatePicker(context: context, initialDate: installDateTime, firstDate: DateTime(2000), lastDate: DateTime(2100)).then((date) async{
                    await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                      setState(() {
                        if(date!=null&&time!=null)
                        {
                          installDateTime = new DateTime(date.year,date.month,date.day,time.hour,time.minute);
                        }
                      });
                    });
                  });
                }, child: Text('Install Date Time\n'+installDateTime.toString().substring(0,16))),
              ],
            ),
            SizedBox(height: 10,),
            TextField(
              controller: txtCustomerId,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Customer ID',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              controller: txtTicket,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ticket',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              controller: txtCustomerName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Customer Name',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              controller: txtPrimaryPhone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Primary Phone',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              controller: txtSecondaryPhone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Secondary Phone',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              controller: txtAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
              ),
            ),     SizedBox(height: 10,),
            TextField(
              controller: txtBandwidth,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Bandwidth',
              ),
            ),     SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: Container(
                  child:  TextField(
                    controller: txtZone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Zone',
                    ),
                  ),
                )),
                SizedBox(width: 10,),
                Expanded(child: Container(
                  child:  TextField(
                    controller: txtDN,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'DN',
                    ),
                  ),
                )),
                SizedBox(width: 10,),
                Expanded(child: Container(
                  child:  TextField(
                    controller: txtSN,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'SN',
                    ),
                  ),
                )),
                SizedBox(width: 10,),
                Expanded(child: Container(
                  child:   TextField(
                    controller: txtPort,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Port',
                    ),
                  ),
                )),
              ],
            ),
             SizedBox(height: 10,),
            TextField(
              controller: txtEngineerComment,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Engineer Comment',
              ),
            ),     SizedBox(height: 10,),
            TextButton(
              child: Text('Add Site'),
              onPressed: () async{
                showAlertDialog(context, 'Successfully Saved', Text('Okay'), []);
                if(txtTicket.text==''){//Install
                  await FirebaseFirestore.instance.collection('Sites').doc(txtCustomerId.text).set({
                    'Type':'Install',
                    'Status':'Remaining',
                    'CustomerID':txtCustomerId.text,
                    'Ticket':txtTicket.text,
                    'ReceivedDateTime':receivedDateTime,
                    'InstallDateTime':installDateTime,
                    'CustomerName':txtCustomerName.text,
                    'Address':txtAddress.text,
                    'PrimaryPhone':txtPrimaryPhone.text,
                    'SecondaryPhone':txtSecondaryPhone.text,
                    'Bandwidth':txtBandwidth.text,
                    'StartMeter':'',
                    'EndMeter':'',
                    'DNSN':txtZone.text+'-'+txtDN.text+'-'+txtSN.text,
                    'Port':txtPort.text,
                    'SNLatLong':GeoPoint(LatLng(0,0).latitude,LatLng(0,0).longitude),
                    'HomeLatLong':GeoPoint(LatLng(0,0).latitude,LatLng(0,0).longitude),
                    'PolesLatLong':[],
                    'UsedDevice':'',
                    'Username':'',
                    'Password':'',
                    'EngineerComment':'',
                  });
                }
                else{//Maintain
                  await FirebaseFirestore.instance.collection('Sites').doc(txtCustomerId.text+'-'+txtTicket.text).set({
                    'Type':'Maintain',
                    'Status':'Remaining',
                    'CustomerID':txtCustomerId.text,
                    'Ticket':txtTicket.text,
                    'ReceivedDateTime':receivedDateTime,
                    'InstallDateTime':installDateTime,
                    'CustomerName':txtCustomerName.text,
                    'Address':txtAddress.text,
                    'PrimaryPhone':txtPrimaryPhone.text,
                    'SecondaryPhone':txtSecondaryPhone.text,
                    'Bandwidth':txtBandwidth.text,
                    'StartMeter':'',
                    'EndMeter':'',
                    'DNSN':txtZone.text+'-'+txtDN.text+'-'+txtSN.text,
                    'Port':txtPort.text,
                    'SNLatLong':GeoPoint(LatLng(0,0).latitude,LatLng(0,0).longitude),
                    'HomeLatLong':GeoPoint(LatLng(0,0).latitude,LatLng(0,0).longitude),
                    'PolesLatLong':[],
                    'UsedDevice':'',
                    'Username':'',
                    'Password':'',
                    'EngineerComment':'',
                  });
                }
                pop(context);
                pushReplacement(context, HomePage());
              },
            ),
          ],
        )
      ),
    );
  }
}
