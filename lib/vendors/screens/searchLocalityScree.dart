import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
import 'package:geocoder/geocoder.dart';
// import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;
import 'package:location/location.dart';

class SearchLocality extends StatefulWidget {
  @override
  SearchLocalityState createState() => SearchLocalityState();
}

class SearchLocalityState extends State<SearchLocality> {
  GoogleMapController mapController;
  String searchAddr;
  LatLng selectedPosition = LatLng(28.38, 77.13);
  LocationData locData;

  Future<void> getDeviceLocation() async {
    try {
      locData = await Location().getLocation();
      _setLocation(
        LatLng(locData.latitude, locData.longitude),
      );
    } catch (error) {
      print(error);
    }
  }

  void _setLocation(LatLng location) {
    setState(() {
      selectedPosition = location;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: selectedPosition,
            zoom: 20.0,
          ),
        ),
      );
      print(location.toJson());
    });
  }

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
              target: selectedPosition,
              zoom: 15.0,
            ),
            onTap: _setLocation,
            onMapCreated: onMapCreated,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            mapToolbarEnabled: true,
            indoorViewEnabled: true,
            trafficEnabled: true,
            markers: {
              Marker(
                markerId: MarkerId('m1'),
                position: selectedPosition,
              ),
            },
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
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => searchNavigate(),
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: searchNavigate,
                    iconSize: 30.0,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchAddr = val;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 110,
            right: 5,
            child: IconButton(
              icon: Icon(
                Icons.gps_fixed,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: getDeviceLocation,
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
              onPressed: () async {
                List<Address> address;
                try {
                  address = await Geocoder.local.findAddressesFromCoordinates(
                    Coordinates(
                      selectedPosition.latitude,
                      selectedPosition.longitude,
                    ),
                  );
                  searchAddr = address.first.addressLine;
                } catch (error) {
                  print("this error" + error.toString());
                }
                print(searchAddr);
                global.localityAddress = searchAddr.toString();
                global.tiffenCentreLatitude =
                    selectedPosition.latitude.toDouble();
                global.tiffenCentreLongitude =
                    selectedPosition.longitude.toDouble();
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void searchNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then(
      (value) {
        print(value[0].position.toJson());
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                value[0].position.latitude,
                value[0].position.longitude,
              ),
              zoom: 20.0,
            ),
          ),
        );
        setState(
          () {
            selectedPosition = LatLng(
              value[0].position.latitude,
              value[0].position.longitude,
            );
          },
        );
        print(value[0].position.latitude);
        print(value[0].position.longitude);
      },
    );
  }
}
