import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'time_record_bloc.dart';
import 'time_record_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeRecordScreen extends StatefulWidget {
  final String adId;

  const TimeRecordScreen({Key? key, required this.adId}) : super(key: key);

  @override
  _TimeRecordScreenState createState() => _TimeRecordScreenState();
}

class _TimeRecordScreenState extends State<TimeRecordScreen> {
  final Location _location = Location();
  bool _isArrived = false;
  bool _isDeparted = false;
  String _arrivalTimeText = "00:00";
  String _departureTimeText = "00:00";
  String _totalWorkedTimeText = "00:00";
  late DateTime _arrivalTime;
  late DateTime _departureTime;
  LatLng _adLocation = LatLng(47.90466852584394, 106.93507607116426); // Default location
  LatLng? _userLocation;
  MapController _mapController = MapController(); // Add MapController

  @override
  void initState() {
    super.initState();
    _listenToLocationChanges();
    _fetchAdLocation(); // Fetch the ad location when the screen is initialized
  }

  // Fetch the ad location from Firestore using the adId
  void _fetchAdLocation() async {
    try {
      final adDoc = await FirebaseFirestore.instance.collection('ad').doc(widget.adId).get();
      if (adDoc.exists) {
        final data = adDoc.data();
        final lat = data?['latitude']; // Fetch latitude from Firestore
        final lon = data?['longitude']; // Fetch longitude from Firestore

        if (lat != null && lon != null) {
          setState(() {
            _adLocation = LatLng(lat, lon); // Update _adLocation with fetched coordinates
          });

          // Center the map on the fetched ad location
          _mapController.move(_adLocation, 15.0); // Move map to the new location with zoom
        } else {
          print("Latitude or longitude is missing in Firestore for adId: ${widget.adId}");
        }
      } else {
        print("Ad document does not exist for adId: ${widget.adId}");
      }
    } catch (e) {
      print("Error fetching ad location: $e");
    }
  }

  // Listen to location changes and update _userLocation
  void _listenToLocationChanges() async {
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    });
  }

  // Check if the user is within 700 meters of the ad location and mark as arrived
  void _checkArrival() async {
    if (_isArrived || _userLocation == null) return;
    final Distance distance = Distance();
    double distanceInMeters = distance.as(LengthUnit.Meter, _userLocation!, _adLocation);

    if (distanceInMeters <= 700) {
      setState(() {
        _isArrived = true;
        _arrivalTime = DateTime.now();
        _arrivalTimeText = "${_arrivalTime.hour}:${_arrivalTime.minute}";
      });

      BlocProvider.of<TimeRecordBloc>(context).add(ArriveEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are not within 700 meters of the location.")),
      );
    }
  }

  // Check if the user is within 700 meters of the ad location and mark as departed
  void _checkDeparture() async {
    if (!_isArrived || _isDeparted) return;
    final Distance distance = Distance();
    double distanceInMeters = distance.as(LengthUnit.Meter, _userLocation!, _adLocation);

    if (distanceInMeters <= 700) {
      setState(() {
        _isDeparted = true;
        _departureTime = DateTime.now();
        _departureTimeText = "${_departureTime.hour}:${_departureTime.minute}";

        final workedDuration = _departureTime.difference(_arrivalTime);
        _totalWorkedTimeText =
        "${workedDuration.inHours}ц ${workedDuration.inMinutes.remainder(60)}мин";
      });

      BlocProvider.of<TimeRecordBloc>(context).add(DepartEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are not within 700 meters of the location.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => TimeRecordBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60), // Space for the back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.timer, color: Colors.orange),
                        Text(
                          _arrivalTimeText,
                          style: textTheme.titleMedium?.copyWith(color: Colors.black),
                        ),
                        Text("Ирц", style: textTheme.bodySmall),
                        Text(_departureTimeText, style: textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FlutterMap(
                        mapController: _mapController, // Attach the MapController
                        options: MapOptions(
                          center: _adLocation, // Ensure the map starts at _adLocation
                          zoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: _adLocation,
                                color: Colors.blue.withOpacity(0.3),
                                borderStrokeWidth: 2,
                                borderColor: Colors.blue,
                                radius: 100,
                              ),
                            ],
                          ),
                          if (_userLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 30.0,
                                  height: 30.0,
                                  point: _userLocation!,
                                  builder: (ctx) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: Icon(Icons.circle,
                                        color: Colors.white, size: 15),
                                  ),
                                ),
                              ],
                            ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 30.0,
                                height: 30.0,
                                point: _adLocation,
                                builder: (ctx) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Icon(Icons.circle,
                                      color: Colors.white, size: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTimeInfo(_arrivalTimeText, "Ирсэн", textTheme),
                          _buildTimeInfo(_departureTimeText, "Явсан", textTheme),
                          _buildTimeInfo("00:03", "Хоцорсон", textTheme),
                          _buildTimeInfo(_totalWorkedTimeText, "Нийт", textTheme),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isArrived ? null : _checkArrival,
                            child: Text("Ирсэн",
                                style: textTheme.labelLarge?.copyWith(color: Colors.white)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainerHighest,
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isDeparted ? null : _checkDeparture,
                            child: Text("Явсан",
                                style: textTheme.labelLarge?.copyWith(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String time, String label, TextTheme textTheme) {
    return Column(
      children: [
        Text(time, style: textTheme.titleMedium),
        Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'time_record_bloc.dart';
import 'time_record_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeRecordScreen extends StatefulWidget {
  final String adId;

  const TimeRecordScreen({Key? key, required this.adId}) : super(key: key);

  @override
  _TimeRecordScreenState createState() => _TimeRecordScreenState();
}

class _TimeRecordScreenState extends State<TimeRecordScreen> {
  final Location _location = Location();
  bool _isArrived = false;
  bool _isDeparted = false;
  String _arrivalTimeText = "00:00";
  String _departureTimeText = "00:00";
  String _totalWorkedTimeText = "00:00";
  late DateTime _arrivalTime;
  late DateTime _departureTime;
  LatLng _adLocation = LatLng(47.90466852584394, 106.93507607116426); // Default location
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _listenToLocationChanges();
    _fetchAdLocation(); // Fetch the ad location when the screen is initialized
  }

  void _fetchAdLocation() async {
    // Fetch the ad data from Firestore using the adId
    try {
      final adDoc = await FirebaseFirestore.instance.collection('ads').doc(widget.adId).get();
      if (adDoc.exists) {
        final data = adDoc.data();
        // Get the latitude and longitude from the Firestore document
        final lat = data?['latitude'];
        final lon = data?['longitude'];
        if (lat != null && lon != null) {
          setState(() {
            _adLocation = LatLng(lat, lon); // Update the adLocation with fetched coordinates
          });
        }
      }
    } catch (e) {
      print("Error fetching ad location: $e");
    }
  }

  void _listenToLocationChanges() async {
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    });
  }

  void _checkArrival() async {
    if (_isArrived || _userLocation == null) return;
    final Distance distance = Distance();
    double distanceInMeters =
    distance.as(LengthUnit.Meter, _userLocation!, _adLocation);

    if (distanceInMeters <= 700) {
      setState(() {
        _isArrived = true;
        _arrivalTime = DateTime.now();
        _arrivalTimeText = "${_arrivalTime.hour}:${_arrivalTime.minute}";
      });

      BlocProvider.of<TimeRecordBloc>(context).add(ArriveEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are not within 700 meters of the location.")),
      );
    }
  }

  void _checkDeparture() async {
    if (!_isArrived || _isDeparted) return;
    final Distance distance = Distance();
    double distanceInMeters =
    distance.as(LengthUnit.Meter, _userLocation!, _adLocation);

    if (distanceInMeters <= 700) {
      setState(() {
        _isDeparted = true;
        _departureTime = DateTime.now();
        _departureTimeText = "${_departureTime.hour}:${_departureTime.minute}";

        final workedDuration = _departureTime.difference(_arrivalTime);
        _totalWorkedTimeText =
        "${workedDuration.inHours}ц ${workedDuration.inMinutes.remainder(60)}мин";
      });

      BlocProvider.of<TimeRecordBloc>(context).add(DepartEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are not within 700 meters of the location.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => TimeRecordBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60), // Space for the back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.timer, color: Colors.orange),
                        Text(
                          _arrivalTimeText,
                          style: textTheme.titleMedium
                              ?.copyWith(color: Colors.black),
                        ),
                        Text("Ирц", style: textTheme.bodySmall),
                        Text(_departureTimeText, style: textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FlutterMap(
                        options: MapOptions(
                          center: _userLocation ?? _adLocation,
                          zoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: _adLocation,
                                color: Colors.blue.withOpacity(0.3),
                                borderStrokeWidth: 2,
                                borderColor: Colors.blue,
                                radius: 100,
                              ),
                            ],
                          ),
                          if (_userLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 30.0,
                                  height: 30.0,
                                  point: _userLocation!,
                                  builder: (ctx) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: Icon(Icons.circle,
                                        color: Colors.white, size: 15),
                                  ),
                                ),
                              ],
                            ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 30.0,
                                height: 30.0,
                                point: _adLocation,
                                builder: (ctx) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Icon(Icons.circle,
                                      color: Colors.white, size: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTimeInfo(_arrivalTimeText, "Ирсэн", textTheme),
                          _buildTimeInfo(
                              _departureTimeText, "Явсан", textTheme),
                          _buildTimeInfo("00:03", "Хоцорсон", textTheme),
                          _buildTimeInfo(
                              _totalWorkedTimeText, "Нийт", textTheme),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isArrived ? null : _checkArrival,
                            child: Text("Ирсэн",
                                style: textTheme.labelLarge
                                    ?.copyWith(color: Colors.white)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              minimumSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isDeparted ? null : _checkDeparture,
                            child: Text("Явсан",
                                style: textTheme.labelLarge
                                    ?.copyWith(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String time, String label, TextTheme textTheme) {
    return Column(
      children: [
        Text(time, style: textTheme.titleMedium),
        Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }
}*/
