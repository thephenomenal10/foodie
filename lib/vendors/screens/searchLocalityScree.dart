import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;

class SearchLocality extends StatefulWidget {
  @override
  SearchLocalityState createState() => SearchLocalityState();
}

class SearchLocalityState extends State<SearchLocality> {
  GoogleMapController mapController;
  String searchAddr;
  final Set<Marker> _marker = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Find Address"),
          centerTitle: true,
        ),
        body: new Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(28.667856, 77.449791), zoom: 15.0),
              onMapCreated: onMapCreated,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              indoorViewEnabled: true,
              trafficEnabled: true,
              markers: _marker,
            ),
            Positioned(
              top: 30.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchNavigate,
                          iconSize: 30.0)),
                  onChanged: (val) {
                    setState(() {
                      searchAddr = val;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: FloatingActionButton.extended(
                label: Text(
                  'SET',
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                backgroundColor: myGreen,
                onPressed: () {
                  if (searchAddr.isNotEmpty) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ));
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void searchNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((value) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(value[0].position.latitude, value[0].position.longitude),
          zoom: 20.0,
        ),
      ));

      setState(() {
        _marker.add(Marker(
          markerId: MarkerId("my marker"),
          position:
              LatLng(value[0].position.latitude, value[0].position.longitude),
          infoWindow: InfoWindow(title: "Address", snippet: searchAddr),
          icon: BitmapDescriptor.defaultMarker,
        ));
        global.localityAddress = searchAddr.toString();
        global.tiffenCentreLatitude = value[0].position.latitude.toDouble();
        global.tiffenCentreLongitude = value[0].position.longitude.toDouble();
        print(value[0].position.latitude);
        print(value[0].position.longitude);
      });
    });
  }
}
