import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/drawer/main_drawer.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../background/BackgroundPaint.dart';

class Data {
  final String name;
  final DateTime date;
  final String studentClass;
  final String studentGrade;

  Data(this.name, this.date, this.studentClass, this.studentGrade);
}

class BorrowScreen extends StatefulWidget {
  @override
  _BorrowScreenState createState() => _BorrowScreenState();
}

List<String> names = [
  'علاء',
  'وسام',
  'جميل',
  'كمال',
  'وداد',
  'وسيم',
  'رامي',
  'عبدالله',
  'محمد',
  'محمود'
];

class _BorrowScreenState extends State<BorrowScreen> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? bookScan;

  Future scanBarcode() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        'cancel',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = 'some thing wrong happening';
    }
    if (!mounted) return;

    setState(() {
      bookScan = scanResult;
    });
  }

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
      ),
      body: Column(
        children: [
          TitleWidget(
            mediaQuery: mediaQuery,
            title: 'Borrow',
            icon: Icon(
              Iconsax.book,
              color: AppColors.whiteLight,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 25),
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
          SizedBox(
            height: mediaQuery.height / 80,
          ),
          Expanded(
              child: ListView(
                  padding: EdgeInsets.zero,
                  children: _buildItems(
                    mediaQuery,
                    () {
                      scanBarcode();
                      bookScan != null
                          ? showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text(bookScan!),
                              ),
                            )
                          : null;
                    },
                  ))),
        ],
      ),
    );
  }

  List<Widget> _buildItems(Size mediaQuery, void Function()? onPressed) {
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
            style: const TextStyle(fontSize: 18),
          ),
          trailing: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Iconsax.scan_barcode),
            label: const Text(
              'Scan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          children: [
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(
                    left: mediaQuery.width / 5, bottom: mediaQuery.height / 80),
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

    if (_fromDateController.text.isNotEmpty &&
        _toDateController.text.isNotEmpty) {
      fromDate = DateFormat('yyyy-MM-dd').parse(_fromDateController.text);
      toDate = DateFormat('yyyy-MM-dd').parse(_toDateController.text);
    }

    setState(() {
      _filteredData = _data.where((item) {
        return (fromDate == null ||
                toDate == null ||
                (item.date.isAfter(fromDate) && item.date.isBefore(toDate))) &&
            item.name.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }
}
