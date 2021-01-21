import 'package:Places/screens/map_screen.dart';
import 'package:Places/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPosition;

  LocationInput(
    this.onSelectPosition,
  );

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _setMapImage(LatLng position) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _setMapImage(LatLng(locData.latitude, locData.longitude));
    } catch (e) {
      return;
    }
  }

  Future<void> _getCustomLocation() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(),
      ),
    );

    if (selectedLocation == null) return;
    _setMapImage(selectedLocation);
    widget.onSelectPosition(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text('No location found!')
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select'),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCustomLocation,
            ),
          ],
        ),
      ],
    );
  }
}
