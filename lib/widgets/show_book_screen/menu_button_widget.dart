// // ignore_for_file: unrelated_type_equality_checks

// import 'package:bdh/controllers/show_book_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:quickalert/quickalert.dart';

// import '../../screens/english_club_settings_screen.dart';

// class MenuButtonWidget extends StatelessWidget {
//   const MenuButtonWidget({super.key, required this.mediaQuery});
//   final Size mediaQuery;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: mediaQuery.width / 100,
//           vertical: mediaQuery.height / 100),
//       child: PopupMenuButton<String>(
//         icon: Icon(
//           Icons.menu,
//           size: mediaQuery.width / 15,
//           color: Colors.white,
//         ),
//         itemBuilder: (BuildContext context) {
//           return [
//             PopupMenuItem<String>(
//               value: 'Delete story',
//               child: TextButton.icon(
//                 label: const Text(
//                   'Delete story',
//                   style:
//                       TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
//                 ),
//                 onPressed: () {
//                   QuickAlert.show(
//                       context: context,
//                       type: QuickAlertType.warning,
//                       text: 'Do you want to delete this story?',
//                       confirmBtnColor: Colors.amber,
//                       confirmBtnText: 'Yes',
//                       onConfirmBtnTap: () {
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                         if (showBookController().deleteStory() == false) {
//                           QuickAlert.show(
//                             context: context,
//                             type: QuickAlertType.error,
//                             text: showBookController.message,
//                           );
//                         } else {
//                           QuickAlert.show(
//                               context: context,
//                               type: QuickAlertType.success,
//                               text: showBookController.message,
//                               onConfirmBtnTap: () {
//                                 Navigator.pop(context);
//                                 Navigator.of(context)
//                                     .pushReplacement(MaterialPageRoute(
//                                   builder: (context) =>
//                                       const EnglishClubSettingsScreen(),
//                                 ));
//                               });
//                         }
//                       });
//                 },
//                 icon: const Icon(
//                   Icons.logout,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ];
//         },
//       ),
//     );
//   }
// }
