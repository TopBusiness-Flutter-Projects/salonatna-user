import 'dart:async';
import 'dart:math';

import 'package:app/models/barber_shop_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/latlngback.dart';
import 'package:app/screens/barber_shop_description_screen.dart';
import 'package:app/screens/local_search_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_api_headers/google_api_headers.dart';

final searchScaffoldKey = GlobalKey<ScaffoldState>();

class LocationScreen extends BaseRoute {
  final int? screenId;
  const LocationScreen({super.key, super.a, super.o, this.screenId}) : super(r: 'LocationScreen');
  @override
  BaseRouteState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends BaseRouteState<LocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  List<BarberShop>? _barberShopList = [];
  bool _isBarberShopDataLoaded = false;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late double _lat;
  late double _lng;
  final TextEditingController _cSearch = TextEditingController();

  final FocusNode _fSearch = FocusNode();
  bool _isDataLoaded = false;
  bool _isShowConfirmLocationWidget = false;
  late Placemark setPlace;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  _LocationScreenState() : super();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return PopScope(
        canPop: false,
        child: sc(
          Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 13),
                  child: Card(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFFEA00),
                      enabled: true,
                      readOnly: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cSearch,
                      focusNode: _fSearch,
                      onFieldSubmitted: (text) async {},
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                        ),
                        suffixIcon: Container(
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: const Color(0xFFFFEA00), borderRadius: BorderRadius.circular(5)),
                          child: const FaIcon(
                            FontAwesomeIcons.locationArrow,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                        hintText: global.currentLocation,
                      ),
                      onTap: () async {
                        //
                        // if(global.isGoogleMap){
                        //   Navigator.of(context).push(
                        //     MaterialPageRoute(builder: (context) => CustomSearchScaffold()),
                        //   ).then((value) async{
                        //     if(value!=null){
                        //       _cSearch.text = '${value[2]}';
                        //       _lat = double.parse('${value[0]}');
                        //       _lng = double.parse('${value[1]}');
                        //       showOnlyLoaderDialog();
                        //       final GoogleMapController controller = await _controller.future;
                        //       await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
                        //       await _updateMarker(_lat, _lng).then((_) async {
                        //         List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
                        //         setPlace = placemarks[0];
                        //         hideLoader();
                        //         _isShowConfirmLocationWidget = true;
                        //         setState(() {});
                        //       });
                        //       setState(() {});
                        //     }
                        //   });
                        // }
                        // else{
                        // }
                        // searchLocation();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchLocation())).then((value) async {
                          if(value!=null){
                            BackLatLng backLatLng = value;
                            _cSearch.text = backLatLng.address;
                            _lat = double.parse('${backLatLng.lat}');
                            _lng = double.parse('${backLatLng.lng}');
                            global.lat = '$_lat';
                            global.lng = '$_lng';
                            showOnlyLoaderDialog();
                            final GoogleMapController controller = await _controller.future;
                            await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
                            await _updateMarker(_lat, _lng).then((_) async {
                              List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
                              setPlace = placemarks[0];
                              hideLoader();
                              _isShowConfirmLocationWidget = true;
                              setState(() {});
                            });
                            setState(() {});
                          }
                        });
                      },
                    ),
                  ),
                )),
            body: _isDataLoaded
                ? Stack(
                    children: [
                      GoogleMap(
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_lat, _lng),
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          setState(() {});
                        },
                        markers: Set<Marker>.from(markers),
                        onTap: (latLng) async {
                          _lat = latLng.latitude;
                          _lng = latLng.longitude;
                          final GoogleMapController controller = await _controller.future;
                          controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
                          await _updateMarker(_lat, _lng).then((value) async {
                            List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
                            setPlace = placemarks[0];
                            _isShowConfirmLocationWidget = true;
                            setState(() {});
                          });
                          setState(() {});
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25, left: 8, right: 8),
                        child: Align(alignment: Alignment.bottomCenter, child: SizedBox(height: _isShowConfirmLocationWidget ? 170 : 83, child: _isShowConfirmLocationWidget ? _setCurrentLocationWidget() : _nearBySalonsWidget())),
                      )
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ));
  }


  @override
  void initState() {
    super.initState();
    _lat = double.parse(global.lat!);
    _lng = double.parse(global.lng!);

    _init();
  }

  // searchLocation() async{
  //   debugPrint('Is Google -> ${global.isGoogleMap}');
  //     try {
  //       return sc(
  //         autoCmplt.MapBoxAutoCompleteWidget(
  //           apiKey: global.mapBoxModel.mapbox_api,
  //           hint: AppLocalizations.of(context).lbl_type_a_place,
  //           onSelect: (place) async {
  //             _cSearch.text = place.placeName;
  //             d.Location location = await _placesSearch(_cSearch.text);
  //             _lat = location.latitude;
  //             _lng = location.longitude;
  //             showOnlyLoaderDialog();
  //             final GoogleMapController controller = await _controller.future;
  //             await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
  //             await _updateMarker(_lat, _lng).then((_) async {
  //               List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
  //               setPlace = placemarks[0];
  //               hideLoader();
  //               _isShowConfirmLocationWidget = true;
  //               setState(() {});
  //             });
  //             setState(() {});
  //           },
  //           limit: 5,
  //         ),
  //       );
  //     } catch (e) {
  //       debugPrint("Exception - location_screen.dart - searchLocation():" + e.toString());
  //     }
  // }

  _getNearByBarberShops() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getNearByBarberShops(global.lat, global.lng, 1).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _barberShopList = result.recordList;
            } else {
              
            }
          }
          _isBarberShopDataLoaded = true;

          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - location_screen.dart - _getNearByBarberShops():$e");
    }
  }

  _init() async {
    try {
      if (widget.screenId == 1) {
        Future.delayed(Duration.zero, () async {
          if(!mounted) return;
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchLocation())).then((value) async{
            if(value != null){
              BackLatLng backLatLng = value;
              _cSearch.text = backLatLng.address;
              _lat = double.parse('${backLatLng.lat}');
              _lng = double.parse('${backLatLng.lng}');
              showOnlyLoaderDialog();
              final GoogleMapController controller = await _controller.future;
              await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
              await _updateMarker(_lat, _lng).then((_) async {
                List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
                setPlace = placemarks[0];
                hideLoader();
                _isShowConfirmLocationWidget = true;
                setState(() {});
              });
              setState(() {});
            }
          });
          // if(global.isGoogleMap){
          //   Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => CustomSearchScaffold()),
          //   ).then((value) async{
          //     if(value!=null){
          //       _cSearch.text = '${value[2]}';
          //       _lat = double.parse('${value[0]}');
          //       _lng = double.parse('${value[1]}');
          //       showOnlyLoaderDialog();
          //       final GoogleMapController controller = await _controller.future;
          //       await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
          //       await _updateMarker(_lat, _lng).then((_) async {
          //         List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
          //         setPlace = placemarks[0];
          //         hideLoader();
          //         _isShowConfirmLocationWidget = true;
          //         setState(() {});
          //       });
          //       setState(() {});
          //     }
          //   });
          // }
          // else{
          //   await Navigator.push(context, MaterialPageRoute(builder: (context) => searchLocation()));
          // }
        });
      }

      await _getNearByBarberShops();
      _isDataLoaded = true;

      await _updateMarker(_lat, _lng);
    } catch (e) {
      debugPrint("Exception - location_screen.dart - _init():$e");
    }
  }

  _nearBySalonsWidget() {
    return _isBarberShopDataLoaded
        ? _barberShopList != null && _barberShopList!.isNotEmpty
            ? ListView.builder(
                itemCount: _barberShopList!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BarberShopDescriptionScreen(_barberShopList![index].vendorId, a: widget.analytics, o: widget.observer)),
                      );
                    },
                    child: SizedBox(
                      width: 350,
                      child: Card(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImage(
                              imageUrl: global.baseUrlForImage + _barberShopList![index].vendorLogo!,
                              imageBuilder: (context, imageProvider) => Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                              ),
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            Expanded(
                              child: ListTile(
                                horizontalTitleGap: 0,
                                contentPadding: const EdgeInsets.only(left: 5, right: 5),
                                isThreeLine: true,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_barberShopList![index].vendorName}',
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${_barberShopList![index].rating}', style: Theme.of(context).primaryTextTheme.bodyMedium),
                                        _barberShopList![index].rating != null
                                            ? RatingBar.builder(
                                          initialRating: _barberShopList![index].rating!,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 8,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          ignoreGestures: true,
                                          updateOnDrag: false,
                                          onRatingUpdate: (rating) {
                                          },
                                        )
                                            : const SizedBox()
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          size: 15,
                                        ),
                                        Text(
                                          '${_barberShopList![index].vendorPhone}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 15,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${_barberShopList![index].vendorLoc}',
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).primaryTextTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const SizedBox()
        : _shimmer();
  }
  _setCurrentLocationWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.txt_select_delivery_location,
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    '${setPlace.name}',
                    style: Theme.of(context).primaryTextTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Align(alignment: Alignment.centerLeft, child: Text("${setPlace.name!.trim()}, ${setPlace.locality}, ${setPlace.street}, ${setPlace.subAdministrativeArea}, ${setPlace.postalCode}")),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.lbl_confirm_location),
                ),
                onPressed: () async {
                  _isShowConfirmLocationWidget = false;
                  global.lat = _lat.toString();
                  global.lng = _lng.toString();
                  global.currentLocation = "${setPlace.name}, ${setPlace.locality} ";
                  await _getNearByBarberShops();
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return const Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Card(margin: EdgeInsets.only(top: 5, bottom: 5)),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              );
            }),
      ),
    );
  }

  Future<bool> _updateMarker(lat, lng) async {
    try {
      if (markers.isNotEmpty) markers.clear();
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      String startCoordinatesString = '($lat, $lng)';
      Marker startMarker = Marker(
          markerId: MarkerId(startCoordinatesString),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'samp ${place.name}, ${place.locality} ',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(0),
          onTap: () async {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(lat, lng),
                  tilt: 50.0,
                  bearing: 45.0,
                  zoom: 20.0,
                ),
              ),
            );
          });
      mapController = await _controller.future;
      markers.add(startMarker);

      return true;
    } catch (e) {
      debugPrint('MAP Exception - location_screen.dart - _updateMarker():$e');
    }
    return false;
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_debugPrintDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _debugPrintDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _debugPrintDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

Future<void> displayPrediction(Prediction p, BuildContext context) async {
  GoogleMapsPlaces places = GoogleMapsPlaces(
    apiKey: global.mapGBoxModel!.mapApiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders(),
  );
  PlacesDetailsResponse detail =
  await places.getDetailsByPlaceId(p.placeId!);
  final lat = detail.result.geometry!.location.lat;
  final lng = detail.result.geometry!.location.lng;
  final address = detail.result.formattedAddress;
  if(!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("${p.description} - $lat/$lng/$address")),
  );
  Navigator.of(context).pop([lat,lng,address]);
}


class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold({super.key})
      : super(
    apiKey: global.mapGBoxModel!.mapApiKey!,
    sessionToken: Uuid().generateV4(),
    language: "en",
    components: [const Component(Component.country, "uk")],
  );

  @override
  PlacesAutocompleteState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const AppBarPlacesAutoCompleteTextField(textDecoration: null, textStyle: null, cursorColor: null));
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, context);
      },
      logo: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [FlutterLogo()],
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response.predictions.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Got answer")),
      );
    }
  }
}