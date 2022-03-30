import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/firebase_operations.dart';
import 'package:location/history.view.dart';
import 'package:location/location.notifier.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(Provider.of<LocationNotifier>(context, listen: true)
            .lastMapPosition
            .toString()),
        position: Provider.of<LocationNotifier>(context, listen: false)
            .lastMapPosition,
        infoWindow: const InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    Provider.of<LocationNotifier>(context, listen: false).lastMapPosition =
        position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Timer? timer;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      int i = 0;
      timer = Timer.periodic(const Duration(seconds: 7), (Timer t) async {
        i = i + 1;
        await Provider.of<LocationNotifier>(context, listen: false)
            .getLocationLoop();
        await Provider.of<FirebaseOperations>(context, listen: false).addItem(
            lat: double.parse(
                Provider.of<LocationNotifier>(context, listen: false).lat),
            long: double.parse(
                Provider.of<LocationNotifier>(context, listen: false).long),
            address:
                Provider.of<LocationNotifier>(context, listen: false).address,
            date: Provider.of<LocationNotifier>(context, listen: false).date,
            i: i);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: Key("home"),
      appBar: AppBar(
        title: const Text('Maps Sample App'),
        backgroundColor: Colors.green[700],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            },
            child: const Text(
              "History",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: Provider.of<LocationNotifier>(context, listen: true)
                  .lastMapPosition,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 15, left: 20),
            height: size.height * 0.17,
            width: size.width * 0.9,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      offset: Offset(0, 2))
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    "Lat: ${Provider.of<LocationNotifier>(context, listen: true).lat}"),
                Text(
                    "Long: ${Provider.of<LocationNotifier>(context, listen: true).long}"),
                Text(
                    "Address: ${Provider.of<LocationNotifier>(context, listen: true).address}"),
                Text(
                    "Date: ${Provider.of<LocationNotifier>(context, listen: true).date}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
