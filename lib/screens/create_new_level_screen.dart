// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../common/snack_bar_widget.dart';

import '../server/apis.dart';
import '../widgets/form_widget copy.dart';

class CreateNewLevelScreen extends StatefulWidget {
  const CreateNewLevelScreen(
      {super.key, required this.sectionId, required this.sectionName});
  final String sectionName;
  final String sectionId;

  @override
  State<CreateNewLevelScreen> createState() => _CreateNewLevelScreenState();
}

class _CreateNewLevelScreenState extends State<CreateNewLevelScreen> {
  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController storyGoodPerController =
      TextEditingController(text: '');
  TextEditingController vocabGoodPerController =
      TextEditingController(text: '');
  TextEditingController storyVeryGoodPerController =
      TextEditingController(text: '');
  TextEditingController vocabVeryGoodPerController =
      TextEditingController(text: '');
  TextEditingController storyExcellentPerController =
      TextEditingController(text: '');
  TextEditingController vocabExcellentPerController =
      TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  FocusNode titleNode = FocusNode();
  FocusNode storiesGoodPerNode = FocusNode();
  FocusNode vocabGoodPerNode = FocusNode();
  FocusNode storiesVeryGoodPerNode = FocusNode();
  FocusNode vocabVeryGoodPerNode = FocusNode();
  FocusNode storiesExcellentPerNode = FocusNode();
  FocusNode vocabExcellentPerNode = FocusNode();
  String levelName = '';
  String storiesGoodPer = '';
  String vocabGoodPer = '';
  String storiesVeryGoodPer = '';
  String vocabVeryGoodPer = '';
  String storiesExcellentPer = '';
  String vocabExcellentPer = '';
  List storiesPrizes = [
    {
      "score_points": '0',
      "golden_coin": '0',
      "silver_coin": '0',
      "bronze_coin": '0'
    },
    {
      "score_points": '0',
      "golden_coin": '0',
      "silver_coin": '0',
      "bronze_coin": '0'
    },
    {
      "score_points": '0',
      "golden_coin": '0',
      "silver_coin": '0',
      "bronze_coin": '0'
    }
  ];

  List<dynamic> vocabPrizes = [
    {
      "score_points": '0',
      "golden_coin": '0',
      "silver_coin": '0',
      "bronze_coin": '0'
    },
    {
      "score_points": '0',
      "golden_coin": '0',
      "silver_coin": '0',
      "bronze_coin": '0'
    },
    {
      "score_points": '0',
      "golden_coin": '0',
      "silver_coin": '0',
      "bronze_coin": '0'
    }
  ];

  File? exclFile;
  String excelFileName = '';
  bool didSelectFile = false;

  Future<void> openFilePicker() async {
    bool isOk = await Permission.storage.status.isGranted;
    if (!isOk) {
      await Permission.storage.request();
    }
    print('is ok = $isOk');
    print(await Permission.storage.status.isGranted);
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      setState(() {
        exclFile = File(resultFile.files.single.path!);
        excelFileName = resultFile.names.toString();
        didSelectFile = true;
      });
    }
  }

  bool isUploading = false;
  String message = '';
  Future<void> uploadData() async {
    setState(() {
      isUploading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).createLevel(
          sectionId: widget.sectionId,
          name: levelName,
          good_percentage: storiesGoodPer,
          veryGood_percentage: storiesVeryGoodPer,
          excellent_percentage: storiesExcellentPer,
          prizes: storiesPrizes,
          vocab_g_percentage: vocabGoodPer,
          vocab_vg_percentage: vocabVeryGoodPer,
          vocab_exc_percentage: vocabExcellentPer,
          vocabPrizes: vocabPrizes,
          file: exclFile!);
      setState(() {
        print(Apis.message);
        message = Apis.message;
      });
      Navigator.pop(context);
      if (Apis.statusResponse != 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: message,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: message,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnglishClubSettingsScreen(),
                ));
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
        title: const Text(
          'create new level',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => print('$storiesPrizes \n \n $vocabPrizes'),
                child: Card(
                  margin: EdgeInsets.only(top: mediaQuery.height / 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width / 10,
                      vertical: mediaQuery.height / 70,
                    ),
                    child: Text(
                      '${widget.sectionName} section',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.main,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mediaQuery.height / 100,
              ),
              Text(
                'Level control panel',
                style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 25),
              ),
              // SizedBox(
              //   height: mediaQuery.height / 60,
              // ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 10,
                    vertical: mediaQuery.height / 200),
                child: FormWidget(
                  controller: titleController,
                  textInputType: TextInputType.text,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: mediaQuery,
                  textInputAction: TextInputAction.next,
                  labelText: 'level title',
                  hintText: 'EX: level(1)',
                  focusNode: titleNode,
                  nextNode: titleNode,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter title for the level';
                    } else if (value.length < 2) {
                      return 'This level name is too short';
                    }
                    setState(() {
                      levelName = value;
                    });
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: mediaQuery.height / 50,
              ),
              Text(
                'Stories settings',
                style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 25),
              ),
              //Stories good percentage
              ExpansionTile(
                // collapsedBackgroundColor: Colors.white,
                title: Padding(
                  padding: EdgeInsets.symmetric(
                      // horizontal: mediaQuery.width / 10,
                      vertical: mediaQuery.height / 200),
                  child: FormWidget(
                    controller: storyGoodPerController,
                    textInputType: TextInputType.number,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: 'Good percentage',
                    hintText: 'EX: 0.5',
                    focusNode: storiesGoodPerNode,
                    nextNode: storiesVeryGoodPerNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter good per for the stories';
                      }
                      if (double.parse(value) > 1 || double.parse(value) < 0) {
                        return 'The value should be between 0 and 1';
                      }
                      setState(() {
                        storiesGoodPer = value;
                      });
                      return null;
                    },
                  ),
                ),
                children: [
                  buildStatTile(
                    'Score',
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    true,
                    0,
                    'score_points',
                  ),
                  buildStatTile(
                    'Golden cards',
                    Image(
                      image: const AssetImage('assets/images/golden.png'),
                      height: mediaQuery.height / 30,
                    ),
                    true,
                    0,
                    'golden_coin',
                  ),
                  buildStatTile(
                      'Silver cards',
                      Image(
                        image: const AssetImage('assets/images/silver.png'),
                        height: mediaQuery.height / 30,
                      ),
                      true,
                      0,
                      'silver_coin'),
                  buildStatTile(
                      'Bronze cards',
                      Image(
                        image: const AssetImage('assets/images/bronze.png'),
                        height: mediaQuery.height / 30,
                      ),
                      true,
                      0,
                      'bronze_coin'),
                ],
              ),
              //Stories very good percentage
              ExpansionTile(
                // collapsedBackgroundColor: Colors.white,
                title: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: mediaQuery.height / 2000),
                  child: FormWidget(
                    controller: storyVeryGoodPerController,
                    textInputType: TextInputType.number,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: 'Very good percentage',
                    hintText: 'EX: 0.8',
                    focusNode: storiesVeryGoodPerNode,
                    nextNode: storiesExcellentPerNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter very good per for the stories';
                      }
                      if (double.parse(value) > 1 || double.parse(value) < 0) {
                        return 'The value should be between 0 and 1';
                      }
                      setState(() {
                        storiesVeryGoodPer = value;
                      });
                      return null;
                    },
                  ),
                ),
                children: [
                  buildStatTile(
                    'Score',
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    true,
                    1,
                    'score_points',
                  ),
                  buildStatTile(
                    'Golden cards',
                    Image(
                      image: const AssetImage('assets/images/golden.png'),
                      height: mediaQuery.height / 30,
                    ),
                    true,
                    1,
                    'golden_coin',
                  ),
                  buildStatTile(
                      'Silver cards',
                      Image(
                        image: const AssetImage('assets/images/silver.png'),
                        height: mediaQuery.height / 30,
                      ),
                      true,
                      1,
                      'silver_coin'),
                  buildStatTile(
                      'Bronze cards',
                      Image(
                        image: const AssetImage('assets/images/bronze.png'),
                        height: mediaQuery.height / 30,
                      ),
                      true,
                      1,
                      'bronze_coin'),
                ],
              ),
              //Stories excellent percentage
              ExpansionTile(
                // collapsedBackgroundColor: Colors.white,
                title: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: mediaQuery.height / 2000),
                  child: FormWidget(
                    controller: storyExcellentPerController,
                    textInputType: TextInputType.number,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: 'Excellent percentage',
                    hintText: 'EX: 1',
                    focusNode: storiesExcellentPerNode,
                    nextNode: storiesExcellentPerNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter very good per for the stories';
                      }
                      if (double.parse(value) > 1 || double.parse(value) < 0) {
                        return 'The value should be between 0 and 1';
                      }
                      setState(() {
                        storiesExcellentPer = value;
                      });
                      return null;
                    },
                  ),
                ),
                children: [
                  buildStatTile(
                    'Score',
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    true,
                    2,
                    'score_points',
                  ),
                  buildStatTile(
                    'Golden cards',
                    Image(
                      image: const AssetImage('assets/images/golden.png'),
                      height: mediaQuery.height / 30,
                    ),
                    true,
                    2,
                    'golden_coin',
                  ),
                  buildStatTile(
                      'Silver cards',
                      Image(
                        image: const AssetImage('assets/images/silver.png'),
                        height: mediaQuery.height / 30,
                      ),
                      true,
                      2,
                      'silver_coin'),
                  buildStatTile(
                      'Bronze cards',
                      Image(
                        image: const AssetImage('assets/images/bronze.png'),
                        height: mediaQuery.height / 30,
                      ),
                      true,
                      2,
                      'bronze_coin'),
                ],
              ),
              SizedBox(
                height: mediaQuery.height / 50,
              ),
              Text(
                'Vocab Test settings',
                style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 25),
              ),
              //Vocab good percentage
              ExpansionTile(
                // collapsedBackgroundColor: Colors.white,
                title: Padding(
                  padding: EdgeInsets.symmetric(
                      // horizontal: mediaQuery.width / 10,
                      vertical: mediaQuery.height / 200),
                  child: FormWidget(
                    controller: vocabGoodPerController,
                    textInputType: TextInputType.number,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: 'Good percentage',
                    hintText: 'EX: 0.5',
                    focusNode: vocabGoodPerNode,
                    nextNode: vocabGoodPerNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter good per for the stories';
                      }
                      if (double.parse(value) > 1 || double.parse(value) < 0) {
                        return 'The value should be between 0 and 1';
                      }
                      setState(() {
                        vocabGoodPer = value;
                      });
                      return null;
                    },
                  ),
                ),
                children: [
                  buildStatTile(
                    'Score',
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    false,
                    0,
                    'score_points',
                  ),
                  buildStatTile(
                    'Golden cards',
                    Image(
                      image: const AssetImage('assets/images/golden.png'),
                      height: mediaQuery.height / 30,
                    ),
                    false,
                    0,
                    'golden_coin',
                  ),
                  buildStatTile(
                      'Silver cards',
                      Image(
                        image: const AssetImage('assets/images/silver.png'),
                        height: mediaQuery.height / 30,
                      ),
                      false,
                      0,
                      'silver_coin'),
                  buildStatTile(
                      'Bronze cards',
                      Image(
                        image: const AssetImage('assets/images/bronze.png'),
                        height: mediaQuery.height / 30,
                      ),
                      false,
                      0,
                      'bronze_coin'),
                ],
              ),
              //Vocab very good percentage
              ExpansionTile(
                // collapsedBackgroundColor: Colors.white,
                title: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: mediaQuery.height / 2000),
                  child: FormWidget(
                    controller: vocabVeryGoodPerController,
                    textInputType: TextInputType.number,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: 'Very good percentage',
                    hintText: 'EX: 0.8',
                    focusNode: vocabVeryGoodPerNode,
                    nextNode: vocabVeryGoodPerNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter very good per for the stories';
                      }
                      if (double.parse(value) > 1 || double.parse(value) < 0) {
                        return 'The value should be between 0 and 1';
                      }
                      setState(() {
                        vocabVeryGoodPer = value;
                      });
                      return null;
                    },
                  ),
                ),
                children: [
                  buildStatTile(
                    'Score',
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    false,
                    1,
                    'score_points',
                  ),
                  buildStatTile(
                    'Golden cards',
                    Image(
                      image: const AssetImage('assets/images/golden.png'),
                      height: mediaQuery.height / 30,
                    ),
                    false,
                    1,
                    'golden_coin',
                  ),
                  buildStatTile(
                      'Silver cards',
                      Image(
                        image: const AssetImage('assets/images/silver.png'),
                        height: mediaQuery.height / 30,
                      ),
                      false,
                      1,
                      'silver_coin'),
                  buildStatTile(
                      'Bronze cards',
                      Image(
                        image: const AssetImage('assets/images/bronze.png'),
                        height: mediaQuery.height / 30,
                      ),
                      false,
                      1,
                      'bronze_coin'),
                ],
              ),
              //Vocab excellent percentage
              ExpansionTile(
                // collapsedBackgroundColor: Colors.white,
                title: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: mediaQuery.height / 2000),
                  child: FormWidget(
                    controller: vocabExcellentPerController,
                    textInputType: TextInputType.number,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: 'Excellent percentage',
                    hintText: 'EX: 1',
                    focusNode: vocabExcellentPerNode,
                    nextNode: vocabExcellentPerNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter very good per for the stories';
                      }
                      if (double.parse(value) > 1 || double.parse(value) < 0) {
                        return 'The value should be between 0 and 1';
                      }
                      setState(() {
                        vocabExcellentPer = value;
                      });
                      return null;
                    },
                  ),
                ),
                children: [
                  buildStatTile(
                    'Score',
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    false,
                    2,
                    'score_points',
                  ),
                  buildStatTile(
                    'Golden cards',
                    Image(
                      image: const AssetImage('assets/images/golden.png'),
                      height: mediaQuery.height / 30,
                    ),
                    false,
                    2,
                    'golden_coin',
                  ),
                  buildStatTile(
                      'Silver cards',
                      Image(
                        image: const AssetImage('assets/images/silver.png'),
                        height: mediaQuery.height / 30,
                      ),
                      false,
                      2,
                      'silver_coin'),
                  buildStatTile(
                      'Bronze cards',
                      Image(
                        image: const AssetImage('assets/images/bronze.png'),
                        height: mediaQuery.height / 30,
                      ),
                      false,
                      2,
                      'bronze_coin'),
                ],
              ),
              SizedBox(
                height: mediaQuery.height / 80,
              ),
              //Vocab excel file
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      openFilePicker();
                    },
                    style: ElevatedButton.styleFrom(primary: AppColors.main),
                    icon: const Icon(
                      Icons.file_upload,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'excel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: mediaQuery.height / 25,
                    width: mediaQuery.width / 1.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.main, width: 2),
                    ),
                    child: Text(
                      didSelectFile ? excelFileName : 'Excel file',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.main,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: mediaQuery.height / 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && didSelectFile) {
                    print('level name => $levelName');
                    print('story good => $storiesGoodPer');
                    print('story very good => $storiesVeryGoodPer');
                    print('story excellent => $storiesExcellentPer');
                    print('story prizes => $storiesPrizes');
                    print('vocab good => $vocabGoodPer');
                    print('vocab very good => $vocabVeryGoodPer');
                    print('vocab excellent => $vocabExcellentPer');
                    print('vocab prizes => $vocabPrizes');
                    uploadData();
                    if (isUploading) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        text: 'Uploading data...',
                        // barrierDismissible: false,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBarWidget(
                              title: 'Ops',
                              message:
                                  'you still have to enter or edit data for this story',
                              contentType: ContentType.failure)
                          .getSnakBar());
                  }
                },
                style: ElevatedButton.styleFrom(primary: AppColors.main),
                child: const Text(
                  'Create book',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatTile(
      String title, Widget leading, bool isStory, int index, String value) {
    int value1 = 0;
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style:
            const TextStyle(fontFamily: 'Avenir', fontWeight: FontWeight.bold),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isStory) {
                  value1 = int.parse(storiesPrizes[index][value]);
                  value1 >= 1 ? value1-- : null;
                  storiesPrizes[index][value] = value1.toString();
                } else {
                  value1 = int.parse(vocabPrizes[index][value]);
                  value1 >= 1 ? value1-- : null;
                  vocabPrizes[index][value] = value1.toString();
                }
              });
            },
            icon: const Icon(Icons.remove),
          ),
          Text(isStory
              ? storiesPrizes[index][value].toString()
              : vocabPrizes[index][value].toString()),
          IconButton(
            onPressed: () {
              setState(() {
                if (isStory) {
                  value1 = int.parse(storiesPrizes[index][value]);
                  value1++;
                  storiesPrizes[index][value] = value1.toString();
                } else {
                  value1 = int.parse(vocabPrizes[index][value]);
                  value1++;
                  vocabPrizes[index][value] = value1.toString();
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
