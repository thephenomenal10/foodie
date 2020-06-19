import 'package:flutter/material.dart';
import 'package:foodieapp/vendors/constants/constants.dart';
// import 'package:foodieapp/vendors/screens/createTiffenCentre.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodieapp/vendors/widgets/globalVariable.dart' as global;

class CustomerAddressNavigate extends StatefulWidget {
  final List<dynamic> customerAddress;

  const CustomerAddressNavigate({Key key, this.customerAddress})
      : super(key: key);

  @override
  CustomerAddressNavigateState createState() => CustomerAddressNavigateState();
}

class CustomerAddressNavigateState extends State<CustomerAddressNavigate> {
  GoogleMapController mapController;
  String searchAddr;
  final Set<Marker> _marker = {};

  @override
  void initState() {
    searchNavigate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Find your customer"),
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
              bottom: 30,
              left: 30,
              child: FloatingActionButton.extended(
                label: Text(
                  'Find',
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                backgroundColor: myGreen,
                onPressed: () {
                  searchNavigate();
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
    print(widget.customerAddress);
    Geolocator()
        .placemarkFromCoordinates(
            widget.customerAddress[0], widget.customerAddress[1])
        // Geolocator().placemarkFromAddress(widget.customerAddress)
        .then((value) {
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
          infoWindow: InfoWindow(
            title: "tap on direction button",
            // snippet: widget.customerAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
        global.localityAddress = widget.customerAddress.toString();
        global.tiffenCentreLatitude = value[0].position.latitude.toDouble();
        global.tiffenCentreLongitude = value[0].position.longitude.toDouble();
        print(value[0].position.latitude);
        print(value[0].position.longitude);
      });
    });
  }
}
