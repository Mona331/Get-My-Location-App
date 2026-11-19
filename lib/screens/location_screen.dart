import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String latitude = 'Unknown';
  String longitude = 'Unknown';
  String accuracy = 'Unknown';

  String message = 'Press the button to get your location';

  bool isLoading = false;
  final LocationService locationService = LocationService();

  Future<void> getLocation() async {
    setState(() {
      isLoading = true;
      message = 'Getting location...';
    });

    try {
      bool hasPermission = await locationService.checkLocationPermission();

      if (!hasPermission) {
        setState(() {
          message = 'Location permission is required';
          isLoading = false;
        });
        return;
      }

      Position position = await locationService.getCurrentLocation();

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        accuracy = position.accuracy.toString();

        message = 'Location found successfully';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        message = 'Error getting location: $e';
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('My Location',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on,size: 80,color: Colors.blue,),
            SizedBox(height: 20,),
            Text('Find Your Current Location',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: isLoading ? null : getLocation,
             child: Text('Get My Location')),
             const SizedBox(height: 20),

            if (isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 20),

            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 25),

            Text('Latitude: $latitude'),

            Text('Longitude: $longitude'),

            Text('Accuracy: $accuracy meters'),
          ],
        ),
      ),
    );
  }
}