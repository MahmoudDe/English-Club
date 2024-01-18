// import 'package:bdh/data/data.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:quickalert/quickalert.dart';

// ignore: must_be_immutable
class StudentWidget extends StatefulWidget {
  StudentWidget(
      {super.key,
      required this.mediaQuery,
      required this.searchStudentList,
      required this.index,
      required this.getData,
      required this.onPressedDelete,
      required this.onPressedActive});
  Function getData;
  Size mediaQuery;
  List searchStudentList;
  int index;
  final void Function(BuildContext)? onPressedDelete;
  final void Function(BuildContext)? onPressedActive;

  @override
  State<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  String _scanQrResult = '';

  Future<void> scanQr() async {
    print('----------------------------------');
    String qrResult;
    try {
      qrResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print('----------------------------------');
      print(qrResult);
      print('----------------------------------');
    } catch (e) {
      print('----------------------------------');
      qrResult = 'Failed to get platform version';
      print('----------------------------------');
    }
    if (!mounted) return;
    setState(() {
      _scanQrResult = qrResult;
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Scan result',
      text: _scanQrResult,
      confirmBtnText: 'Cancel',
      confirmBtnColor: Colors.grey,
    );
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
                    : scanQr();
              },
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              icon: Iconsax.scan,
              label: 'borrow book',
            ),
          ],
        ),
        child: ExpansionTile(
          collapsedBackgroundColor:
              widget.searchStudentList[widget.index]['inactive'] == 0
                  ? Colors.blueAccent
                  : Colors.white,
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                '${dataClass.urlHost}${widget.searchStudentList[widget.index]['profile_picture']}',
              ),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              radius: 23,
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
              leading: const Icon(
                Icons.star_rounded,
                color: Colors.amber,
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
                height: widget.mediaQuery.height / 30,
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
            //finished stories
            ListTile(
              title: const Text(
                'Finished stories',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.book,
                color: Colors.amber,
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
              leading: const Icon(
                Iconsax.level,
                color: Colors.amber,
              ),
              trailing: Text(widget.searchStudentList[widget.index]
                      ['finishedStoriesCount']
                  .toString()),
            ),
          ],
        ),
      ),
    );
  }
}
