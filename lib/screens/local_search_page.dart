import 'dart:convert';
import 'package:app/models/google_map_model.dart';
import 'package:app/models/latlngback.dart';
import 'package:app/models/map_box_model.dart';
import 'package:app/models/may_by_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:http/http.dart';
import 'package:app/models/businessLayer/global.dart' as global;

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<StatefulWidget> createState() {
    return SearchLocationState();
  }
}

class SearchLocationState extends State<SearchLocation> {
  var http = Client();
  bool isLoading = false;
  bool isDispose = false;
  GoogleMapsPlaces? places;
  GeoCoding? placesSearch;
  List<PlacesSearchResult> searchPredictions = [];
  List<MapBoxPlace> placePred = [];
  late PlacesSearchResult pPredictions;
  late MapBoxPlace mapboxPredictions;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() async {
      if(!isDispose){
        if (searchController.text.isNotEmpty) {
          if (places != null) {
            await places!.searchByText(searchController.text).then((value) {
              if (searchController.text.isNotEmpty && mounted) {
                setState(() {
                  searchPredictions.clear();
                  searchPredictions = List.from(value.results);
                  debugPrint(value.results[0].formattedAddress);
                  debugPrint(
                      '${value.results[0].geometry!.location.lat} ${value.results[0].geometry!.location.lng}');
                });
              } else {
                if(mounted){
                  setState(() {
                    searchPredictions.clear();
                  });
                }
              }
            }).catchError((e) {
              if(mounted){
                setState(() {
                  searchPredictions.clear();
                });
              }
            });
          } else if (placesSearch != null) {
            placesSearch!.getPlaces(searchController.text).then((value) {
              if (searchController.text.isNotEmpty && mounted) {
                setState(() {
                  placePred.clear();
                  if(value.success != null) {
                    placePred = value.success!;
                    debugPrint(value.success![0].placeName);
                    debugPrint(
                        '${value.success![0].geometry!.coordinates.lat} ${value.success![0].geometry!.coordinates.long}');
                  }
                });
              } else {
                if(mounted){
                  setState(() {
                    placePred.clear();
                  });
                }
              }
            }).catchError((e) {
              if(mounted){
                setState(() {
                  placePred.clear();
                });
              }
            });
          }
        }
        else {
          if (places != null && mounted) {
            setState(() {
              searchPredictions.clear();
            });
          } else if (placesSearch != null && mounted) {
            setState(() {
              placePred.clear();
            });
          }
        }
      }
    });
    getMapbyApi();
  }
  
//   void hitMapby(){
//     setState(() {
//       isLoading = true;
//     });
//     http.get(mapByApi).then((value){
//       debugPrint(value.body);
// if(value.statusCode ==200){
//   MapByApi mapby = MapByApi.fromJson(jsonDecode(value.body));
//   if('${mapby.mapstatus}'=='1'){
//     debugPrint('gmap - ${mapby.key}');
//     setState(() {
//       places = new GoogleMapsPlaces(apiKey:'${mapby.key}');
//     });
//   }else if('${mapby.mapstatus}'=='2'){
//     debugPrint('mmap - ${mapby.key}');
//     setState(() {
//       placesSearch = PlacesSearch(apiKey: '${mapby.key}', limit: 10,);
//     });
//   }else{
//     debugPrint('demomap');
//   }
// }
//       if(!isDispose){
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }).catchError((e){
//       if(!isDispose){
//         setState(() {
//           isLoading = false;
//         });
//       }
//     });
//   }

  void getMapbyApi() async {
    setState(() {
      isLoading = true;
    });
    http.get(Uri.parse("${global.baseUrl}mapby")).then((value) {
      debugPrint(value.body);
      if (value.statusCode == 200) {
        MapByModel googleMapD = MapByModel.fromJson(jsonDecode(value.body));
        if ('${googleMapD.data!.mapbox}' == '1') {
          getMapBoxKey();
        } else if ('${googleMapD.data!.googleMap}' == '1') {
          getGoogleMapKey();
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void getGoogleMapKey() async {
    http.get(Uri.parse("${global.baseUrl}google_map")).then((value) {
      debugPrint(value.body);
      if (value.statusCode == 200) {
        var valued = jsonDecode(value.body);
        GoogleMapModel googleMapD = GoogleMapModel.fromJson(valued['data']);
        debugPrint(googleMapD.toString());
        setState(() {
          places = GoogleMapsPlaces(apiKey: '${googleMapD.mapApiKey}');
        });
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void getMapBoxKey() async {
    http.get(Uri.parse("${global.baseUrl}mapbox")).then((value) {
      if (value.statusCode == 200) {
        var valued = jsonDecode(value.body);
        MapBoxModel googleMapD = MapBoxModel.fromJson(valued['data']);
        setState(() {
          placesSearch = GeoCoding(
            apiKey: '${googleMapD.mapboxApi}',
            limit: 5,
          );
        });
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }
  
  @override
  void dispose() {
    http.close();
    isDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            'Search your location',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black.withOpacity(0.8)),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 52,
            margin: const EdgeInsets.only(left: 20,right: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              readOnly: isLoading,
              decoration: InputDecoration(
                hintText: 'Search your location',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              
              controller: searchController,
              // onEditingComplete: (){
              //   if(searchController.text!=null && searchController.text.length<=0){
              //     debugPrint('leg');
              //   }
              // },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  Visibility(
                    visible: (searchPredictions.isNotEmpty),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 5),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: ListView.separated(
                        itemCount: searchPredictions.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                pPredictions = searchPredictions[index];
                              });
                              Navigator.pop(
                                  context,
                                  BackLatLng(pPredictions.geometry!.location.lat,
                                      pPredictions.geometry!.location.lng,searchPredictions[index].formattedAddress));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height:10,
                                  width: 10,
                                  child: Image.asset(
                                    'assets/map_pin.png',
                                    scale: 3,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${searchPredictions[index].formattedAddress}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            thickness: 1,
                            color: Colors.black45,
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (placePred.isNotEmpty),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 5),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: ListView.separated(
                        itemCount: placePred.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                mapboxPredictions = placePred[index];
                              });
                              Navigator.pop(
                                  context,
                                  BackLatLng(
                                      mapboxPredictions.geometry!.coordinates.lat,
                                      mapboxPredictions.geometry!.coordinates.long,
                                      placePred[index].placeName));
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height:10,
                                  width: 10,
                                  child: Image.asset(
                                    'images/map_pin.png',
                                    scale: 3,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${placePred[index].placeName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            thickness: 1,
                            color: Colors.black45,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
