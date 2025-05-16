import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weanews/utility.dart';
import 'package:weanews/view_model/weather_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          'Settings',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: Icon(Icons.home_rounded, color: Colors.white, size: 32),
          ),
          SizedBox(width: 5),
        ],
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Utility.darkPurple,
      body: SafeArea(
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              Text(
                'Preferred Temperature Unit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleButtons(
                    isSelected: [
                      viewModel.selectedUnit == 'Celsius',
                      viewModel.selectedUnit == 'Fahrenheit',
                    ],
                    onPressed: (index) {
                      String selected = index == 0 ? 'Celsius' : 'Fahrenheit';
                      viewModel.setTemperatureUnit(selected);
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    borderColor: Utility.primaryPurple,
                    fillColor: Utility.primaryPurple,
                    color: Utility.primaryPurple,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5,
                        ),
                        child: Text(
                          'Celsius (°C)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5,
                        ),
                        child: Text(
                          'Fahrenheit (°F)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'news categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children:
                    viewModel.allCategories.map((category) {
                      final isRemovable =
                          !viewModel.defaultCategories.contains(category);
                      return Chip(
                        label: Text(category),
                        deleteIcon:
                            isRemovable
                                ? Icon(
                                  Icons.close_rounded,
                                  color: Utility.primaryPurple,
                                )
                                : null,
                        onDeleted:
                            isRemovable
                                ? () {
                                  viewModel.removeCategory(category);
                                }
                                : null,
                      );
                    }).toList(),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Utility.primaryPurple),
                ),
                child: Row(
                  children: [
                    // Input field
                    Expanded(
                      child: TextField(
                        controller: viewModel.txtController,
                        decoration: InputDecoration(
                          hintText: 'Add Category',
                          hintStyle: TextStyle(
                            color: Utility.primaryPurple,
                            fontSize: 16,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),

                    // Vertical divider
                    Container(
                      width: 1,
                      height: 50,
                      color: Utility.primaryPurple,
                    ),

                    // Apply button
                    InkWell(
                      onTap: () {
                        final newCategory = viewModel.txtController.text.trim();
                        if (newCategory.isNotEmpty) {
                          viewModel.addCategory(newCategory);
                          viewModel.txtController.clear();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Utility.primaryPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        width: double.infinity,
        color: Colors.white,
        child: ListTile(
          title: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Utility.primaryPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
