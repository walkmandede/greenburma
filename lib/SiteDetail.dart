import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greenburma/HomePage.dart';
import 'package:greenburma/globals.dart';

class SiteDetail extends StatefulWidget {

  final String docID;
  const SiteDetail(this.docID);

  @override
  _SiteDetailState createState() => _SiteDetailState();
}

class _SiteDetailState extends State<SiteDetail> {

  Map allSitesMap = {};
  bool isEdit = false;
  String currentPage = '1';

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
  TextEditingController txtEndMeter = new TextEditingController(text: '');
  TextEditingController txtStartMeter = new TextEditingController(text: '');
  TextEditingController txtPassword = new TextEditingController(text: '');
  TextEditingController txtUsedDevice = new TextEditingController(text: '');
  TextEditingController txtUsername = new TextEditingController(text: '');
  TextEditingController txtHomeLatLong = new TextEditingController(text: '');
  TextEditingController txtSNLatLong = new TextEditingController(text: '');


  List poles = [];

  GeoPoint homeLatLong = GeoPoint(0, 0);
  GeoPoint snLatLong = GeoPoint(0, 0);
  BitmapDescriptor homeIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor snIcon = BitmapDescriptor.defaultMarker;

  late GoogleMapController controller1;


  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData()async{
    await getCollectionData('Sites', allSitesMap);
    setState(() {
      homeLatLong = allSitesMap[widget.docID]['HomeLatLong'];
      snLatLong = allSitesMap[widget.docID]['SNLatLong'];
      txtCustomerId.text = allSitesMap[widget.docID]['CustomerID'];
      txtAddress.text = allSitesMap[widget.docID]['Address'];
      txtBandwidth.text = allSitesMap[widget.docID]['Bandwidth'];
      txtCustomerName.text = allSitesMap[widget.docID]['CustomerName'];
      txtTicket.text = allSitesMap[widget.docID]['Ticket'];
      txtPrimaryPhone.text = allSitesMap[widget.docID]['PrimaryPhone'];
      txtSecondaryPhone.text = allSitesMap[widget.docID]['SecondaryPhone'];
      txtZone.text = allSitesMap[widget.docID]['DNSN'].toString().split('-')[0];
      txtDN.text = allSitesMap[widget.docID]['DNSN'].toString().split('-')[1];
      txtSN.text = allSitesMap[widget.docID]['DNSN'].toString().split('-')[2];
      txtEngineerComment.text = allSitesMap[widget.docID]['EngineerComment'];
      Timestamp idt = allSitesMap[widget.docID]['InstallDateTime'];
      installDateTime = idt.toDate();
      Timestamp rdt = allSitesMap[widget.docID]['ReceivedDateTime'];
      receivedDateTime = rdt.toDate();
      poles = allSitesMap[widget.docID]['PolesLatLong'];
      txtPort.text = allSitesMap[widget.docID]['Port'];
      txtEndMeter.text = allSitesMap[widget.docID]['EndMeter'];
      txtStartMeter.text = allSitesMap[widget.docID]['StartMeter'];
      txtPassword.text = allSitesMap[widget.docID]['Password'];
      txtUsedDevice.text = allSitesMap[widget.docID]['UsedDevice'];
      txtUsername.text = allSitesMap[widget.docID]['Username'];
      txtHomeLatLong.text = homeLatLong.latitude.toString() + ','+homeLatLong.longitude.toString();
      txtSNLatLong.text = snLatLong.latitude.toString() + ','+snLatLong.longitude.toString();
    });
    homeIcon = await getIconForMap(Icons.home, Colors.green);
    snIcon = await getIconForMap(Icons.router, Colors.red);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(value: isEdit, onChanged: (value) {
            setState(() {
              isEdit=value;
            });
          },activeColor: Colors.white,)
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width*0.5,
              child: GoogleMap(
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                mapToolbarEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(16.8342411,96.1624166),
                  zoom: 14,),
                markers: {
                  Marker(
                    markerId: MarkerId('Home'),
                    position: LatLng(homeLatLong.latitude,homeLatLong.longitude),
                    icon: homeIcon,
                  ),
                  Marker(
                    markerId: MarkerId('SN'),
                    position: LatLng(snLatLong.latitude,snLatLong.longitude),
                    icon: snIcon,
                  ),
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                child: ListView(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: () async{
                          if(isEdit)
                          {
                            await showDatePicker(context: context, initialDate: receivedDateTime, firstDate: DateTime(2000), lastDate: DateTime(2100)).then((date) async{
                              await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                                setState(() {
                                  if(date!=null&&time!=null)
                                  {
                                    receivedDateTime = new DateTime(date.year,date.month,date.day,time.hour,time.minute);
                                  }
                                });
                                setState(() {

                                });
                              });
                            });
                          }
                        }, child: Text('Received Date Time\n'+receivedDateTime.toString().substring(0,16))),

                        ElevatedButton(onPressed: () async{
                          if(isEdit)
                          {
                            await showDatePicker(context: context, initialDate: installDateTime, firstDate: DateTime(2000), lastDate: DateTime(2100)).then((date) async{
                              await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
                                setState(() {
                                  if(date!=null&&time!=null)
                                  {
                                    installDateTime = new DateTime(date.year,date.month,date.day,time.hour,time.minute);
                                  }
                                });
                                setState(() {

                                });
                              });
                            });
                          }
                        }, child: Text('Install Date Time\n'+installDateTime.toString().substring(0,16))),
                      ],
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      enabled: isEdit,
                      controller: txtCustomerId,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Customer ID',
                      ),
                    ),     SizedBox(height: 10,),
                    TextField(
                      enabled: isEdit,
                      controller: txtTicket,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ticket',
                      ),
                    ),     SizedBox(height: 10,),
                    TextField(
                      enabled: isEdit,
                      controller: txtCustomerName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Customer Name',
                      ),
                    ),     SizedBox(height: 10,),
                    TextField(
                      enabled: isEdit,
                      controller: txtPrimaryPhone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Primary Phone',
                      ),
                    ),     SizedBox(height: 10,),
                    TextField(
                      enabled: isEdit,
                      controller: txtSecondaryPhone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Secondary Phone',
                      ),
                    ),     SizedBox(height: 10,),
                    TextField(
                      enabled: isEdit,
                      controller: txtAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Address',
                      ),
                    ),     SizedBox(height: 10,),
                    TextField(
                      enabled: isEdit,
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
                            enabled: isEdit,
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
                            enabled: isEdit,
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
                            enabled: isEdit,
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
                            enabled: isEdit,
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
                      enabled: isEdit,
                      controller: txtEngineerComment,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Engineer Comment',
                      ),
                    ),     SizedBox(height: 10,),
                    Divider(),
                    Row(
                      children: [
                        Expanded(child: Container(
                          child:  TextField(
                            enabled: isEdit,
                            controller: txtStartMeter,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Start Meter',
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),
                        Expanded(child: Container(
                          child:  TextField(
                            enabled: isEdit,
                            controller: txtEndMeter,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'End Meter',
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),
                        Expanded(child: Container(
                          child:  TextField(
                            enabled: false,
                            controller: new TextEditingController(text: txtStartMeter.text==''||txtEndMeter.text==''?'':(int.parse(txtStartMeter.text)-int.parse(txtEndMeter.text)).toString()),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Total Meter',
                            ),
                          ),
                        )),
                      ],
                    ),SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          child:  TextField(
                            enabled: isEdit,
                            controller: txtHomeLatLong,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Home LatLong',
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),
                        IconButton(onPressed: () async{
                          if(isEdit)
                          {
                            Position pp= await Geolocator.getCurrentPosition();
                            setState(() {
                              txtHomeLatLong.text = pp.latitude.toString() +','+pp.longitude.toString();
                            });
                          }
                        }, icon: Icon(Icons.gps_fixed))
                      ],
                    ),SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          child:  TextField(
                            enabled: isEdit,
                            controller: txtSNLatLong,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'SN LatLong',
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),
                        IconButton(onPressed: () async{
                          if(isEdit)
                          {
                            Position pp= await Geolocator.getCurrentPosition();
                            setState(() {
                              txtSNLatLong.text = pp.latitude.toString() +','+pp.longitude.toString();
                            });
                          }
                        }, icon: Icon(Icons.gps_fixed))
                      ],
                    ),SizedBox(height: 10,),
                    Divider(),
                    TextField(
                      enabled: isEdit,
                      controller: txtUsedDevice,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Used Device',
                      ),
                    ),SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          child:  TextField(
                            enabled: isEdit,
                            controller: txtUsername,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                          ),
                        )),
                        SizedBox(width: 10,),
                        Expanded(child: Container(
                          child:  TextField(
                            enabled: isEdit,
                            controller: txtPassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'txtPassword',
                            ),
                          ),
                        )),
                      ],
                    ),SizedBox(height: 10,),

                    !isEdit?Container():TextButton(
                      child: Text('Save'),
                      onPressed: () async{
                        showAlertDialog(context, 'Successfully Saved', Text('Okay'), []);
                        await FirebaseFirestore.instance.collection('Sites').doc(widget.docID).update({
                          'Type':allSitesMap[widget.docID]['Type'],
                          'Status':allSitesMap[widget.docID]['Status'],
                          'CustomerID':txtCustomerId.text,
                          'Ticket':txtTicket.text,
                          'ReceivedDateTime':receivedDateTime,
                          'InstallDateTime':installDateTime,
                          'CustomerName':txtCustomerName.text,
                          'Address':txtAddress.text,
                          'PrimaryPhone':txtPrimaryPhone.text,
                          'SecondaryPhone':txtSecondaryPhone.text,
                          'Bandwidth':txtBandwidth.text,
                          'StartMeter':txtStartMeter.text,
                          'EndMeter':txtEndMeter.text,
                          'DNSN':txtZone.text+'-'+txtDN.text+'-'+txtSN.text,
                          'Port':txtPort.text,
                          'SNLatLong':GeoPoint(double.parse(txtSNLatLong.text.split(',')[0]),double.parse(txtSNLatLong.text.split(',')[1])),
                          'HomeLatLong':GeoPoint(double.parse(txtHomeLatLong.text.split(',')[0]),double.parse(txtHomeLatLong.text.split(',')[1])),
                          'PolesLatLong':[],
                          'UsedDevice':txtUsedDevice.text,
                          'Username':txtUsername.text,
                          'Password':txtPassword.text,
                          'EngineerComment':txtEngineerComment.text,
                        });
                        pop(context);
                        pushReplacement(context, HomePage());
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
