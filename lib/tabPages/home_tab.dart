import 'dart:async';

import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/models/driver_data.dart';
import 'package:drivers_app/push_notifications/push_notification_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistant_methods.dart';
import '../assistants/black_theme_google_map.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            driverCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);

    AssistantMethods.readDriverEarnings(context);
  }

  readCurrentDriverInformation() async {
    // print(fAuth.currentUser);
    currentFirebaseUser = fAuth.currentUser;

    var dat = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((value) {
      //  var dat = value.snapshot.value;
      var dat = (value.snapshot.value as Map)["id"];
      print("${dat}111");
    });
    // FirebaseAnimatedList(
    //   query: FirebaseDatabase.instance
    //       .ref()
    //       .child("drivers")
    //       .child(currentFirebaseUser!.uid),
    //   itemBuilder: (context, snapshot, animation, index) {},
    // );
    print(111);
    // print(dat.toString() + "drivers11");
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.car_color =
            (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_model =
            (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number =
            (snap.snapshot.value as Map)["car_details"]["car_number"];

        driverVehicleType = (snap.snapshot as Map)["car_details"]["type"];

        print("Car Details: ");
        print(onlineDriverData.car_color);
        print(onlineDriverData.car_model);
        print(onlineDriverData.car_number);
      }
    });
    // print("Car Details: ");
    // print(onlineDriverData.id.toString() + "drivers11");
    // print(onlineDriverData.name.toString() + "drivers11");
    // print(onlineDriverData.email.toString() + "drivers11");
    // print(onlineDriverData.phone.toString() + "drivers11");

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();

    AssistantMethods.readDriverEarnings(context);
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            //black theme google map
            blackThemeGoogleMap(newGoogleMapController);

            locateDriverPosition();
          },
        ),

        //ui for online offline driver
        statusText != "Now Online"
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black54,
              )
            : Container(),

        //button for online offline driver
        Positioned(
          top: statusText != "Now Online"
              ? MediaQuery.of(context).size.height * 0.50
              : 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isDriverActive != true) //offline
                  {
                    driverIsOnlineNow();
                    updateDriversLocationAtRealTime();

                    setState(() {
                      statusText = "Now Online";
                      isDriverActive = true;
                      buttonColor = Colors.blueAccent;
                    });
                    //display Toast
                    Fluttertoast.showToast(msg: "you are Online Now");
                  } else //if online when click the button its make offline
                  {
                    driverIsOfflineNow();
                    setState(() {
                      statusText = "Now Offline";
                      isDriverActive = false;
                      buttonColor = Colors.blueAccent;
                    });
                    //display Toast
                    Fluttertoast.showToast(msg: "you are Offline Now");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: statusText != "Now Online"
                    ? Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.phonelink_ring,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");

    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.set("idle"); //searching for ride request
    ref.onValue.listen((event) {});
  }

  updateDriversLocationAtRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      if (isDriverActive == true) {
        Geofire.setLocation(currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
          driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(const Duration(milliseconds: 2000), () {
      //SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      SystemNavigator.pop();
      //Navigator.push(context, MaterialPageRoute(builder: (c)=>  MySplashScreen()));
    });
  }
}
