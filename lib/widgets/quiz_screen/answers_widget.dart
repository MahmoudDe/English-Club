import 'package:bdh/controllers/quiz_controller.dart';
import 'package:bdh/server/image_url.dart';
import 'package:bdh/widgets/form_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../styles/app_colors.dart';
import 'answers_slides/delete_answer_slide.dart';
import 'answers_slides/turn_to_image_answer_slide.dart';
import 'answers_slides/turn_to_text_answer_slide.dart';

class AnswersWidget extends StatefulWidget {
  const AnswersWidget(
      {super.key,
      required this.index,
      required this.mediaQuery,
      required this.testId});
  final int index;
  final Size mediaQuery;
  final String testId;

  @override
  State<AnswersWidget> createState() => _AnswersWidgetState();
}

class _AnswersWidgetState extends State<AnswersWidget> {
  FocusNode answerNode = FocusNode();
  late TextEditingController answerController;
  @override
  void initState() {
    answerController = TextEditingController(
        text: QuizController.questions[widget.index]['data']['answers'][0]
            ['text_url']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QuizController.questions[widget.index]['data']['answers'].length > 1
        ? ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: QuizController
                .questions[widget.index]['data']['answers'].length,
            itemBuilder: (context, index1) => Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                extentRatio: 1 / 2,
                dragDismissible: false,
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  DeleteAnswerSlide(
                    context: context,
                    index: widget.index,
                    testId: widget.testId,
                    answerIndex: index1,
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  TurnToTextAnswerSlide(
                    answerIndex: index1,
                    index: widget.index,
                    testId: widget.testId,
                    context: context,
                  ),
                  TurnToImageAnswerSlide(
                      context: context,
                      answerIndex: index1,
                      index: widget.index,
                      testId: widget.testId,
                      mediaQuery: widget.mediaQuery)
                ],
              ),
              child: Container(
                width: widget.mediaQuery.width / 1.1,
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 30,
                    vertical: widget.mediaQuery.height / 70),
                margin: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 30,
                    vertical: widget.mediaQuery.height / 200),
                decoration: BoxDecoration(
                    color: QuizController.questions[widget.index]['data']
                                ['answers'][index1]['is_correct'] ==
                            1
                        ? Colors.amber
                        : Colors.white12,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.amber, width: 2)),
                child: QuizController.questions[widget.index]['data']['answers']
                            [index1]['is_image'] ==
                        0
                    ? Text(
                        QuizController.questions[widget.index]['data']
                            ['answers'][index1]['text_url'],
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.main, fontWeight: FontWeight.bold),
                      )
                    : Image(
                        image: NetworkImage(
                          '${ImageUrl.imageUrl}${QuizController.questions[widget.index]['data']['answers'][index1]['text_url']}',
                        ),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          )
        : Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 30),
            child: Slidable(
              key: const ValueKey(0),
              startActionPane: ActionPane(
                extentRatio: 1 / 2,
                dragDismissible: false,
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  DeleteAnswerSlide(
                      context: context,
                      index: widget.index,
                      testId: widget.testId,
                      answerIndex: 0),
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  TurnToTextAnswerSlide(
                    answerIndex: 0,
                    index: widget.index,
                    testId: widget.testId,
                    context: context,
                  ),
                  TurnToImageAnswerSlide(
                      context: context,
                      answerIndex: 0,
                      index: widget.index,
                      testId: widget.testId,
                      mediaQuery: widget.mediaQuery)
                ],
              ),
              child: FormWidget(
                  mediaQuery: widget.mediaQuery,
                  labelText: 'answer',
                  hintText: 'Enter your answer',
                  focusNode: answerNode,
                  nextNode: answerNode,
                  validationFun: (value) {
                    if (value!.isEmpty) {
                      return 'You have to enter an answer';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  isNormal: true,
                  obscureText: false,
                  textInputType: TextInputType.name,
                  controller: answerController),
            ),
          );
  }
}
