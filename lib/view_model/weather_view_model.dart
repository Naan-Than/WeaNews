import 'package:flutter/material.dart';
import 'package:weanews/services/weather_news_service.dart';

import '../models/news_response.dart';
import '../models/weather_response.dart';

class WeatherViewModel with ChangeNotifier {
  final WeatherNewsService service = WeatherNewsService();
  final TextEditingController txtController = TextEditingController();
  String _selectedUnit = 'Celsius';
  bool _isLoading = false;
  bool _isSubLoading = false;
  bool _showWeatherNews = true;
  WeatherResponse? _weather;
  NewsResponse? _news;
  NewsResponse? _filteredNews;
  // List<dynamic> _news = [];

  bool get isLoading => _isLoading;
  bool get isSubLoading => _isSubLoading;
  String get selectedUnit => _selectedUnit;
  bool get showWeatherNews => _showWeatherNews;
  WeatherResponse? get weather => _weather;
  NewsResponse? get news => _news;
  // NewsResponse? get filteredNews =

  final List<String> _defaultCategories = [
    'Current Weather',
    'Sports',
    'Technology',
    'Business',
    'Entertainment',
  ];
  List<String> get defaultCategories => List.unmodifiable(_defaultCategories);
  List<String> get customCategories => List.unmodifiable(_customCategories);
  List<String> get allCategories => [..._defaultCategories, ..._customCategories];
  final List<String> _customCategories = [];

  void addCategory(String category) {
    if (!_customCategories.contains(category) && !_defaultCategories.contains(category)) {
      _customCategories.add(category);
      notifyListeners();
    }
  }
  void removeCategory(String category) {
    if (_customCategories.contains(category)) {
      _customCategories.remove(category);
      notifyListeners();
    }
  }

  void setShowWeatherNews(bool value) {
    _showWeatherNews = value;
    notifyListeners();
  }
  void setTemperatureUnit(String unit) {
    if (_selectedUnit != unit) {
      _selectedUnit = unit;
      notifyListeners();
    }
  }

  double? get temperature {
    if (_weather?.main?.temp == null) {
      return null;
    }
    if (_selectedUnit == 'Celsius') {
      return _weather!.main!.temp!.toDouble() - 273.15;
    } else if (_selectedUnit == 'Fahrenheit') {
      return (_weather!.main!.temp!.toDouble() - 273.15) * 9 / 5 + 32;
    }
    return null;
  }

  Future<void> loadWeatherAndNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await service.getWeatherAndNews();
      final weatherData = result['weather'];
      if (weatherData is WeatherResponse) {
        _weather = weatherData;
      } else {
        _weather = null;
        print(
          "Error: Expected WeatherResponse object, but received: $weatherData",
        );
      }
      _news = result['news'];
      print('...................${_news}');
      print('Weather Data: ${_weather?.name}, ${_weather?.main?.temp}');
    } catch (e) {
      print("Failed to load weather/news: $e");
      _weather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleWeatherNews(bool value) {
    _showWeatherNews = value;
    notifyListeners();
  }

  double get temperatureValue {
    final kelvinTemp = weather?.main?.temp;
    if (kelvinTemp == null || kelvinTemp < 100) return 0;
    return _selectedUnit == 'Celsius'
        ? kelvinTemp - 273.15
        : (kelvinTemp - 273.15) * 9 / 5 + 32;
  }

  String get temperatureUnit => _selectedUnit == 'Celsius' ? '°C' : '°F';

  List<Article> get filteredNews {
    final articles = _news?.articles ?? [];

    if (_showWeatherNews) return articles;

    const keywords = [
      'weather',
      'rain',
      'storm',
      'climate',
      'heatwave',
      'cold wave',
      'snow',
      'wind',
      'humidity',
      'forecast',
    ];

    return articles.where((article) {
      final text =
          '${article.title ?? ''} ${article.description ?? ''}'.toLowerCase();
      return keywords.any((keyword) => text.contains(keyword));
    }).toList();
  }

  Future<void> loadNewsByCategory(String category) async {
    _isSubLoading = true;
    notifyListeners();

    try {
      _news = await service.getNewsByCategory(category);
      print('News for $category: ${_news?.articles?.length ?? 0}');
    } catch (e) {
      print("Failed to load news for $category: $e");
      _news = null;
    } finally {
      _isSubLoading = false;
      notifyListeners();
    }
  }
}
