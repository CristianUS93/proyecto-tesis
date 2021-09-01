import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tesis_app/models/directions_repository.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_tesis_app/models/directions_model.dart';

// ignore: must_be_immutable
class MapPage extends StatefulWidget {
  String nameService;
  Position initPosition;
  LatLng finalPosition;
  MapPage(
      {@required this.initPosition,
      @required this.finalPosition,
      @required this.nameService});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Marker _from;
  Marker _to;
  Directions _info;

  @override
  void initState() {
    _createMarkers(widget.finalPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nameService,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.initPosition.latitude, widget.initPosition.longitude),
              zoom: 15.0,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              double miny = (widget.initPosition.latitude <=
                      widget.finalPosition.latitude)
                  ? widget.initPosition.latitude
                  : widget.finalPosition.latitude;
              double minx = (widget.initPosition.longitude <=
                      widget.finalPosition.longitude)
                  ? widget.initPosition.longitude
                  : widget.finalPosition.longitude;
              double maxy = (widget.initPosition.latitude <=
                      widget.finalPosition.latitude)
                  ? widget.finalPosition.latitude
                  : widget.initPosition.latitude;
              double maxx = (widget.initPosition.longitude <=
                      widget.finalPosition.longitude)
                  ? widget.finalPosition.longitude
                  : widget.initPosition.longitude;

              double southWestLatitude = miny;
              double southWestLongitude = minx;

              double northEastLatitude = maxy;
              double northEastLongitude = maxx;

              controller.animateCamera(
                CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                    northeast: LatLng(northEastLatitude, northEastLongitude),
                    southwest: LatLng(southWestLatitude, southWestLongitude),
                  ),
                  100.0,
                ),
              );
            },
            markers: {if (_from != null) _from, if (_to != null) _to},
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: PolylineId("polyline_route"),
                  color: Color(0xffb71c1c),
                  width: 3,
                  points: _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
          ),
        ],
      ),
    );
  }

  void _createMarkers(LatLng latLng) async {
    setState(() {
      _from = Marker(
        markerId: MarkerId("origin"),
        infoWindow: InfoWindow(title: "Origen"),
        position:
            LatLng(widget.initPosition.latitude, widget.initPosition.longitude),
      );

      _to = Marker(
        markerId: MarkerId("destination"),
        infoWindow: InfoWindow(
          title: widget.nameService,
          snippet:
              "${widget.initPosition.latitude}, ${widget.initPosition.longitude}",
        ),
        position: latLng,
      );
    });

    final directions = await DirectionsRepository()
        .getDirections(origin: _from.position, destination: _to.position);
    setState(() {
      _info = directions;
    });
  }
}
