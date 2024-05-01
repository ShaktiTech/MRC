import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mrc/bloc/drawer_bloc/drawer_bloc.dart';
import 'package:mrc/model/rain_fall_model.dart';
import 'package:mrc/model/water_quality_model.dart';
import 'package:mrc/utils/constant.dart';
import 'package:mrc/utils/example_popup.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:mrc/view/screens/weather_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:spritewidget/spritewidget.dart' as node;

import '../../repository/user_repositories.dart';
import 'drawer_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


// The image map hold all of our image assets.
late ImageMap _images;

// The sprite sheet contains an image and a set of rectangles defining the
// individual sprites.
late SpriteSheet _sprites;

enum WeatherType { sun, rain, snow }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 Future<void> _loadAssets(AssetBundle bundle) async {
    // Load images using an ImageMap
    _images = ImageMap();
    await _images.load(<String>[
      'assets/clouds-0.png',
      'assets/clouds-1.png',
      'assets/ray.png',
      'assets/sun.png',
      'assets/weathersprites.png',
      'assets/icon-sun.png',
      'assets/icon-rain.png',
      'assets/icon-snow.png'
    ]);

    // Load the sprite sheet, which contains snowflakes and rain drops.
    String json = await DefaultAssetBundle.of(context)
        .loadString('assets/weathersprites.json');
    _sprites = SpriteSheet(
      image: _images['assets/weathersprites.png']!,
      jsonDefinition: json,
    );
  }


  bool _isLoading = true;
  var markers = <Marker>[];
  var markers2 = <Marker>[];
  var markers3 = <Marker>[];
  PopupController _popupController = PopupController();
  bool _isPermitted = true;
  String userLocation = "";
  double userLate = 0.0;
  double userLong = 0.0;
  LatLng? _currentPosition;

  List dataInfo = [];
  late LatLng location;
  late LatLng location1;
  bool assetsLoaded = false;

  // The weather world is our sprite tree that handles the weather
  // animations.
  late WeatherWorldNew weatherWorld;






  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userLocation = prefs.getString("userLocation") ?? '----';
    userLate = prefs.getDouble("userLateD") ?? 0.0;
    userLong = prefs.getDouble("userLongD") ?? 0.0;
    _isLoading = false;
    // location = LatLng(userLate, userLong);

    //   markers.add(Marker(builder:(ctx) => Container(
    //         child: Icon(
    //           Icons.location_on,
    //           color: Colors.green[700],
    //           size: 50,
    //         ),
    //       ),
    // point: location

    // ));

    // userEmail = "SSS";
  }

  @override
  void initState() {
    // TODO: implement initState
 AssetBundle bundle = rootBundle;

    // Load all graphics, then set the state to assetsLoaded and create the
    // WeatherWorld sprite tree
    _loadAssets(bundle).then((_) {
      setState(() {
        assetsLoaded = true;
        weatherWorld = WeatherWorldNew();
      });
    });
 
    getData();
    getWaterQualityData();
    super.initState();
  }

  getData() async {
    final response = await http.get(
        Uri.parse(
            "https://www.mrcmekong.org/river-monitoring/v1/rainfall/rainfall-map.json"),
        headers: {
          // "Authorization": "Bearer ${AppUrl.authToken}",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      // var items = json.decode( response.body );//"[" ++ "]"
      var items = response.body;
      RainFallModel model = RainFallModelFromJson(items);
      print(" sss items ${model.features.length}");
      if (items != null) {
        for (var x = 0; x < model.features.length; x++) {
          location = LatLng(model.features[x].properties.latCo,
              model.features[x].properties.longCo);

          markers.add(Marker(
              builder: (ctx) => model.features[x].properties.mm > 90
                  ? UserMarker()
                  : GestureDetector(
                      onTap: () {
                        print("sss ontap");
                      },
                      child: Container(
                        child: Icon(
                          Icons.water_drop_rounded,
                          color: model.features[x].properties.mm > 90
                              ? Colors.red
                              : model.features[x].properties.mm > 35
                                  ? Colors.orange
                                  : model.features[x].properties.mm > 11
                                      ? Colors.yellow
                                      : model.features[x].properties.mm > 0
                                          ? Colors.blue
                                          : Colors.grey,
                          size: 15,
                        ),
                      ),
                    ),
              point: location));
        }
        setState(() {
          markers;
        });
      } else {}
    } else {}
  }

  getWaterQualityData() async {
    final response = await http.get(
        Uri.parse(
            "https://portal.mrcmekong.org/assets/data/water-quality/WQ-for-human-health.json"),
        headers: {
          // "Authorization": "Bearer ${AppUrl.authToken}",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      var items = json.decode(response.body); //"[" ++ "]"
      //var items = response.body;
      //  List<WaterQualityModel> model = waterQualityModelFromJson(items);

      List<WaterQualityModel> model = List<WaterQualityModel>.from(
          items.map((model) => WaterQualityModel.fromJson(model)));
      print(" sss WaterQualityModel ${model.length}");
      if (items != null) {
        for (var x = 0; x < model.length; x++) {
          double lat = model[x].lat ?? 0.0;
          double lon = model[x].lon ?? 0.0;
          location1 = LatLng(lat, lon); 

          markers2.add(Marker(
            builder: (ctx) => InkWell(
              onTap: () async {
                print("sss marker");
                showMyDialog(model[x]);
              },
              child: Container(
                child: Icon(
                  Icons.circle_rounded,
                  color: model[x].the2021 == "A"
                      ? Colors.blue
                      : model[x].the2021 == "B"
                          ? Colors.green
                          : model[x].the2021 == "C"
                              ? Colors.yellow
                              : model[x].the2021 == "D"
                                  ? Colors.orange
                                  : Colors.red,
                  size: 20,
                ),
              ),
            ),
            width: 60,
            height: 60,
            point: location1,
            rotate: true,
          ));
        }
        setState(() {
          markers2;
        });
      } else {}
    } else {}
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isLayer1 = false;
  bool _isLayer2 = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(), // <-- your future
        builder: (context, snapshot) {
          return Scaffold(
            key: _key,
            extendBodyBehindAppBar: true,
            drawer: RepositoryProvider(
              create: (context) =>
                  UserRepository(firebaseAuth: FirebaseAuth.instance),
              child: BlocProvider(
                create: (context) =>
                    DrawerBloc(userRepository: context.read<UserRepository>()),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
                  child: DrawerScreen(),
                ),
              ),
            ),
            endDrawer: RepositoryProvider(
              create: (context) =>
                  UserRepository(firebaseAuth: FirebaseAuth.instance),
              child: BlocProvider(
                create: (context) =>
                    DrawerBloc(userRepository: context.read<UserRepository>()),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
                  child: DrawerScreen(),
                ),
              ),
            ),
            appBar: AppBar(
                title: Text('Location'),
                actions: <Widget>[
                  new Container(),
                ],
                backgroundColor: Colors.transparent), //Color(0x44000000),
            body: Padding(
              padding: EdgeInsets.all(8.0),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: [
                        // SizedBox(height: 5,),
                        //   buildSourceField(),
                        //    SizedBox(height: 5,),
                       
                        FlutterMap(
                          options: MapOptions(
                            center: LatLng(18.042833732211516,
                                102.71605629054815), //LatLng(22.737615284636576, 75.9028809536729)
                            // center: LatLng(47.925812, 106.919831),
                            zoom: 5.0,
                            plugins: [EsriPlugin()],
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                 'https://api.mapbox.com/styles/v1/shaktischouhan/clp827tkw00m401qt7b7ie818/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hha3Rpc2Nob3VoYW4iLCJhIjoiY2t4NDc0b3YwMXNpcTJ4b2J3dHIzbzN4eSJ9.vc3Lwe-MffS5iiZ_aIeAtg',
                              additionalOptions: {
                                'accessToken':
                                    'pk.eyJ1Ijoic2hha3Rpc2Nob3VoYW4iLCJhIjoiY2xveTg3Mm1nMDF3ZDJrcDhjNmx6ZGViYyJ9.UpqUIwcNTRPMhSCeEn2RFA',
                                'id': 'mapbox.mapbox-streets-v'
                              },
                            ),

                            // TileLayerOptions(
                            //   urlTemplate:
                            //     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            //   subdomains: ['a', 'b', 'c'],

                            // ),
                            _isLayer1
                                ? MarkerLayerOptions(markers: markers)
                                : MarkerLayerOptions(markers: markers3),
                            _isLayer2
                                ? MarkerLayerOptions(markers: markers2)
                                : MarkerLayerOptions(markers: markers3),
                            //  MarkerLayerOptions(
                            //               markers: [

                            //                   Marker(
                            //                     point: LatLng(18.042833732211516, 102.71605629054815),
                            //                     width: 60,
                            //                     height: 60,
                            //                     builder: (context) {
                            //                       return const UserMarker();
                            //                     },
                            //                   ),
                            //               ],
                            //             ),
                          ],
                        ),
                     //    SpriteWidget(weatherWorld),
            //               Align(
            //   alignment: const FractionalOffset(0.5, 0.8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       WeatherButton(
            //         onPressed: () {
            //           setState(() {
            //             weatherWorld.weatherType = WeatherType.sun;
            //           });
            //         },
            //         selected: weatherWorld.weatherType == WeatherType.sun,
            //         icon: 'assets/icon-sun.png',
            //       ),
            //       WeatherButton(
            //         onPressed: () {
            //           setState(() {
            //             weatherWorld.weatherType = WeatherType.rain;
            //           });
            //         },
            //         selected: weatherWorld.weatherType == WeatherType.rain,
            //         icon: 'assets/icon-rain.png',
            //       ),
            //       WeatherButton(
            //         onPressed: () {
            //           setState(() {
            //             weatherWorld.weatherType = WeatherType.snow;
            //           });
            //         },
            //         selected: weatherWorld.weatherType == WeatherType.snow,
            //         icon: 'assets/icon-snow.png',
            //       ),
            //     ],
            //   ),
            // ),
         
                        // buildSourceField(),
                      ],
                    ),
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                          child: Text(
                            "Layers",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    FloatingActionButton(
                      onPressed: () {
                        _key.currentState!.openEndDrawer();
                      },
                      child: Icon(Icons.layers, color: Colors.blue),
                      backgroundColor: Colors.white,
                      heroTag: 'mapZoomIn',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(alignment: Alignment.centerRight, children: [
                  Container(
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                        child: Text(
                          "Home",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )),
                  FloatingActionButton(
                    onPressed: () {
                      if (_isLayer1) {
                        setState(() {
                          _isLayer1 = false;
                        });
                      } else {
                        setState(() {
                          _isLayer1 = true;
                        });
                      }
                    },
                    child: Icon(Icons.gps_fixed, color: Colors.blue),
                    backgroundColor: Colors.white,
                    heroTag: 'mapZoomOut',
                  ),
                ]),
                const SizedBox(
                  height: 5,
                ),
                Stack(alignment: Alignment.centerRight, children: [
                  Container(
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                        child: Text(
                          "Favorite",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )),
                  FloatingActionButton(
                    onPressed: () {
                      if (_isLayer2) {
                        setState(() {
                          _isLayer2 = false;
                        });
                      } else {
                        setState(() {
                          _isLayer2 = true;
                        });
                      }
                    },
                    child: Icon(Icons.heart_broken, color: Colors.blue),
                    backgroundColor: Colors.white,
                    heroTag: 'showUserLocation',
                  ),
                ]),
                const SizedBox(
                  height: 5,
                ),
                Stack(alignment: Alignment.centerRight, children: [
                  Container(
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                        child: Text(
                          "Flash & Drought",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )),
                  const FloatingActionButton(
                    onPressed: null,
                    child: Icon(Icons.cloudy_snowing, color: Colors.blue),
                    backgroundColor: Colors.white,
                    heroTag: 'mapGoToHome',
                  ),
                ])
              ],
            ),
            //  floatingActionButtonLocation: FloatingActionButtonLocation.,
          );
        });
  }

  showMyDialog(WaterQualityModel model) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.amber[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: SizedBox(
            height: 180,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model.stationName ?? "Station : "),
                    SizedBox(
                      width: 20,
                    ),
                    Text(model.stationName ?? "No Station Name"),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model.stationName ?? "Country : "),
                    SizedBox(
                      width: 20,
                    ),
                    Text(model.country ?? "No Country Name"),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model.stationName ?? "Year 2021 : "),
                    SizedBox(
                      width: 20,
                    ),
                    Text(model.the2021 ?? "No data"),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Okay"))
              ],
            ),
          ),
        );

        // AlertDialog(
        //   title:  Text(model.stationName??"No Station Name"),
        //   content: Container(
        //     height: 50,
        //     width: 70,
        //     child: Column(
        //       children:  <Widget>[
        //         Text(model.country??"No Country Name"),
        //         Text(model.the2021??"No data"),
        //       ],
        //     ),
        //   ),
        //   actions: <Widget>[
        //     TextButton(
        //       child: const Text('Approve'),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }
}

const List<Color> _kBackgroundColorsTop = <Color>[
  Color(0xff5ebbd5),
  Color(0xff0b2734),
  Color(0xffcbced7),
];

const List<Color> _kBackgroundColorsBottom = <Color>[
  Color(0xff4aaafb),
  Color(0xff4c5471),
  Color(0xffe0e3ec),
];

// The WeatherWorld is our root node for our sprite tree. The size of the tree
// will be scaled to fit into our SpriteWidget container.
class WeatherWorldNew extends NodeWithSize {
  WeatherWorldNew() : super(const Size(2048.0, 2048.0)) {
    // Start by adding a background.
    _background = GradientNode(
      size,
      _kBackgroundColorsTop[0],
      _kBackgroundColorsBottom[0],
    );
    addChild(_background);

    // Then three layers of clouds, that will be scrolled in parallax.
    _cloudsSharp = CloudLayer(
      image: _images['assets/clouds-0.png']!,
      rotated: false,
      dark: false,
      loopTime: 20.0,
    );
    addChild(_cloudsSharp);

    _cloudsDark = CloudLayer(
      image: _images['assets/clouds-1.png']!,
      rotated: true,
      dark: true,
      loopTime: 40.0,
    );
    addChild(_cloudsDark);

    _cloudsSoft = CloudLayer(
      image: _images['assets/clouds-1.png']!,
      rotated: false,
      dark: false,
      loopTime: 60.0,
    );
    addChild(_cloudsSoft);

    // Add the sun, rain, and snow (which we are going to fade in/out depending
    // on which weather are selected.
    _sun = Sun();
    _sun.position = const Offset(1024.0, 1024.0);
    _sun.scale = 1.5;
    addChild(_sun);

    _rain = Rain();
    addChild(_rain);

    _snow = Snow();
    addChild(_snow);
  }

  late GradientNode _background;
  late CloudLayer _cloudsSharp;
  late CloudLayer _cloudsSoft;
  late CloudLayer _cloudsDark;
  late Sun _sun;
  late Rain _rain;
  late Snow _snow;

  WeatherType get weatherType => _weatherType;

  WeatherType _weatherType = WeatherType.sun;

  set weatherType(WeatherType weatherType) {
    if (weatherType == _weatherType) return;

    // Handle changes between weather types.
    _weatherType = weatherType;

    // Fade the background
    _background.motions.stopAll();

    // Fade the background from one gradient to another.
    _background.motions.run(
      MotionTween<Color>(
        setter: (a) => _background.colorTop = a,
        start: _background.colorTop,
        end: _kBackgroundColorsTop[weatherType.index],
        duration: 1.0,
      ),
    );

    _background.motions.run(
      MotionTween<Color>(
        setter: (a) => _background.colorBottom = a,
        start: _background.colorBottom,
        end: _kBackgroundColorsBottom[weatherType.index],
        duration: 1.0,
      ),
    );

    // Activate/deactivate sun, rain, snow, and dark clouds.
    _cloudsDark.active = weatherType != WeatherType.sun;
    _sun.active = weatherType == WeatherType.sun;
    _rain.active = weatherType == WeatherType.rain;
    _snow.active = weatherType == WeatherType.snow;
  }

  @override
  void spriteBoxPerformedLayout() {
    // If the device is rotated or if the size of the SpriteWidget changes we
    // are adjusting the position of the sun.
    _sun.position =
        spriteBox!.visibleArea!.topLeft + const Offset(350.0, 180.0);
  }
}

// The GradientNode performs custom drawing to draw a gradient background.
class GradientNode extends NodeWithSize {
  GradientNode(Size size, this.colorTop, this.colorBottom) : super(size);

  Color colorTop;
  Color colorBottom;

  @override
  void paint(Canvas canvas) {
    applyTransformForPivot(canvas);

    Rect rect = Offset.zero & size;
    Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: FractionalOffset.topLeft,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[colorTop, colorBottom],
        stops: const <double>[0.0, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, gradientPaint);
  }
}

class CloudLayer extends node.Node {
  CloudLayer(
      {required ui.Image image,
      required bool dark,
      required bool rotated,
      required double loopTime}) {
    // Creates and positions the two cloud sprites.
    _sprites.add(_createSprite(image, dark, rotated));
    _sprites[0].position = const Offset(1024.0, 1024.0);
    addChild(_sprites[0]);

    _sprites.add(_createSprite(image, dark, rotated));
    _sprites[1].position = const Offset(3072.0, 1024.0);
    addChild(_sprites[1]);

    // Animates the clouds across the screen.
    motions.run(
      MotionRepeatForever(
        motion: MotionTween<Offset>(
          setter: (a) => position = a,
          start: Offset.zero,
          end: const Offset(-2048.0, 0.0),
          duration: loopTime,
        ),
      ),
    );
  }

  final List<Sprite> _sprites = <Sprite>[];

  Sprite _createSprite(ui.Image image, bool dark, bool rotated) {
    Sprite sprite = Sprite.fromImage(image);

    if (rotated) sprite.scaleX = -1.0;

    if (dark) {
      sprite.colorOverlay = const Color(0xff000000);
      sprite.opacity = 0.0;
    }

    return sprite;
  }

  set active(bool active) {
    // Toggle visibility of the cloud layer
    double opacity;
    if (active) {
      opacity = 1.0;
    } else {
      opacity = 0.0;
    }

    for (Sprite sprite in _sprites) {
      sprite.motions.stopAll();
      sprite.motions.run(
        MotionTween<double>(
          setter: (a) => sprite.opacity = a,
          start: sprite.opacity,
          end: opacity,
          duration: 1.0,
        ),
      );
    }
  }
}

const double _kNumSunRays = 50.0;

// Create an animated sun with rays
class Sun extends node.Node {
  Sun() {
    // Create the sun
    _sun = Sprite.fromImage(_images['assets/sun.png']!);
    _sun.scale = 4.0;
    _sun.blendMode = BlendMode.plus;
    addChild(_sun);

    // Create rays
    _rays = <Ray>[];
    for (int i = 0; i < _kNumSunRays; i += 1) {
      Ray ray = Ray();
      addChild(ray);
      _rays.add(ray);
    }
  }

  late Sprite _sun;
  late List<Ray> _rays;

  set active(bool active) {
    // Toggle visibility of the sun

    motions.stopAll();

    double targetOpacity;
    if (!active) {
      targetOpacity = 0.0;
    } else {
      targetOpacity = 1.0;
    }

    motions.run(
      MotionTween<double>(
        setter: (a) => _sun.opacity = a,
        start: _sun.opacity,
        end: targetOpacity,
        duration: 2.0,
      ),
    );

    if (active) {
      for (Ray ray in _rays) {
        motions.run(
          MotionSequence(
            motions: [
              MotionDelay(delay: 1.5),
              MotionTween<double>(
                setter: (a) => ray.opacity = a,
                start: ray.opacity,
                end: ray.maxOpacity,
                duration: 1.5,
              ),
            ],
          ),
        );
      }
    } else {
      for (Ray ray in _rays) {
        motions.run(
          MotionTween<double>(
            setter: (a) => ray.opacity = a,
            start: ray.opacity,
            end: 0.0,
            duration: 0.2,
          ),
        );
      }
    }
  }
}

// An animated sun ray
class Ray extends Sprite {
  late double _rotationSpeed;
  late double maxOpacity;

  Ray() : super.fromImage(_images['assets/ray.png']!) {
    pivot = const Offset(0.0, 0.5);
    blendMode = BlendMode.plus;
    rotation = randomDouble() * 360.0;
    maxOpacity = randomDouble() * 0.2;
    opacity = maxOpacity;
    scaleX = 2.5 + randomDouble();
    scaleY = 0.3;
    _rotationSpeed = randomSignedDouble() * 2.0;

    // Scale animation
    double scaleTime = randomSignedDouble() * 2.0 + 4.0;

    motions.run(
      MotionRepeatForever(
        motion: MotionSequence(
          motions: [
            MotionTween<double>(
              setter: (a) => scaleX = a,
              start: scaleX,
              end: scaleX * 0.5,
              duration: scaleTime,
            ),
            MotionTween<double>(
              setter: (a) => scaleX = a,
              start: scaleX * 0.5,
              end: scaleX,
              duration: scaleTime,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    rotation += dt * _rotationSpeed;
  }
}

// Rain layer. Uses three layers of particle systems, to create a parallax
// rain effect.
class Rain extends node.Node {
  Rain() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  final List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(double distance) {
    ParticleSystem particles = ParticleSystem(
      texture: _sprites['raindrop.png']!,
      blendMode: BlendMode.srcATop,
      posVar: const Offset(1300.0, 0.0),
      direction: 90.0,
      directionVar: 0.0,
      speed: 1000.0 / distance,
      speedVar: 100.0 / distance,
      startSize: 1.2 / distance,
      startSizeVar: 0.2 / distance,
      endSize: 1.2 / distance,
      endSizeVar: 0.2 / distance,
      life: 1.5 * distance,
      lifeVar: 1.0 * distance,
    );
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 10.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(
          MotionTween<double>(
            setter: (a) => system.opacity = a,
            start: system.opacity,
            end: 1.0,
            duration: 2.0,
          ),
        );
      } else {
        motions.run(
          MotionTween<double>(
            setter: (a) => system.opacity = a,
            start: system.opacity,
            end: 0.0,
            duration: 0.5,
          ),
        );
      }
    }
  }
}

// Snow. Uses 9 particle systems to create a parallax effect of snow at
// different distances.
class Snow extends node.Node {
  Snow() {
    _addParticles(_sprites['flake-0.png']!, 1.0);
    _addParticles(_sprites['flake-1.png']!, 1.0);
    _addParticles(_sprites['flake-2.png']!, 1.0);

    _addParticles(_sprites['flake-3.png']!, 1.5);
    _addParticles(_sprites['flake-4.png']!, 1.5);
    _addParticles(_sprites['flake-5.png']!, 1.5);

    _addParticles(_sprites['flake-6.png']!, 2.0);
    _addParticles(_sprites['flake-7.png']!, 2.0);
    _addParticles(_sprites['flake-8.png']!, 2.0);
  }

  final List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(SpriteTexture texture, double distance) {
    ParticleSystem particles = ParticleSystem(
      texture: texture,
      blendMode: BlendMode.srcATop,
      posVar: const Offset(1300.0, 0.0),
      direction: 90.0,
      directionVar: 0.0,
      speed: 150.0 / distance,
      speedVar: 50.0 / distance,
      startSize: 1.0 / distance,
      startSizeVar: 0.3 / distance,
      endSize: 1.2 / distance,
      endSizeVar: 0.2 / distance,
      life: 20.0 * distance,
      lifeVar: 10.0 * distance,
      emissionRate: 2.0,
      startRotationVar: 360.0,
      endRotationVar: 360.0,
      radialAccelerationVar: 10.0 / distance,
      tangentialAccelerationVar: 10.0 / distance,
    );
    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(
          MotionTween<double>(
            setter: (a) => system.opacity = a,
            start: system.opacity,
            end: 1.0,
            duration: 2.0,
          ),
        );
      } else {
        motions.run(
          MotionTween<double>(
            setter: (a) => system.opacity = a,
            start: system.opacity,
            end: 0.0,
            duration: 0.5,
          ),
        );
      }
    }
  }
}











class UserMarker extends StatefulWidget {
  const UserMarker({Key? key}) : super(key: key);

  @override
  State<UserMarker> createState() => _UserMarkerState();
}

class _UserMarkerState extends State<UserMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    sizeAnimation = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastEaseInToSlowEaseOut));
    animationController.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.red,
              size: 15,
            ),
          ),
        );
      },
      child: const Icon(
        Icons.water_drop_rounded,
        color: Colors.white,
        size: 10,
      ),
    );
  }
}
