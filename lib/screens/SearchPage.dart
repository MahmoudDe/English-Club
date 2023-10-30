import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../background/background.dart';

class Data {
  final String name;
  final DateTime date;
  final String studentClass;
  final String studentGrade;

  Data(this.name, this.date, this.studentClass, this.studentGrade);
}


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
List<String> names = ['علاء', 'وسام', 'جميل', 'كمال', 'وداد', 'وسيم', 'رامي', 'عبدالله', 'محمد', 'محمود'];

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size.fromHeight(150.0),
              painter: RPSCustomPainter(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                        borderRadius: BorderRadius.circular(30.0), // Change this to your desired radius
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),

              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 0.0,
              child: Row(
                children: [
                  Expanded(child: _buildDatePicker(_fromDateController)),
                  const SizedBox(width: 8.0),
                  Expanded(child: _buildDatePicker(_toDateController)),
                ],
              ),
            ),
          ),
          Expanded(child: ListView(children: _buildItems())),
        ],
      ),
    );
  }
  Widget _buildDatePicker(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: controller == _fromDateController ? 'From Date' : 'To Date',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            prefixIcon: const Icon(Iconsax.calendar_2),
          ),
          onTap: () async {
            var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(date);
              _filterData();
            }
          },
        ),
      ),
    );
  }
  List<Widget> _buildItems() {
    return _filteredData.map((data) {
      return Card(
        child: ExpansionTile(
          leading: const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/bdh_logo.jpeg'),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              radius: 23,
            ),
          ),
          title: Text(
            data.name,
            style: const TextStyle( fontSize: 18),
          ),
          trailing: Text(
            '${DateFormat('yyyy-MM-dd').format(data.date)}',
            style: const TextStyle(fontFamily: 'Avenir', fontSize: 16),
          ),
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 65.0, bottom: 15.0),
                child: Text(
                  'Class: ${data.studentClass}\n\nGrade: ${data.studentGrade}',
                  style: const TextStyle(fontFamily: 'Avenir'),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _filterData() {
    String searchQuery = _searchController.text.toLowerCase();
    DateTime? fromDate;
    DateTime? toDate;

    if (_fromDateController.text.isNotEmpty && _toDateController.text.isNotEmpty) {
      fromDate = DateFormat('yyyy-MM-dd').parse(_fromDateController.text);
      toDate = DateFormat('yyyy-MM-dd').parse(_toDateController.text);
    }

    setState(() {
      _filteredData = _data.where((item) {
        return (fromDate == null || toDate == null || (item.date.isAfter(fromDate) && item.date.isBefore(toDate))) &&
            item.name.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

}

