import 'package:bdh/controllers/quiz_controller.dart';
import 'package:bdh/server/image_url.dart';
import 'package:bdh/widgets/form_widget%20copy.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class AnswersWidget extends StatefulWidget {
  const AnswersWidget(
      {super.key, required this.index, required this.mediaQuery});
  final int index;
  final Size mediaQuery;

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
            itemBuilder: (context, index1) => Container(
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
                      QuizController.questions[widget.index]['data']['answers']
                          [index1]['text_url'],
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
          )
        : Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 30),
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
          );
  }
}
