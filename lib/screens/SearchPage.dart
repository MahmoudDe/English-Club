import 'package:bdh/data/dummy_data.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/drawer/main_drawer.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:bdh/widgets/search/search_widgets.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<Data> _data = List.generate(
    10,
    (index) => Data(
      names[Random().nextInt(names.length)], // Use a random name
      DateTime.now().subtract(Duration(days: index)),
      'Class ${index + 1}',
      'Grade ${index + 1}',
    ),
  );

  List<Data> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = [..._data];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.main,
        elevation: 0,
      ),
      body: Stack(children: [
        Column(children: [
          TitleWidget(
            mediaQuery: mediaQuery,
            title: 'Search',
            icon: Icon(
              Icons.search,
              color: AppColors.whiteLight,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 25),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _filterData();
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  fillColor: Colors.white.withOpacity(0.5),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Change this to your desired radius
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 0.0,
              child: Row(children: [
                Expanded(
                    child: SearchScreenWidgets.buildDatePicker(context,
                        _fromDateController, _filterData, _fromDateController)),
                const SizedBox(width: 8.0),
                Expanded(
                    child: SearchScreenWidgets.buildDatePicker(context,
                        _toDateController, _filterData, _fromDateController)),
              ]),
            ),
          ),
          Expanded(
            child: ListView(
                padding: EdgeInsets.zero,
                children: SearchScreenWidgets.buildItems(_filteredData)),
          ),
        ]),
      ]),
    );
  }

  void _filterData() {
    String searchQuery = _searchController.text.toLowerCase();
    DateTime? fromDate;
    DateTime? toDate;

    if (_fromDateController.text.isNotEmpty &&
        _toDateController.text.isNotEmpty) {
      fromDate = DateFormat('yyyy-MM-dd').parse(_fromDateController.text);
      toDate = DateFormat('yyyy-MM-dd').parse(_toDateController.text);
    }

    setState(() {
      _filteredData = _data.where((item) {
        return (fromDate == null ||
                toDate == null ||
                (item.date.isAfter(fromDate))) &&
            item.name.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }
}
