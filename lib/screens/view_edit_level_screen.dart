// ignore_for_file: use_build_context_synchronously

import 'package:bdh/screens/admin_quiz_screen.dart';
import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/show_book_screen/float_button_Level_widget.dart';
import 'package:flutter/material.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../common/snack_bar_widget.dart';

import '../server/apis.dart';
import '../widgets/form_widget copy.dart';
import '../widgets/title_widget.dart';

class ViewEditLevelScreen extends StatefulWidget {
  const ViewEditLevelScreen(
      {super.key,
      required this.sectionId,
      required this.sectionName,
      required this.levelId});
  final String sectionName;
  final String sectionId;
  final String levelId;

  @override
  State<ViewEditLevelScreen> createState() => _ViewEditLevelScreenState();
}

class _ViewEditLevelScreenState extends State<ViewEditLevelScreen> {
  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController subQuestionsController =
      TextEditingController(text: '');
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
  FocusNode subQuestionsCountNode = FocusNode();
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
  String subQuestionsCount = '';

  bool isLoading = false;
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

  @override
  void initState() {
    getLevelData();

    super.initState();
  }

  Future<void> getLevelData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false)
          .getLevelData(levelId: widget.levelId, sectionId: widget.sectionId);
      setState(() {
        levelName = Apis.levelData['name'];
        subQuestionsCount = Apis.levelData['subQuestions_count'].toString();
        storiesGoodPer =
            Apis.levelData['c_panel']['good_percentage'].toString();
        storiesVeryGoodPer =
            Apis.levelData['c_panel']['veryGood_percentage'].toString();
        storiesExcellentPer =
            Apis.levelData['c_panel']['excellent_percentage'].toString();
        vocabGoodPer =
            Apis.levelData['c_panel']['vocab_g_percentage'].toString();
        vocabVeryGoodPer =
            Apis.levelData['c_panel']['vocab_vg_percentage'].toString();
        vocabExcellentPer =
            Apis.levelData['c_panel']['vocab_exc_percentage'].toString();
        storiesPrizes[0]['score_points'] =
            Apis.levelData['c_panel']['good_prize']['score_points'].toString();
        storiesPrizes[0]['golden_coin'] =
            Apis.levelData['c_panel']['good_prize']['golden_coin'].toString();
        storiesPrizes[0]['silver_coin'] =
            Apis.levelData['c_panel']['good_prize']['silver_coin'].toString();
        storiesPrizes[0]['bronze_coin'] =
            Apis.levelData['c_panel']['good_prize']['bronze_coin'].toString();
        storiesPrizes[1]['score_points'] = Apis.levelData['c_panel']
                ['very_good_prize']['score_points']
            .toString();
        storiesPrizes[1]['golden_coin'] = Apis.levelData['c_panel']
                ['very_good_prize']['golden_coin']
            .toString();
        storiesPrizes[1]['silver_coin'] = Apis.levelData['c_panel']
                ['very_good_prize']['silver_coin']
            .toString();
        storiesPrizes[1]['bronze_coin'] = Apis.levelData['c_panel']
                ['very_good_prize']['bronze_coin']
            .toString();
        storiesPrizes[2]['score_points'] = Apis.levelData['c_panel']
                ['excellent_prize']['score_points']
            .toString();
        storiesPrizes[2]['golden_coin'] = Apis.levelData['c_panel']
                ['excellent_prize']['golden_coin']
            .toString();
        storiesPrizes[2]['silver_coin'] = Apis.levelData['c_panel']
                ['excellent_prize']['silver_coin']
            .toString();
        storiesPrizes[2]['bronze_coin'] = Apis.levelData['c_panel']
                ['excellent_prize']['bronze_coin']
            .toString();

        vocabPrizes[0]['score_points'] = Apis.levelData['c_panel']
                ['vocab_good_prize']['score_points']
            .toString();
        vocabPrizes[0]['golden_coin'] = Apis.levelData['c_panel']
                ['vocab_good_prize']['golden_coin']
            .toString();
        vocabPrizes[0]['silver_coin'] = Apis.levelData['c_panel']
                ['vocab_good_prize']['silver_coin']
            .toString();
        vocabPrizes[0]['bronze_coin'] = Apis.levelData['c_panel']
                ['vocab_good_prize']['bronze_coin']
            .toString();
        vocabPrizes[1]['score_points'] = Apis.levelData['c_panel']
                ['vocab_very_good_prize']['score_points']
            .toString();
        vocabPrizes[1]['golden_coin'] = Apis.levelData['c_panel']
                ['vocab_very_good_prize']['golden_coin']
            .toString();
        vocabPrizes[1]['silver_coin'] = Apis.levelData['c_panel']
                ['vocab_very_good_prize']['silver_coin']
            .toString();
        vocabPrizes[1]['bronze_coin'] = Apis.levelData['c_panel']
                ['vocab_very_good_prize']['bronze_coin']
            .toString();
        vocabPrizes[2]['score_points'] = Apis.levelData['c_panel']
                ['vocab_excellent_prize']['score_points']
            .toString();
        vocabPrizes[2]['golden_coin'] = Apis.levelData['c_panel']
                ['vocab_excellent_prize']['golden_coin']
            .toString();
        vocabPrizes[2]['silver_coin'] = Apis.levelData['c_panel']
                ['vocab_excellent_prize']['silver_coin']
            .toString();
        vocabPrizes[2]['bronze_coin'] = Apis.levelData['c_panel']
                ['vocab_excellent_prize']['bronze_coin']
            .toString();
      });
      fillTextField();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void fillTextField() {
    titleController = TextEditingController(text: levelName);
    subQuestionsController = TextEditingController(text: subQuestionsCount);
    storyGoodPerController = TextEditingController(text: storiesGoodPer);
    vocabGoodPerController = TextEditingController(text: vocabGoodPer);
    storyVeryGoodPerController =
        TextEditingController(text: storiesVeryGoodPer);
    vocabVeryGoodPerController = TextEditingController(text: vocabVeryGoodPer);
    storyExcellentPerController =
        TextEditingController(text: storiesExcellentPer);
    vocabExcellentPerController =
        TextEditingController(text: vocabExcellentPer);
  }

  bool isUploading = false;
  String message = '';
  Future<void> updateData() async {
    setState(() {
      isUploading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).updateLevel(
          levelId: widget.levelId,
          name: levelName,
          sectionId: widget.sectionId,
          test_subQuestions_count: subQuestionsCount);
      await Provider.of<Apis>(context, listen: false).updateLevelControlP(
        sectionId: widget.sectionId,
        levelId: widget.levelId,
        good_percentage: storiesGoodPer,
        veryGood_percentage: storiesVeryGoodPer,
        excellent_percentage: storiesExcellentPer,
        prizes: storiesPrizes,
        vocab_g_percentage: vocabGoodPer,
        vocab_vg_percentage: vocabVeryGoodPer,
        vocab_exc_percentage: vocabExcellentPer,
        vocabPrizes: vocabPrizes,
      );
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
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
              title: const Text(
                'Level control panel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: Column(
              children: [
                TitleWidget(
                  mediaQuery: mediaQuery,
                  title: '${widget.sectionName} section',
                  icon: const SizedBox(
                    width: 0,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height / 2.1,
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.main,
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            floatingActionButton: FloatButtonLevelWidget(
              testId: Apis.levelData['id'].toString(),
              mediaQuery: mediaQuery,
            ),
            appBar: AppBar(
              backgroundColor: AppColors.main,
              title: const Text(
                'Level control panel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('level name => $levelName');
                        print('story good => $storiesGoodPer');
                        print('story very good => $storiesVeryGoodPer');
                        print('story excellent => $storiesExcellentPer');
                        print('story prizes => $storiesPrizes');
                        print('vocab good => $vocabGoodPer');
                        print('vocab very good => $vocabVeryGoodPer');
                        print('vocab excellent => $vocabExcellentPer');
                        print('vocab prizes => $vocabPrizes');
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text: 'Do you want to update this level data?',
                            confirmBtnColor: Colors.amber,
                            onConfirmBtnTap: (() {
                              updateData();
                            }));
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBarWidget(
                                  title: 'Ops',
                                  message:
                                      'you still have to enter or edit data for this level',
                                  contentType: ContentType.failure)
                              .getSnakBar());
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ))
              ],
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TitleWidget(
                      mediaQuery: mediaQuery,
                      title: '${widget.sectionName} section',
                      icon: const SizedBox(
                        width: 0,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 50,
                    ),
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
                        nextNode: subQuestionsCountNode,
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 10,
                          vertical: mediaQuery.height / 200),
                      child: FormWidget(
                        controller: subQuestionsController,
                        textInputType: TextInputType.number,
                        isNormal: true,
                        obscureText: false,
                        togglePasswordVisibility: () {},
                        mediaQuery: mediaQuery,
                        textInputAction: TextInputAction.next,
                        labelText: 'subQuestions count',
                        hintText: 'EX: 70',
                        focusNode: subQuestionsCountNode,
                        nextNode: storiesGoodPerNode,
                        validationFun: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter title for the level';
                          }
                          setState(() {
                            subQuestionsCount = value;
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
                            if (double.parse(value) > 1 ||
                                double.parse(value) < 0) {
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
                              image:
                                  const AssetImage('assets/images/silver.png'),
                              height: mediaQuery.height / 30,
                            ),
                            true,
                            0,
                            'silver_coin'),
                        buildStatTile(
                            'Bronze cards',
                            Image(
                              image:
                                  const AssetImage('assets/images/bronze.png'),
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
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height / 2000),
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
                            if (double.parse(value) > 1 ||
                                double.parse(value) < 0) {
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
                              image:
                                  const AssetImage('assets/images/silver.png'),
                              height: mediaQuery.height / 30,
                            ),
                            true,
                            1,
                            'silver_coin'),
                        buildStatTile(
                            'Bronze cards',
                            Image(
                              image:
                                  const AssetImage('assets/images/bronze.png'),
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
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height / 2000),
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
                            if (double.parse(value) > 1 ||
                                double.parse(value) < 0) {
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
                              image:
                                  const AssetImage('assets/images/silver.png'),
                              height: mediaQuery.height / 30,
                            ),
                            true,
                            2,
                            'silver_coin'),
                        buildStatTile(
                            'Bronze cards',
                            Image(
                              image:
                                  const AssetImage('assets/images/bronze.png'),
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
                            if (double.parse(value) > 1 ||
                                double.parse(value) < 0) {
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
                              image:
                                  const AssetImage('assets/images/silver.png'),
                              height: mediaQuery.height / 30,
                            ),
                            false,
                            0,
                            'silver_coin'),
                        buildStatTile(
                            'Bronze cards',
                            Image(
                              image:
                                  const AssetImage('assets/images/bronze.png'),
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
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height / 2000),
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
                            if (double.parse(value) > 1 ||
                                double.parse(value) < 0) {
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
                              image:
                                  const AssetImage('assets/images/silver.png'),
                              height: mediaQuery.height / 30,
                            ),
                            false,
                            1,
                            'silver_coin'),
                        buildStatTile(
                            'Bronze cards',
                            Image(
                              image:
                                  const AssetImage('assets/images/bronze.png'),
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
                        padding: EdgeInsets.symmetric(
                            vertical: mediaQuery.height / 2000),
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
                            if (double.parse(value) > 1 ||
                                double.parse(value) < 0) {
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
                              image:
                                  const AssetImage('assets/images/silver.png'),
                              height: mediaQuery.height / 30,
                            ),
                            false,
                            2,
                            'silver_coin'),
                        buildStatTile(
                            'Bronze cards',
                            Image(
                              image:
                                  const AssetImage('assets/images/bronze.png'),
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

                    SizedBox(
                      height: mediaQuery.height / 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => AdminQuizScreen(
                              testId: Apis.levelData['id'].toString()),
                        ));
                      },
                      style: ElevatedButton.styleFrom(primary: AppColors.main),
                      child: const Text(
                        'Show level quiz',
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
