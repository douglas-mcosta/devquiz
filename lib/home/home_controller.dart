import 'package:devquiz/core/app_images.dart';
import 'package:devquiz/home/home_repository.dart';
import 'package:devquiz/home/home_state.dart';
import 'package:devquiz/shared/models/awnser_model.dart';
import 'package:devquiz/shared/models/question_model.dart';
import 'package:devquiz/shared/models/quiz_model.dart';
import 'package:devquiz/shared/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class HomeController {
  final stateNotifier = ValueNotifier<HomeState>(HomeState.empty);
  set state(HomeState state) => stateNotifier.value = state;
  HomeState get state => stateNotifier.value;

  UserModel? user;
  List<QuizModel>? quizzes;

  final repository = HomeRepository();

  void GetUser() async {
    await Future.delayed(Duration(milliseconds: 500));
    state = HomeState.loadding;
    user = await repository.getUser();
  }

  void GetQuizzes() async {
    await Future.delayed(Duration(milliseconds: 500));
    state = HomeState.loadding;
    quizzes = await repository.getQuizzes();
    state = HomeState.success;
  }
}
