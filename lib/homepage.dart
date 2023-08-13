import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:weather_appp/styleclass.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition();
    getWeatherdata();
    print(
        "My Latitude is ${position!.latitude} & My Longitude is ${position!.longitude}");
  }

  Position? position;

  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  getWeatherdata() async {
    var weather = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position!.longitude}&appid=589730e20dde064b8d00d6b4cad6f657&units=matric"));
    print("Weather ${weather.body}");

    var forecast = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${position!.latitude}&lon=${position!.longitude}&appid=589730e20dde064b8d00d6b4cad6f657&units=matric"));

    weatherMap = Map<String, dynamic>.from(jsonDecode(weather.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecast.body));
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: weatherMap != null
            ? Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://iphoneswallpapers.com/wp-content/uploads/2017/09/Anime-World-Beautiful-Girl-Sky-iPhone-Wallpaper-iphoneswallpapers_com.jpg"))),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(children: [
              Text("${weatherMap!["name"]}", style: mystyle()),
              SizedBox(
                height: 20,
              ),
              Text(
                "${Jiffy.parse('${DateTime.now()}').format(pattern: 'MMMM do yy,\n         h:mm')}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  height: 60,
                  width: 60,
                  color: Colors.white,
                  child: Image.network(
                      "https://openweathermap.org/img/wn/${weatherMap!["weather"][0]["icon"]}@2x.png")),
              SizedBox(
                height: 20,
              ),
              Text(
                "${weatherMap!["main"]["temp"]}°",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height:40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Feels Like ${weatherMap!["main"]["feels_like"]}°",
                        style: mystyle()),
                    Text("${weatherMap!["weather"][0]["description"]}",
                        style: mystyle())
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue.withOpacity(0.6)),
                child: Text(
                  "Wind Speed ${weatherMap!["wind"]["speed"]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 240,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: forecastMap!.length,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)),
                      width: 120,
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "${Jiffy.parse('${DateTime.parse('${forecastMap!["list"][index]["dt_txt"]}')}').format(pattern: 'EEE h mm')}",
                              style: mystyle()),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    padding: EdgeInsets.all(20),
                                    height: 500,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(
                                            255, 0, 45, 83),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8UsQkroNlRUO_z-Zuz5_xNO2tS1auhyNqkg&usqp=CAU",
                                            ),
                                            fit: BoxFit.cover)),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${weatherMap!["name"]}",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                        Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 30),
                                        Text(
                                          "Humidity: ${forecastMap!["list"][0]["main"]["humidity"]}",
                                          style: mystyle1(),
                                        ),
                                        Text(
                                          "Humidity: ${forecastMap!["list"][0]["weather"][0]["description"]}",
                                          style: mystyle1(),
                                        ),
                                        Text(
                                          "Humidity: ${forecastMap!["list"][0]["main"]["temp_kf"]}",
                                          style: mystyle1(),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Container(
                                          color: Colors.blue
                                              .withOpacity(0.4),
                                          height: 200,
                                          width: double.infinity,
                                          child: Image.network(
                                            "https://openweathermap.org/img/wn/${weatherMap!["weather"][0]["icon"]}@2x.png",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            },
                            child: Image.network(
                                "https://openweathermap.org/img/wn/${forecastMap!["list"][index]["weather"][0]["icon"]}@2x.png"),
                          ),
                          Text(
                              "${forecastMap!["list"][index]["main"]["temp_min"]}° / ${forecastMap!["list"][index]["main"]["temp_max"]}°",
                              style: mystyle()),
                          Text(
                              "${forecastMap!["list"][index]["weather"][0]["description"]}",
                              style: mystyle()),
                        ],
                      ),
                    )),
              )
            ]),
          ),
        )
            : Center(child: CircularProgressIndicator()));

  }
}
