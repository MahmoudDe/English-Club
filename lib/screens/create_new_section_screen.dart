import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../common/transitionBack.dart';

class CreateSectionScreen extends StatefulWidget {
  const CreateSectionScreen({super.key});

  @override
  State<CreateSectionScreen> createState() => _CreateSectionScreenState();
}

class _CreateSectionScreenState extends State<CreateSectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
        title: const Text(
          'Create section',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushReplacement(context,
              customPageRouteBuilderBack(const EnglishClubSettingsScreen())),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //row1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 1 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 2'),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 3 selected!');
                      },
                      child: Text('Level 3'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            //row2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 3 selected!');
                      },
                      child: Text('Level 3'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 1 selected!');
                  },
                  child: Text('Level 1'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  child: Text('Level 2'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  child: Text('Level 2'),
                ),
              ],
            ),
            //row1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 1 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 2'),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 3 selected!');
                      },
                      child: Text('Level 3'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ), //row2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 3 selected!');
                      },
                      child: Text('Level 3'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 1 selected!');
                  },
                  child: Text('Level 1'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  child: Text('Level 2'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  child: Text('Level 2'),
                ),
              ],
            ),
            //row1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 1 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the selected level
                    // Add your navigation logic here
                    print('Level 2 selected!');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), // Circular shape
                    padding: EdgeInsets.all(20.0), // Adjust padding for size
                  ),
                  child: Text('Level 2'),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 3 selected!');
                      },
                      child: Text('Level 3'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), // Circular shape
                        padding:
                            EdgeInsets.all(20.0), // Adjust padding for size
                      ),
                      onPressed: () {
                        // Navigate to the selected level
                        // Add your navigation logic here
                        print('Level 4 selected!');
                      },
                      child: Text('Level 4'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
