// ignore_for_file: use_build_context_synchronously

// import 'package:bdh/screens/create_new_section_screen.dart';
import 'package:bdh/screens/all_sections_map_roads_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/english_club_settings_screen/levels_widget.dart';
import 'package:bdh/widgets/english_club_settings_screen/sections_widget.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

// import '../common/transition.dart';
import '../widgets/form_widget copy.dart';

class EnglishClubSettingsScreen extends StatefulWidget {
  const EnglishClubSettingsScreen({super.key});

  @override
  State<EnglishClubSettingsScreen> createState() =>
      _EnglishClubSettingsScreenState();
}

class _EnglishClubSettingsScreenState extends State<EnglishClubSettingsScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isSectionChange = false;
  List allSections = [];
  List allSectionsNames = [];
  String selectedSection = '';
  List levels = [];
  String newSectionName = '';
  String sectionId = '0';

  late AnimationController? controllerAnimation;
  final formKey = GlobalKey<FormState>();
  FocusNode nameNode = FocusNode();
  TextEditingController controller = TextEditingController(text: '');

  @override
  void dispose() {
    nameNode.dispose();
    controller.dispose();
    controllerAnimation!.dispose();
    super.dispose();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).getAllSections();
      setState(() {
        allSections = Apis.sectionsData;
      });
      setState(() {
        for (int i = 0; i < allSections.length; i++) {
          allSectionsNames.add(allSections[i]['section_name']);
        }
        selectedSection = allSectionsNames[0];
      });
      getSectionData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void getSectionData() async {
    setState(() {
      isSectionChange = true;
    });
    try {
      for (int i = 0; i < allSections.length; i++) {
        if (allSections[i]['section_name'] == selectedSection) {
          sectionId = allSections[i]['section_id'].toString();
        }
      }
      await Provider.of<Apis>(context, listen: false)
          .getSectionInfo(sectionId: sectionId);
      setState(() {
        levels = Apis.sectionInfo['levels'];
        isSectionChange = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    controllerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TitleWidget(
                  mediaQuery: mediaQuery,
                  title: 'English club settings',
                  icon: const SizedBox(
                    width: 0,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height / 3,
                ),
                CircularProgressIndicator(
                  color: AppColors.main,
                ),
              ],
            ),
          )
        : Scaffold(
            floatingActionButton: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllSectionsMapRoadsScreen(
                        allSections: allSections, mediaQuery: mediaQuery),
                  ),
                );
              },
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width / 30,
                      vertical: mediaQuery.height / 50),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.amber),
                  child: Image(
                    image: const AssetImage('assets/images/road.png'),
                    height: mediaQuery.height / 30,
                    width: mediaQuery.width / 15,
                  )),
            ),
            appBar: AppBar(
              backgroundColor: AppColors.main,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    // Navigator.pushReplacement(context,
                    //     customPageRouteBuilder(const CreateSectionScreen()));
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.custom,
                        title: 'Add new section',
                        widget: Form(
                          key: formKey,
                          child: FormWidget(
                            controller: controller,
                            textInputType: TextInputType.text,
                            isNormal: true,
                            obscureText: false,
                            togglePasswordVisibility: () {},
                            mediaQuery: mediaQuery,
                            textInputAction: TextInputAction.done,
                            labelText: 'section name',
                            hintText: 'EX: national geographic',
                            focusNode: nameNode,
                            nextNode: nameNode,
                            validationFun: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter section name please";
                              } else if (value.length < 2) {
                                return 'You have to enter 2 character at least';
                              }
                              setState(() {
                                newSectionName = value;
                              });
                              return null;
                            },
                          ),
                        ),
                        confirmBtnText: 'Create',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () async {
                          if (formKey.currentState!.validate()) {
                            await Provider.of<Apis>(context, listen: false)
                                .createNewSection(sectionName: newSectionName);
                            Navigator.of(context).pop();
                            Apis.statusResponse == 200
                                ? QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    confirmBtnText: 'Ok',
                                    onConfirmBtnTap: () {
                                      allSections.clear();
                                      allSectionsNames.clear();
                                      levels.clear();
                                      getData();
                                    },
                                    text: Apis.message,
                                  )
                                : QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: Apis.message,
                                    confirmBtnText: 'Cancel',
                                    confirmBtnColor: Colors.red,
                                    onConfirmBtnTap: () {
                                      Navigator.pop(context);
                                    });
                          }
                        });
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'new section',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            body: Hero(
              tag: 'tag1',
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TitleWidget(
                      mediaQuery: mediaQuery,
                      title: 'English club settings',
                      icon: const SizedBox(
                        width: 0,
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 80,
                    ),
                    //section filter
                    SectionsWidget(
                      mediaQuery: mediaQuery,
                      allSectionsNames: allSectionsNames,
                      selectedSection: selectedSection,
                      sectionId: sectionId,
                      onChangedFilter: (value) {
                        controllerAnimation!.reverse().whenComplete(
                          () {
                            setState(() {
                              selectedSection = value!;
                              getSectionData();
                            });
                            controllerAnimation!.forward();
                          },
                        );
                      },
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        allSections.clear();
                        allSectionsNames.clear();
                        levels.clear();
                        getData();
                      },
                    ),
                    SizedBox(
                      height: mediaQuery.height / 90,
                    ),
                    isSectionChange
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.main,
                            ),
                          )
                        : SizedBox(
                                height: mediaQuery.height / 1.3,
                                child: LevelsWidget(
                                    levels: levels, mediaQuery: mediaQuery))
                            .animate(controller: controllerAnimation)
                            .slide(
                                begin: const Offset(0, 1),
                                end: const Offset(0, 0),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOutCirc),
                  ],
                ),
              ),
            ),
          );
  }
}
