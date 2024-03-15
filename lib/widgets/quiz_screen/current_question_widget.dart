// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:bdh/server/image_url.dart';
import 'package:bdh/widgets/quiz_screen/current_question_slides/delete_slide.dart';
import 'package:bdh/widgets/quiz_screen/current_question_slides/turn_to_image_slide.dart';
import 'package:bdh/widgets/quiz_screen/current_question_slides/turn_to_text_slide.dart';
import 'package:bdh/widgets/quiz_screen/current_question_slides/update_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../controllers/quiz_controller.dart';
import '../../styles/app_colors.dart';

class CurrentQuestionWidget extends StatefulWidget {
  CurrentQuestionWidget(
      {super.key,
      required this.index,
      required this.mediaQuery,
      required this.testId});
  final String testId;
  final int index;
  final Size mediaQuery;

  @override
  State<CurrentQuestionWidget> createState() => _CurrentQuestionWidgetState();
}

class _CurrentQuestionWidgetState extends State<CurrentQuestionWidget> {
  late TextEditingController currentQuestionController;

  final formKey = GlobalKey<FormState>();

  FocusNode currentQuestionNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: 1 / 2,
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          DeleteSlide(index: widget.index, testId: widget.testId),
          UpdateSlide(
            testId: widget.testId,
            index: widget.index,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          TurnToTextSlide(index: widget.index, testId: widget.testId),
          TurnToImageSlide(
              index: widget.index,
              testId: widget.testId,
              mediaQuery: widget.mediaQuery)
        ],
      ),
      child: Container(
          width: widget.mediaQuery.width / 1.1,
          padding: EdgeInsets.symmetric(
              horizontal: widget.mediaQuery.width / 30,
              vertical: widget.mediaQuery.height / 40),
          margin:
              EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 30),
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.amber, width: 2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuizController.questions[widget.index]['data']['is_image'] == 0
                  ? Text(
                      QuizController.questions[widget.index]['data']
                          ['text_url'],
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.main, fontWeight: FontWeight.bold),
                    )
                  : Image(
                      image: NetworkImage(
                        '${ImageUrl.imageUrl}${QuizController.questions[widget.index]['data']['text_url']}',
                      ),
                      fit: BoxFit.contain,
                    ),
              SizedBox(
                height: widget.mediaQuery.height / 70,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      QuizController.questions[widget.index]['data']
                                  ['allOrNothing'] ==
                              1
                          ? 'All or nothing'
                          : 'Normal',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: widget.mediaQuery.width / 50,
                    ),
                    Text(
                      '(${QuizController.questions[widget.index]['data']['mark'].toString()} marks)',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
