import 'package:devquiz/challenge/challenge_controller.dart';
import 'package:devquiz/challenge/widgets/next_button/next_button.widget.dart';
import 'package:devquiz/challenge/widgets/question_indicator/question_indicator_widget.dart';
import 'package:devquiz/challenge/widgets/quiz/quiz_widget.dart';
import 'package:devquiz/result/result_page.dart';
import 'package:devquiz/shared/models/question_model.dart';
import 'package:flutter/material.dart';

class ChallegePage extends StatefulWidget {
  final List<QuestionModel> questions;
  final String title;
  const ChallegePage({Key? key, required this.questions, required this.title})
      : super(key: key);

  @override
  _ChallegePageState createState() => _ChallegePageState();
}

class _ChallegePageState extends State<ChallegePage> {
  final controller = ChallengeContoller();
  final pageController = PageController();
  int _respondido = 0;

  @override
  void initState() {
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
    super.initState();
  }

  void NextPage() {
    if (controller.currentPage < widget.questions.length)
      pageController.nextPage(
        duration: Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    setState(() {
      _respondido++;
    });
  }

  void onSelected(bool value) {
    if (value) {
      controller.qtdAwnswerRight++;
    }
    NextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(106),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // BackButton(),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => QuestionIndicatorWidget(
                  currentPage: value,
                  length: widget.questions.length,
                ),
              )
            ],
          ),
        ),
      ),
      body: PageView(
        // physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          ...widget.questions
              .map((e) => QuizWidget(
                    question: e,
                    onSelected: onSelected,
                  ))
              .toList()
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ValueListenableBuilder<int>(
            valueListenable: controller.currentPageNotifier,
            builder: (context, value, _) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (value < widget.questions.length)
                  Expanded(
                    child: NextButton.white(
                      label: "Pular",
                      onTap: NextPage,
                    ),
                  ),
                if (value == widget.questions.length)
                  SizedBox(
                    width: 7,
                  ),
                if (value == widget.questions.length &&
                    _respondido == widget.questions.length)
                  Expanded(
                    child: NextButton.green(
                      label: "Confirmar",
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultPage(
                                      title: widget.title,
                                      length: widget.questions.length,
                                      result: controller.qtdAwnswerRight,
                                    )));
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
