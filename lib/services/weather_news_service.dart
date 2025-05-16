import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/news_response.dart';
import '../models/weather_response.dart';

class WeatherNewsService {
  final Dio _dio = Dio();

  // final String weatherApiKey = '80e5d3e476c56261f1acf1d621857892';
  final String weatherApiKey = 'ce08473ddeceb2729648c99efa30ec0d';
  final String newsApiKey = '3db571a0a3044839818cdd790d407726';

  final String weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  final String newsBaseUrl = 'https://newsapi.org/v2/everything';

  Future<Position> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show a popup to inform the user
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location Services Disabled"),
          content: Text("Please enable location services to continue."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // close the dialog
                await Geolocator.openLocationSettings(); // open location settings
              },
              child: Text("Open Settings"),
            ),
          ],
        ),
      );

      // Re-check after the user returns from settings
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are still disabled.');
      }
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    // Get the current location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<WeatherResponse> getWeather(double lat, double lon) async {
    try {
      final String url =
          '$weatherBaseUrl?lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric';
      print(url);
      final response = await _dio.get(url);

      final weatherResponse = WeatherResponse.fromJson(response.data);
      return weatherResponse;
    } catch (e) {
      throw Exception('Weather fetch failed: $e');
    }
  }

  Future<NewsResponse?> getNews(WeatherResponse? weather) async {
    if (weather == null ||
        weather.weather == null ||
        weather.weather!.isEmpty) {
      return null;
    }

    String keyword = '';
    final String currentWeatherCondition =
        weather.weather![0].main?.toLowerCase() ?? '';

    print("Current weather condition: $currentWeatherCondition");

    if (currentWeatherCondition.contains('cold') ||
        currentWeatherCondition.contains('snow') ||
        currentWeatherCondition.contains('freez')) {
      keyword = 'sad OR depressing OR loss OR tragedy';
    } else if (currentWeatherCondition.contains('hot') ||
        currentWeatherCondition.contains('sunny')) {
      keyword = 'fear OR anxiety OR danger OR threat';
    } else if (currentWeatherCondition.contains('cool') ||
        currentWeatherCondition.contains('clear') ||
        currentWeatherCondition.contains('clouds')) {
      keyword = 'win OR happiness OR success OR joy';
    } else {
      keyword = 'news';
    }

    try {
      final response = await _dio.get(
        newsBaseUrl,
        queryParameters: {
          'q': keyword,
          'apiKey': newsApiKey,
          'language': 'en',
          'sortBy': 'relevancy',
          'pageSize': 10,
        },
      );

      if (response.data != null) {
        return NewsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('News fetch failed: $e');
      return null;
    }
  }

  Future<NewsResponse?> getNewsByCategory(String category) async {
    try {
      final response = await _dio.get(
        newsBaseUrl,
        queryParameters: {
          'q': category,
          'apiKey': newsApiKey,
          'language': 'en',
          'sortBy': 'relevancy',
          'pageSize': 10,
        },
      );

      if (response.data != null) {
        return NewsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('News fetch failed for $category: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getWeatherAndNews(context) async {
    try {
      final position = await getCurrentLocation(context);
      print("${position.latitude},${position.longitude}.........loc");

      final WeatherResponse weather = await getWeather(
        double.parse(position.latitude.toStringAsFixed(2)),
        double.parse(position.longitude.toStringAsFixed(2)),
      );

      NewsResponse? news;
      String? keyword = weather.weather?[0]?.main?.toLowerCase();

      if (keyword != null) {
        news = await getNews(weather);
      }
      return {'weather': weather, 'news': news};
    } catch (e) {
      throw Exception('Combined fetch failed: $e');
    }
  }
}
