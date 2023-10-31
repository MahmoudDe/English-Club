import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bdh/data/dummy_data.dart';

class SearchScreenWidgets {
  static Widget buildDatePicker(
      BuildContext context,
      TextEditingController controller,
      Function filterData,
      TextEditingController _fromDateController) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText:
                controller == _fromDateController ? 'From Date' : 'To Date',
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
              filterData();
            }
          },
        ),
      ),
    );
  }

  static List<Widget> buildItems(List<Data> filteredData) {
    return filteredData.map((data) {
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
}
