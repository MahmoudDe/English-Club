import 'package:bdh/controllers/quiz_controller.dart';
import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class StudentAnswersWidget extends StatefulWidget {
  const StudentAnswersWidget(
      {super.key,
      required this.index,
      required this.mediaQuery,
      required this.testId});
  final int index;
  final Size mediaQuery;
  final String testId;

  @override
  State<StudentAnswersWidget> createState() => _StudentAnswersWidgetState();
}

class _StudentAnswersWidgetState extends State<StudentAnswersWidget> {
  FocusNode answerNode = FocusNode();
  int mainIndex = 0;
  int currentIndex = 0;
  TextEditingController answerController = TextEditingController();
  int correctAnswers = 0;

  void saveData({required String value}) {
    if (QuizController.filed1Answers.isEmpty) {
      QuizController.filed1Answers
          .add(QuizController.questions[widget.index]['data']['id'].toString());
      QuizController.filed2Answers.add(value);
    } else {
      print(
          'We are looking for this ${QuizController.studentAnswer[mainIndex]['questions'][currentIndex]['id']}');
      for (int i = 0; i < QuizController.filed1Answers.length; i++) {
        if (QuizController.filed1Answers[i] ==
            QuizController.questions[widget.index]['data']['id'].toString()) {
          QuizController.filed2Answers.removeAt(i);
          QuizController.filed2Answers.insert(i, value);
          return;
        }
      }
      QuizController.filed1Answers
          .add(QuizController.questions[widget.index]['data']['id'].toString());
      QuizController.filed2Answers.add(value);
    }
  }

  Future<void> getData() async {
    print('asdf');
    print('data length=> ${QuizController.studentAnswer.length}');
    print(
        'current answer id => ${QuizController.questions[widget.index]['data']['id'].toString()}');
    for (int i = 0;
        i < QuizController.questions[widget.index]['data']['answers'].length;
        i++) {
      if (QuizController.questions[widget.index]['data']['answers'][i]
              ['is_correct'] ==
          1) {
        correctAnswers++;
      }
    }
    for (int i = 0; i < QuizController.studentAnswer.length; i++) {
      if (await QuizController.studentAnswer[i]['testSection_id'].toString() ==
          QuizController.questions[widget.index]['main_id'].toString()) {
        print('step 1');
        for (int j = 0;
            j < QuizController.studentAnswer[i]['questions'].length;
            j++) {
          print('step 2');
          if (QuizController.studentAnswer[i]['questions'][j]['id']
                  .toString() ==
              QuizController.questions[widget.index]['data']['id'].toString()) {
            print('success');
            print('i=>$i');
            print('j=>$j');
            print(
                'data => ${QuizController.questions[widget.index]['main_id']}');
            print(QuizController.studentAnswer[i]);
            setState(() {
              mainIndex = i;
              currentIndex = j;
            });
            return;
          }
        }
      }
    }
    print(QuizController.questions[widget.index]['data']['answers'].length);

    print('We found nothing');
  }

  int fieldIndex = -1;

  @override
  void initState() {
    if (QuizController.filed1Answers.isNotEmpty) {
      fieldIndex = QuizController.filed1Answers.indexWhere((element) =>
          element ==
          QuizController.questions[widget.index]['data']['id'].toString());
      if (fieldIndex != -1) {
        answerController = TextEditingController(
            text: QuizController.filed2Answers[fieldIndex].toString());
      }
    }
    getData();
    if (QuizController.filed1Answers.contains(
        QuizController.questions[widget.index]['data']['id'].toString())) {
      answerController = TextEditingController(
          text: QuizController.filed2Answers[QuizController.filed1Answers
              .indexWhere((element) =>
                  element ==
                  QuizController.questions[widget.index]['data']['id']
                      .toString())]);
    }
    print('Saved data ---------------------================');
    print(QuizController.filed1Answers);
    print(QuizController.filed2Answers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QuizController.questions[widget.index]['data']['answers'].length > 1
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(correctAnswers > 1
                  ? 'This question has $correctAnswers correct answers'
                  : 'This question has just one answer'),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: QuizController
                      .questions[widget.index]['data']['answers'].length,
                  itemBuilder: (context, index1) {
                    return GestureDetector(
                      onTap: () {
                        print(widget.index);
                        print('mainIndex => $mainIndex');
                        print('currentIndex => $currentIndex');
                        print('***************we find this');
                        print(QuizController.studentAnswer[mainIndex]);
                        print(correctAnswers);
                        print(QuizController.questions[widget.index]);
                        setState(() {
                          correctAnswers == 1
                              ? QuizController.studentAnswer[mainIndex]
                                      ['questions'][currentIndex]
                                      ['pickedAnswers']
                                  .clear()
                              : null;
                          QuizController.studentAnswer[mainIndex]['questions']
                                      [currentIndex]['pickedAnswers']
                                  .contains(QuizController.questions[widget.index]
                                      ['data']['answers'][index1]['id'])
                              ? QuizController.studentAnswer[mainIndex]['questions']
                                      [currentIndex]['pickedAnswers']
                                  .remove(QuizController.questions[widget.index]
                                      ['data']['answers'][index1]['id'])
                              : QuizController.studentAnswer[mainIndex]['questions'][currentIndex]['pickedAnswers'].length >=
                                      correctAnswers
                                  ? null
                                  : QuizController.studentAnswer[mainIndex]['questions'][currentIndex]['pickedAnswers'].add(QuizController.questions[widget.index]['data']['answers'][index1]['id']);
                        });
                      },
                      child: Container(
                        width: widget.mediaQuery.width / 1.1,
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.mediaQuery.width / 30,
                            vertical: widget.mediaQuery.height / 70),
                        margin: EdgeInsets.symmetric(
                            horizontal: widget.mediaQuery.width / 30,
                            vertical: widget.mediaQuery.height / 200),
                        decoration: BoxDecoration(
                            color: QuizController.studentAnswer[mainIndex]
                                        ['questions'][currentIndex]
                                        ['pickedAnswers']
                                    .contains(
                                        QuizController.questions[widget.index]
                                            ['data']['answers'][index1]['id'])
                                ? Colors.amber
                                : Colors.white12,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: Colors.amber, width: 2)),
                        child: QuizController.questions[widget.index]['data']
                                    ['answers'][index1]['is_image'] ==
                                0
                            ? Text(
                                QuizController.questions[widget.index]['data']
                                    ['answers'][index1]['text_url'],
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.main,
                                    fontWeight: FontWeight.bold),
                              )
                            : Image(
                                image: NetworkImage(
                                  '${ImageUrl.imageUrl}${QuizController.questions[widget.index]['data']['answers'][index1]['text_url']}',
                                ),
                                fit: BoxFit.contain,
                              ),
                      ),
                    );
                  }),
            ],
          )
        : Padding(
            padding:
                EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 30),
            child: TextFormField(
              controller: answerController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              focusNode: answerNode,
              autocorrect: false, // Disables autocorrect
              enableSuggestions: false,
              validator: (value) {
                return null;
              },
              onChanged: (value) {
                if (value.toLowerCase() ==
                    QuizController.questions[widget.index]['data']['answers'][0]
                            ['text_url']
                        .toLowerCase()) {
                  QuizController.studentAnswer[mainIndex]['questions']
                          [currentIndex]['pickedAnswers']
                      .clear();
                  QuizController.studentAnswer[mainIndex]['questions']
                          [currentIndex]['pickedAnswers']
                      .add(QuizController.questions[widget.index]['data']
                          ['answers'][0]['id']);
                  print(QuizController.questions[widget.index]);
                  print(QuizController.studentAnswer[mainIndex]);
                  saveData(value: value);
                  print('correct');
                } else {
                  QuizController.studentAnswer[mainIndex]['questions']
                          [currentIndex]['pickedAnswers']
                      .clear();
                  QuizController.studentAnswer[mainIndex]['questions']
                          [currentIndex]['pickedAnswers']
                      .add('-1');
                  print(QuizController.questions[widget.index]);
                  print(QuizController.studentAnswer[mainIndex]);
                  saveData(value: value);
                  print('false');
                }
              },
              decoration: InputDecoration(
                labelText: 'Answer',
                labelStyle: const TextStyle(color: Colors.black),
                hintText: 'Enter your answer',
                hintStyle: const TextStyle(color: Colors.black38),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                // Add padding
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2.0),
                ),
              ),
            ),
          );
  }
}
