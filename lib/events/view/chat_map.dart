import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/icons.dart';

import '../../common/uri_x.dart';
import '../../common/view/ui_constants.dart';
import '../../l10n/l10n.dart';
import '../../common/chat_model.dart';
import '../../common/event_x.dart';

class ChatMap extends StatelessWidget {
  const ChatMap({
    super.key,
    required this.event,
    required this.partOfMessageCohort,
    required this.timeline,
    required this.onReplyOriginClick,
  });

  final Event event;
  final bool partOfMessageCohort;
  final Timeline timeline;
  final Future<void> Function(Event) onReplyOriginClick;

  @override
  Widget build(BuildContext context) {
    final geoUri = event.geoUri;
    if (geoUri != null && geoUri.scheme == 'geo') {
      final latlong = geoUri.latLong;
      if (latlong.length == 2 && latlong.none((e) => e == null)) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: kMediumPadding,
          children: [
            Map(
              isUserMessage: event.senderId == di<ChatModel>().myUserId,
              latitude: latlong.first!,
              longitude: latlong.last!,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                icon: const Icon(YaruIcons.location),
                onPressed: () {
                  final maybeUri = Uri.tryParse(event.body);
                  if (maybeUri != null) {
                    launchUrl(maybeUri);
                  }
                },
                label: Text(context.l10n.openInMaps),
              ),
            ),
          ],
        );
      }
    }

    return Text(event.body);
  }
}

class Map extends StatelessWidget {
  const Map({
    required this.latitude,
    required this.longitude,
    this.zoom = 14.0,
    this.width = 400,
    this.height = 400,
    this.radius = 10.0,
    required this.isUserMessage,
    super.key,
  });

  final double latitude;
  final double longitude;
  final double zoom;
  final double width;
  final double height;
  final double radius;
  final bool isUserMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        constraints: BoxConstraints.loose(Size(width, height)),
        child: AspectRatio(
          aspectRatio: width / height,
          child: Stack(
            children: <Widget>[
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(latitude, longitude),
                  initialZoom: zoom,
                ),
                children: [
                  TileLayer(
                    maxZoom: 20,
                    minZoom: 0,
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    rotate: true,
                    markers: [
                      Marker(
                        point: LatLng(latitude, longitude),
                        width: 30,
                        height: 30,
                        child: Transform.translate(
                          offset: const Offset(0, -12.5),
                          child: const Icon(
                            YaruIcons.location,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(
                  ' © OpenStreetMap contributors ',
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    backgroundColor: theme.appBarTheme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
