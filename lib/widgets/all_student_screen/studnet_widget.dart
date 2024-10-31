// import 'package:bdh/data/data.dart';
// ignore_for_file: use_build_context_synchronously

// import 'dart:io';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bdh/common/dialogs/dialogs.dart';
import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/data/data.dart';
import 'package:bdh/screens/all_sections_map_roads_screen.dart';
import 'package:bdh/server/image_url.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/all_student_screen/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../server/apis.dart';
import '../form_widget copy.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

// ignore: must_be_immutable
class StudentWidget extends StatefulWidget {
  StudentWidget(
      {super.key,
      required this.mediaQuery,
      required this.searchStudentList,
      required this.index,
      required this.getData,
      required this.refreshData,
      required this.onPressedDelete,
      required this.onPressedActive,
      required this.allClassesInGrade,
      required this.allGrades,
      required this.selectedClassFilterValue,
      required this.selectedGradeFilterValue});
  Function getData;
  Function refreshData;
  Size mediaQuery;
  List searchStudentList;
  int index;
  final void Function(BuildContext)? onPressedDelete;
  final void Function(BuildContext)? onPressedActive;
  final List allClassesInGrade;
  final List allGrades;
  final String selectedClassFilterValue;
  final String selectedGradeFilterValue;

  @override
  State<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentBookLimitController = TextEditingController();
  FocusNode studentNameNode = FocusNode();
  FocusNode studentBookLimitNode = FocusNode();
  // static File? studentImage;
  List allClassesInGrade1 = [];
  List allGrades1 = [];
  String selectedClassFilterValue1 = '';
  String selectedGradeFilterValue1 = '';

  late int classId;

  Future<void> changeId() async {
    print(selectedClassFilterValue1);
    print(selectedGradeFilterValue1);
    print(dataClass.students);
    print(allGrades1);
    print(allClassesInGrade1);
    int selectedGradeIndex = dataClass.students
        .indexWhere((element) => element['name'] == selectedGradeFilterValue1);
    allClassesInGrade1.clear();
    for (int i = 0;
        i < dataClass.students[selectedGradeIndex]['classes'].length;
        i++) {
      allClassesInGrade1
          .add(dataClass.students[selectedGradeIndex]['classes'][i]['name']);
    }
    classId = dataClass.students
        .where((element) => element['name'] == selectedGradeFilterValue1)
        .toList()[0]['classes']
        .where((e) => e['name'] == selectedClassFilterValue1)
        .toList()[0]['id'];
    print(classId);
  }

  Future<void> confirmBorrowBook(String title, String result) async {
    AwesomeDialog(
        context: context,
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 30),
          child: Column(
            children: [
              Text(
                'Are you sure you want to confirm ${widget.searchStudentList[widget.index]['name']} to borrow ($title) ?\n Please confirm to proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 30),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 50,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: widget.mediaQuery.width / 3,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        loadingDialog(
                            context: context,
                            mediaQuery: widget.mediaQuery,
                            title: 'Loading...');
                        if (await Provider.of<Apis>(context, listen: false)
                            .borrowBook(
                                studentId: widget
                                    .searchStudentList[widget.index]['id']
                                    .toString(),
                                qrCode: result)) {
                          Navigator.pop(context);
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            title: 'Scan result',
                            text: showBookController.message,
                            confirmBtnText: 'Cancel',
                            confirmBtnColor: Colors.grey,
                          );
                        } else {
                          Navigator.pop(context);

                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Scan result',
                            text: Apis.message,
                            confirmBtnText: 'Cancel',
                            confirmBtnColor: Colors.grey,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 20,
                          vertical: widget.mediaQuery.height / 80,
                        ),
                      ),
                      child: const Text(
                        'Borrow',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.mediaQuery.width / 50,
                  ),
                  SizedBox(
                    width: widget.mediaQuery.width / 3,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 20,
                          vertical: widget.mediaQuery.height / 80,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: widget.mediaQuery.height / 50,
              ),
            ],
          ),
        )).show();
  }

  Future<void> confirmReturnBook(String title, String result) async {
    AwesomeDialog(
        context: context,
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 30),
          child: Column(
            children: [
              Text(
                'Are you sure you want to confirm ${widget.searchStudentList[widget.index]['name']} to return ($title) ?\n Please confirm to proceed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width / 30),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 50,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: widget.mediaQuery.width / 3,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        loadingDialog(
                            context: context,
                            mediaQuery: widget.mediaQuery,
                            title: 'Loading...');
                        if (await Provider.of<Apis>(context, listen: false)
                            .returnBook(
                                studentId: widget
                                    .searchStudentList[widget.index]['id']
                                    .toString(),
                                qrCode: result)) {
                          Navigator.pop(context);
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            title: 'Scan result',
                            text: showBookController.message,
                            confirmBtnText: 'Cancel',
                            confirmBtnColor: Colors.grey,
                          );
                        } else {
                          Navigator.pop(context);

                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Scan result',
                            text: showBookController.message,
                            confirmBtnText: 'Cancel',
                            confirmBtnColor: Colors.grey,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 20,
                          vertical: widget.mediaQuery.height / 80,
                        ),
                      ),
                      child: const Text(
                        'Return',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: widget.mediaQuery.width / 50,
                  ),
                  SizedBox(
                    width: widget.mediaQuery.width / 3,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 20,
                          vertical: widget.mediaQuery.height / 80,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: widget.mediaQuery.height / 50,
              ),
            ],
          ),
        )).show();
  }

  Future<void> borrowBook() async {
    Navigator.pop(context);
    late ScanResult result;
    print('----------------------------------');
    try {
      result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': 'cancel',
            'flash_on': 'on',
            'flash_off': 'off',
          },
        ),
      );
      print('----------------------------------');
      print('row content => ${result.rawContent}');
      print('normal result ${result}');
      String decodedData = utf8.decode(base64Url.decode(result.rawContent));
      print('decoded result ${decodedData}');
      print('@#\$\$#@');
      print('story name is ${decodedData.split('@#\$\$#@')}');
      print('----------------------------------');
      confirmBorrowBook(
          decodedData.split('@#\$\$#@')[1], decodedData.split('@#\$\$#@')[2]);
    } catch (e) {
      print('----------------------------------');
      print('----------------------------------');
    }
    if (!mounted) return;
  }

  Future<void> returnBook() async {
    Navigator.pop(context);
    print('----------------------------------');
    late ScanResult result;
    try {
      result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': 'cancel',
            'flash_on': 'on',
            'flash_off': 'off',
          },
        ),
      );
      print('----------------------------------');
      print('----------------------------------');
      print('row content => ${result.rawContent}');
      print('normal result ${result}');
      String decodedData = utf8.decode(base64Url.decode(result.rawContent));
      print('decoded result ${decodedData}');
      print('@#\$\$#@');
      print('story name is ${decodedData.split('@#\$\$#@')}');
      print('----------------------------------');
      confirmReturnBook(
          decodedData.split('@#\$\$#@')[1], decodedData.split('@#\$\$#@')[2]);
      print('----------------------------------');
    } catch (e) {
      print('----------------------------------');
      print('----------------------------------');
    }
    if (!mounted) return;
  }

  final formKey = GlobalKey<FormState>();

  void updateStudentDialog(BuildContext context) {
    AwesomeDialog(
        context: context,
        body: Form(
          key: formKey,
          child: Column(
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     showModalBottomSheet(
              //       context: context,
              //       builder: (context1) {
              //         return SizedBox(
              //           height: widget.mediaQuery.height / 5,
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(
              //                 horizontal: widget.mediaQuery.width / 5),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 InkWell(
              //                   onTap: () {
              //                     pickImageFromCamera(context);
              //                   },
              //                   child: Column(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Container(
              //                         padding: EdgeInsets.all(
              //                             widget.mediaQuery.height / 80),
              //                         decoration: BoxDecoration(
              //                           border:
              //                               Border.all(color: AppColors.main),
              //                           borderRadius: const BorderRadius.all(
              //                             Radius.circular(15),
              //                           ),
              //                         ),
              //                         child: Icon(
              //                           Icons.camera,
              //                           color: AppColors.main,
              //                           size: widget.mediaQuery.height / 15,
              //                         ),
              //                       ),
              //                       Text(
              //                         'Camera',
              //                         style: TextStyle(
              //                             color: AppColors.main,
              //                             fontWeight: FontWeight.bold),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 InkWell(
              //                   onTap: () {
              //                     pickImageFromGallery(context);
              //                   },
              //                   child: Column(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Container(
              //                         padding: EdgeInsets.all(
              //                             widget.mediaQuery.height / 80),
              //                         decoration: BoxDecoration(
              //                           border:
              //                               Border.all(color: AppColors.main),
              //                           borderRadius: const BorderRadius.all(
              //                             Radius.circular(15),
              //                           ),
              //                         ),
              //                         child: Icon(
              //                           Icons.image,
              //                           color: AppColors.main,
              //                           size: widget.mediaQuery.height / 15,
              //                         ),
              //                       ),
              //                       Text(
              //                         'Gallery',
              //                         style: TextStyle(
              //                             color: AppColors.main,
              //                             fontWeight: FontWeight.bold),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(primary: Colors.green),
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: widget.mediaQuery.width / 10,
              //       vertical: widget.mediaQuery.height / 60,
              //     ),
              //     child: const Text(
              //       'change student image',
              //       style: TextStyle(
              //           color: Colors.white, fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: widget.mediaQuery.height / 60,
              // ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (await Provider.of<Apis>(context, listen: false)
                      .deleteAdminImage(
                          studentId: widget.searchStudentList[widget.index]
                                  ['id']
                              .toString(),
                          DeleteImage: '1')) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'update result',
                      text: showBookController.message,
                      confirmBtnText: 'ok',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        widget.refreshData();
                      },
                      confirmBtnColor: Colors.grey,
                    );
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'update result',
                      text: showBookController.message,
                      confirmBtnText: 'Cancel',
                      confirmBtnColor: Colors.grey,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10,
                    vertical: widget.mediaQuery.height / 60,
                  ),
                  child: const Text(
                    'delete student image',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 60,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilterWidget(
                      width: widget.mediaQuery.width / 2.3,
                      mediaQuery: widget.mediaQuery,
                      menu: allClassesInGrade1,
                      onChanged: (String? newValue) {
                        selectedClassFilterValue1 = newValue!;
                        changeId();
                        Navigator.pop(context);
                        updateStudentDialog(context);
                      },
                      value: selectedClassFilterValue1,
                      filterTitle: 'Class',
                    ),
                    SizedBox(
                      width: widget.mediaQuery.width / 40,
                    ),
                    FilterWidget(
                      width: widget.mediaQuery.width / 2.3,
                      mediaQuery: widget.mediaQuery,
                      menu: allGrades1,
                      onChanged: (String? newValue) async {
                        if (newValue != 'All') {
                          selectedGradeFilterValue1 = newValue!;
                          await changeId();
                          Navigator.pop(context);
                          updateStudentDialog(context);
                        } else {
                          return;
                        }
                      },
                      value: selectedGradeFilterValue1,
                      filterTitle: 'Grade',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 60,
              ),
              FormWidget(
                controller: studentNameController,
                textInputType: TextInputType.text,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.next,
                labelText: 'student name',
                hintText: 'EX: ahmad mmm',
                focusNode: studentNameNode,
                nextNode: studentBookLimitNode,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter student name";
                  } else if (value.length < 3) {
                    return 'You have to enter 3 character at least';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: widget.mediaQuery.height / 60,
              ),
              FormWidget(
                controller: studentBookLimitController,
                textInputType: TextInputType.text,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.next,
                labelText: 'borrow limit',
                hintText: 'EX: 3',
                focusNode: studentBookLimitNode,
                nextNode: studentBookLimitNode,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter borrow limit";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: widget.mediaQuery.height / 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.loading,
                    text: showBookController.message,
                    confirmBtnColor: Colors.grey,
                  );
                  if (await Provider.of<Apis>(context, listen: false)
                      .updateStudentData(
                    studentId:
                        widget.searchStudentList[widget.index]['id'].toString(),
                    studentName: studentNameController.text,
                    borrowLimit: studentBookLimitController.text,
                    g_class_id: classId,
                  )) {
                    Navigator.pop(context);

                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'update result',
                      text: showBookController.message,
                      confirmBtnText: 'ok',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        widget.refreshData();
                      },
                      confirmBtnColor: Colors.grey,
                    );
                  } else {
                    Navigator.pop(context);

                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'update result',
                      text: showBookController.message,
                      confirmBtnText: 'Cancel',
                      confirmBtnColor: Colors.grey,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 40,
                    vertical: widget.mediaQuery.height / 60,
                  ),
                  child: const Text(
                    'update',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 40,
              ),
            ],
          ),
        )).show();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: 1 / 2,
          dragDismissible: false,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: widget.onPressedDelete,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            widget.searchStudentList[widget.index]['inactive'] == 0
                ? SlidableAction(
                    onPressed: widget.onPressedActive,
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    icon: Icons.person,
                    label: 'Active',
                  )
                : SlidableAction(
                    onPressed: widget.onPressedActive,
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.person_off,
                    label: 'inActive',
                  ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (con) {
                widget.searchStudentList[widget.index]['inactive'] == 0
                    ? QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text:
                            'You can not borrow book to this account until you active it again',
                        confirmBtnText: 'cancel')
                    : AwesomeDialog(
                        context: context,
                        body: Column(
                          children: [
                            Text(
                              widget.searchStudentList[widget.index]['name'],
                              style: TextStyle(
                                color: AppColors.main,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: widget.mediaQuery.height / 50,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                borrowBook();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                padding: EdgeInsets.symmetric(
                                  horizontal: widget.mediaQuery.width / 8,
                                  vertical: widget.mediaQuery.height / 50,
                                ),
                              ),
                              child: const Text(
                                'Borrow book',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: widget.mediaQuery.height / 50,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                returnBook();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: widget.mediaQuery.width / 8,
                                  vertical: widget.mediaQuery.height / 50,
                                ),
                              ),
                              child: const Text(
                                'Return book',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: widget.mediaQuery.height / 50,
                            ),
                          ],
                        )).show();
              },
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              icon: Iconsax.scan,
              label: 'scan book',
            ),
          ],
        ),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.white,
          subtitle: widget.searchStudentList[widget.index]['inactive'] == 0
              ? Text(
                  '${widget.searchStudentList[widget.index]['gradeName'].toString()} \\ ${widget.searchStudentList[widget.index]['className'].toString()} \\ InActive')
              : Text(
                  '${widget.searchStudentList[widget.index]['gradeName'].toString()} \\ ${widget.searchStudentList[widget.index]['className'].toString()} \\ Active'),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor:
                widget.searchStudentList[widget.index]['inactive'] == 0
                    ? Colors.red
                    : Colors.green,
            child: widget.searchStudentList[widget.index]['profile_picture'] !=
                    null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${ImageUrl.imageUrl}${widget.searchStudentList[widget.index]['profile_picture']}',
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    radius: 23,
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
          ),
          title: Text(
            widget.searchStudentList[widget.index]['name'],
            style: const TextStyle(fontSize: 18),
          ),
          children: [
            //score
            ListTile(
              title: const Text(
                'Score',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/studentScore.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing: Text(
                  widget.searchStudentList[widget.index]['score'].toString()),
            ),
            //golden cards
            ListTile(
              title: const Text(
                'Golden cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/golden.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing: Text(widget.searchStudentList[widget.index]
                      ['golden_coins']
                  .toString()),
            ),
            //silver cards
            ListTile(
              title: const Text(
                'Silver cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/silver.png'),
                height: widget.mediaQuery.height / 25,
              ),
              trailing: Text(widget.searchStudentList[widget.index]
                      ['silver_coins']
                  .toString()),
            ),
            //bronze cards
            ListTile(
              title: const Text(
                'Bronze cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: AssetImage('assets/images/bronze.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing: Text(widget.searchStudentList[widget.index]
                      ['bronze_coins']
                  .toString()),
            ),
            //books limit
            ListTile(
              title: const Text(
                'Limit borrow books',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/borrowBook.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing: Text(widget.searchStudentList[widget.index]
                      ['borrow_limit']
                  .toString()),
            ),

            //finished stories
            ListTile(
              title: const Text(
                'Finished stories',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage(
                    'assets/images/finishedStudentStories.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing: Text(widget.searchStudentList[widget.index]
                      ['finishedStoriesCount']
                  .toString()),
            ),
            //finished levels
            ListTile(
              title: const Text(
                'Finished Levels',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/studentLevel.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing: Text(widget.searchStudentList[widget.index]
                      ['finishedLevelsCount']
                  .toString()),
            ),
            //buttons
            ListTile(
              leading: Padding(
                padding: EdgeInsets.only(left: widget.mediaQuery.width / 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        studentNameController = TextEditingController(
                            text: widget.searchStudentList[widget.index]['name']
                                .toString());
                        studentBookLimitController = TextEditingController(
                            text: widget.searchStudentList[widget.index]
                                    ['borrow_limit']
                                .toString());
                        allGrades1 = widget.allGrades;
                        allClassesInGrade1 = widget.allClassesInGrade;
                        selectedClassFilterValue1 =
                            widget.selectedClassFilterValue;
                        selectedGradeFilterValue1 =
                            widget.selectedGradeFilterValue;
                        await changeId();
                        updateStudentDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 30,
                          vertical: widget.mediaQuery.height / 60,
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: widget.mediaQuery.width / 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AllSectionsMapRoadsScreen(
                              studentData:
                                  widget.searchStudentList[widget.index],
                              studentId: widget.searchStudentList[widget.index]
                                      ['id']
                                  .toString(),
                              allSections: [],
                              mediaQuery: widget.mediaQuery),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 30,
                          vertical: widget.mediaQuery.height / 60,
                        ),
                        child: const Text(
                          'road map',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
