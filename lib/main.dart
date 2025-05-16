import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weanews/screens/home_page.dart';
import 'package:weanews/screens/settings_screen.dart';
import 'package:weanews/screens/welcome_screen.dart';
import 'package:weanews/view_model/weather_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WeatherViewModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          '/home': (context) => HomePage(),
          '/setting': (context) => SettingsScreen(),
        },
      ),
    );
  }
}
