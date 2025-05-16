import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weanews/utility.dart';

import '../view_model/weather_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Current Weather';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final viewModel = Provider.of<WeatherViewModel>(context, listen: false);
      viewModel.loadWeatherAndNews(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final viewModel = Provider.of<WeatherViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utility.darkPurple,
        toolbarHeight: 100,
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
            icon: Icon(Icons.settings, color: Colors.white, size: 30),
          ),
          SizedBox(width: 5),
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Utility.darkPurple,
      body:
          viewModel.isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => viewModel.loadWeatherAndNews(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            // color: Utility.lightPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.weather?.name ?? 'Loading...',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Utility.darkPurple,
                                        ),
                                      ),
                                      Text(
                                        viewModel?.weather?.dt != null
                                            ? Utility.formatDateFromTimestamp(
                                              viewModel!.weather!.dt!.toInt(),
                                            )
                                            : 'Date not available',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Utility.darkPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    // color: Colors.red,
                                    width: 100.0,
                                    height: 100.0,
                                    child: Image.network(
                                      Utility.getIconUrl(
                                        viewModel.weather!.weather![0].icon
                                            .toString(),
                                      ),
                                      fit: BoxFit.contain,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.error_outline,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    viewModel.temperature != null
                                        ? viewModel.temperature!.toStringAsFixed(0)
                                        : '--',
                                    // "${viewModel.weather?.main?.temp?.toStringAsFixed(0) ?? '--'}",
                                    style: TextStyle(
                                      fontSize: 70,
                                      fontWeight: FontWeight.bold,
                                      color: Utility.primaryPurple,
                                    ),
                                  ),
                                  Text(
                                    // '°C',
                                    viewModel.temperatureUnit,
                                    style: TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold,
                                      color: Utility.primaryPurple,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                viewModel.weather?.weather?[0]?.description ??
                                    '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Utility.darkPurple,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Show weather-relevant news',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Utility.darkPurple,
                                    ),
                                  ),
                                  Switch(
                                    value: viewModel.showWeatherNews,
                                    onChanged: (value) {
                                      setState(() {
                                        viewModel.setShowWeatherNews(value);
                                        // viewModel.showWeatherNews = value;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: Utility.primaryPurple,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: viewModel.allCategories.length,
                            itemBuilder: (context, index) {
                              final category = viewModel.allCategories[index];
                              final isSelected = category == selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  // highlightColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category;
                                      viewModel.loadNewsByCategory(category);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? Utility.primaryPurple
                                              : Utility.lightPurple.withOpacity(
                                                0.1,
                                              ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Utility.darkPurple,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        viewModel.isSubLoading
                            ? Container(
                              height: screenHeight / 3.5,
                              child: Center(child: CircularProgressIndicator()),
                            )
                            : viewModel.filteredNews.isEmpty
                            ? SizedBox(
                              height: screenHeight / 3.5,
                              child: Center(
                                child: Container(
                                  height: 110,
                                  width: 180,

                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: .3,
                                        blurRadius: 10,
                                        offset: const Offset(0, 9),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 48,
                                        color: Utility.primaryPurple,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'No records found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Utility.primaryPurple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            : Expanded(
                              child: ListView.builder(
                                itemCount: viewModel.filteredNews?.length,
                                itemBuilder: (context, index) {
                                  final news = viewModel.filteredNews?[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Utility.customNewsCard(
                                      onPress: () async {
                                        final url = Uri.parse(news?.url ?? '');
                                        // final url = Uri.parse(
                                        //   "https://www.wired.com/story/manufacturers-hope-ai-will-save-supply-chains-from-climate-crisis/",
                                        // );
                                        try {
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(
                                              url,
                                              mode:
                                                  LaunchMode
                                                      .externalApplication,
                                            );
                                          } else {
                                            print("Could not launch $url");
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      // onPress:(){
                                      //   print("object ${news?.url}");
                                      // },
                                      title: news?.title ?? 'No Title',
                                      source:
                                          news?.source?.name.toString() ??
                                          'Unknown Source',
                                      time:
                                          news?.publishedAt
                                              ?.toIso8601String() ??
                                          'Unknown Time',
                                      imageUrl: news?.urlToImage ?? '',
                                      tag: '',
                                    ),
                                  );
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
