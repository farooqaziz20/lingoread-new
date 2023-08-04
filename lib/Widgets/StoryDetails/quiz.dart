import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Utils/app_constants.dart';
import 'package:lingoread/Utils/app_funtions.dart';
import 'package:lingoread/Widgets/Buttons/button_main.dart';

import '../../Pages/answer.dart';

class StoryQuiz extends StatefulWidget {
  StoryQuiz(this.listQuestions, {Key? key}) : super(key: key);
  final List listQuestions;
  @override
  State<StoryQuiz> createState() => _StoryQuizState();
}

class _StoryQuizState extends State<StoryQuiz> {
  @override
  void initState() {
    super.initState();
    setIntials();
  }

  setIntials() {
    List listQuestion = [];

    widget.listQuestions.forEach((element) {
      List answers = [];
      answers.add({
        "key": "Answer1",
        "answer": (element["answer_option"] ?? {})["Answer1"] ?? "",
        "istrue": ""
      });
      answers.add({
        "key": "Answer2",
        "answer": (element["answer_option"] ?? {})["Answer2"] ?? "",
        "istrue": ""
      });
      answers.add({
        "key": "Answer3",
        "answer": (element["answer_option"] ?? {})["Answer3"] ?? "",
        "istrue": ""
      });
      var question = {
        "id": element["id"],
        "title": element["title"],
        "type": element["type"],
        "answer_option": answers,
        "answer_index": element["answer_index"],
      };
      listQuestion.add(question);
    });
    setState(() {
      progressIncrement = 100 / widget.listQuestions.length;
      totalQuestions = widget.listQuestions.length;
      progress += 100 / widget.listQuestions.length;
      listQuestionstoDisplay = listQuestion;
    });
  }

  List listQuestionstoDisplay = [];
  int _questionIndex = 0;
  int totalQuestions = 1;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  double progress = 0;
  double progressIncrement = 0;
  List answers = [];
  questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }

      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      resetQuiz();
    }
  }

  resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;

      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (listQuestionstoDisplay.isNotEmpty)
            Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                  if (listQuestionstoDisplay.isNotEmpty &&
                      _questionIndex < listQuestionstoDisplay.length)
                    _questionwithOpitions(
                        listQuestionstoDisplay[_questionIndex],
                        context,
                        _questionIndex),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppConst.padding * 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${_questionIndex + 1} / $totalQuestions",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Container(
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffffffff)),
                    margin:
                        EdgeInsets.symmetric(horizontal: AppConst.padding * 1),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: SizedBox(
                          width: ((Get.width - AppConst.padding * 2) / 100) *
                              progress,
                          child: Image.asset(
                            ThemeController.to.isDark.isTrue
                                ? 'assets/images/progress_dark.png'
                                : 'assets/images/progress_light.png',
                            fit: BoxFit.fitHeight,
                            height: 15,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xffffffff)),
                      ))
                    ]),
                  ),
                  endOfQuiz
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical: AppConst.padding * 1,
                              horizontal: AppConst.padding * 1),
                          child: Text((_totalScore / totalQuestions >= 0.5)
                              ? 'Congratulations! Your final score is: $_totalScore'
                              : 'Your final score is: $_totalScore. Better luck next time!'),
                        )
                      : Padding(
                          padding: EdgeInsets.all(AppConst.padding),
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: "Submit",
                              onPressed: () async {
                                if (listQuestionstoDisplay[_questionIndex]
                                        ["answeres"] ??
                                    false) {
                                  if (_questionIndex + 1 == totalQuestions) {
                                    int total = 0;

                                    for (int i = 0;
                                        i < listQuestionstoDisplay.length;
                                        i++) {
                                      if (listQuestionstoDisplay[i]
                                              ["answer_index"] ==
                                          listQuestionstoDisplay[i]
                                              ["selectedIndex"]) {
                                        total += 1;
                                      }
                                    }

                                    setState(() {
                                      _totalScore = total;
                                      endOfQuiz = true;
                                    });
                                  } else {
                                    setState(() {
                                      _questionIndex++;
                                    });
                                  }
                                } else {
                                  AppFunctions.showSnackBar(
                                      "Error", "Question Not Answered");
                                }

                                // login();
                              },
                            ),
                          ),
                        ),
                  // SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     minimumSize: Size(double.infinity, 40.0),
                  //   ),
                  //   onPressed: () {
                  //     if (!answerWasSelected) {
                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //         content: Text(
                  //             'Please select an answer before going to the next question'),
                  //       ));
                  //       return;
                  //     }
                  //     nextQuestion();
                  //   },
                  //   child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.all(20.0),
                  //   child: Text(
                  //     '${_totalScore.toString()}/${_questions.length}',
                  //     style:
                  //         TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // if (answerWasSelected && !endOfQuiz)
                  //   Container(
                  //     height: 100,
                  //     width: double.infinity,
                  //     color: correctAnswerSelected ? Colors.green : Colors.red,
                  //     child: Center(
                  //       child: Text(
                  //         correctAnswerSelected
                  //             ? 'Well done, you got it right!'
                  //             : 'Wrong :/',
                  //         style: TextStyle(
                  //           fontSize: 20.0,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // if (endOfQuiz)
                  //   Container(
                  //     height: 100,
                  //     width: double.infinity,
                  //     color: Colors.black,
                  //     child: Center(
                  //       child: Text(
                  //         _totalScore > 2
                  //             ? 'Congratulations! Your final score is: $_totalScore'
                  //             : 'Your final score is: $_totalScore. Better luck next time!',
                  //         style: TextStyle(
                  //           fontSize: 20.0,
                  //           fontWeight: FontWeight.bold,
                  //           color: _totalScore > 4 ? Colors.green : Colors.red,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          if (listQuestionstoDisplay.isEmpty)
            Padding(
              padding: EdgeInsets.all(AppConst.padding),
              child: Text("No Quiz Available"),
            )
        ],
      ),
    );
  }

  _questionwithOpitions(dynamic obj, BuildContext context, int q_index) {
    List listOptions = obj['answer_option'];
    int selectedAnswer = -1;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppConst.padding * 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  obj['title'].toString(),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontFamily: GoogleFonts.raleway().fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: AppConst.padding * 1, horizontal: AppConst.padding * 1),
          child: Wrap(children:
                  //  listOptions
                  //     .map((e) =>
                  [
            for (int i = 0; i < listOptions.length; i++)
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: AppConst.padding * 0.2,
                    vertical: AppConst.padding * 0.1),
                child: InkWell(
                  onTap: () {
                    print("++++++++++++++");
                    setState(() {
                      listQuestionstoDisplay[q_index]["answeres"] = true;
                      listQuestionstoDisplay[q_index]["selectedIndex"] =
                          i.toString();

                      for (int j = 0; j < listOptions.length; j++) {
                        if (i == j) {
                          listOptions[j]["selected"] = true;
                        } else {
                          listOptions[j]["selected"] = false;
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConst.padding * 0.8,
                        vertical: AppConst.padding * 0.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (listOptions[i]["selected"] ?? false)
                            ? ThemeController.to.isDark.isTrue
                                ? AppConst.dark_colorPrimaryDark
                                : Theme.of(context).primaryColor
                            : Color(0xffffffff)),
                    child: Text(
                      listOptions[i]["answer"],
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: (listOptions[i]["selected"] ?? false)
                              ? ThemeController.to.isDark.isTrue
                                  ? AppConst.colorPrimaryLightv3_1BA0C1
                                  : Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              )
          ]
              // )
              // .toList() as List<Widget>,
              ),
        ),
      ],
    );
  }
}

final _questions = [
  {
    'question': 'How long is New Zealand’s Ninety Mile Beach?',
    'answers': [
      {'answerText': '88km', 'score': true},
      {'answerText': '55km', 'score': false},
      {'answerText': '90km', 'score': false},
    ],
  },
  {
    'question':
        'In which month does the German festival of Oktoberfest mostly take place?',
    'answers': [
      {'answerText': 'January', 'score': false},
      {'answerText': 'October', 'score': false},
      {'answerText': 'September', 'score': true},
    ],
  },
  {
    'question': 'Who composed the music for Sonic the Hedgehog 3?',
    'answers': [
      {'answerText': 'Britney', 'score': false},
      {'answerText': 'Timbaland', 'score': false},
      {'answerText': 'Michael', 'score': true},
    ],
  },
  {
    'question': 'In Georgia (the state), it’s illegal to eat what with a fork?',
    'answers': [
      {'answerText': 'Hamburgers', 'score': false},
      {'answerText': 'chicken', 'score': true},
      {'answerText': 'Pizza', 'score': false},
    ],
  },
];
