import 'package:flutter/material.dart';
import '../background/background.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150.0),
        child: CustomPaint(
          size: Size.fromHeight(150.0),
          painter: RPSCustomPainter(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: List.generate(
              5,
                  (index) => FilterChip(
                label: Text('Filter ${index + 1}'),
                onSelected: (bool value) {
                  // Implement your filter logic here
                },
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                  NetworkImage('https://via.placeholder.com/150'),
                ),
                title: Text('Name'),
                subtitle: Text('Description'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
