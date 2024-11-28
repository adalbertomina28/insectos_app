import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../widgets/base_screen.dart';

class ClassificationGameScreen extends StatefulWidget {
  const ClassificationGameScreen({Key? key}) : super(key: key);

  @override
  State<ClassificationGameScreen> createState() => _ClassificationGameScreenState();
}

class InsectQuestion {
  final String insectEmoji;
  final String insectName;
  final String characteristic;
  final bool isTrue;

  InsectQuestion({
    required this.insectEmoji,
    required this.insectName,
    required this.characteristic,
    required this.isTrue,
  });
}

class _ClassificationGameScreenState extends State<ClassificationGameScreen> {
  int score = 0;
  int currentQuestionIndex = 0;
  bool? selectedAnswer;
  bool showFeedback = false;

  final List<InsectQuestion> questions = [
    InsectQuestion(
      insectEmoji: '🦋',
      insectName: 'monarch_butterfly'.tr,
      characteristic: 'question_complete_metamorphosis'.tr,
      isTrue: true,
    ),
    InsectQuestion(
      insectEmoji: '🐜',
      insectName: 'ant'.tr,
      characteristic: 'question_has_wings'.tr,
      isTrue: false,
    ),
    InsectQuestion(
      insectEmoji: '🐝',
      insectName: 'bee'.tr,
      characteristic: 'question_has_six_legs'.tr,
      isTrue: true,
    ),
    InsectQuestion(
      insectEmoji: '🦗',
      insectName: 'cricket'.tr,
      characteristic: 'question_can_fly'.tr,
      isTrue: false,
    ),
    InsectQuestion(
      insectEmoji: '🐞',
      insectName: 'ladybug'.tr,
      characteristic: 'question_has_elytra'.tr,
      isTrue: true,
    ),
  ];

  void _checkAnswer(bool answer) {
    if (showFeedback) return;

    setState(() {
      selectedAnswer = answer;
      showFeedback = true;
      if (answer == questions[currentQuestionIndex].isTrue) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showFeedback = false;
          selectedAnswer = null;
          if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
          } else {
            _showCompletionDialog();
          }
        });
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('classification_game_won_title'.tr),
          content: Text(
            'classification_game_won_message'.tr.trParams({
              'score': score.toString(),
              'total': questions.length.toString(),
            }),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('classification_game_play_again'.tr),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  score = 0;
                  currentQuestionIndex = 0;
                  selectedAnswer = null;
                  showFeedback = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Color _getButtonColor(bool isTrue) {
    if (!showFeedback || selectedAnswer != isTrue) {
      return isTrue ? AppTheme.calPolyGreen : Colors.red;
    }
    return selectedAnswer == questions[currentQuestionIndex].isTrue
        ? AppTheme.calPolyGreen
        : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'classification_game_title'.tr,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'classification_game_score'.tr + ': $score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calPolyGreen,
                  ),
                ),
                Text(
                  'classification_game_question'.tr + ': ${currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calPolyGreen,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      questions[currentQuestionIndex].insectEmoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      questions[currentQuestionIndex].insectName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        questions[currentQuestionIndex].characteristic,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _checkAnswer(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getButtonColor(true),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            'true'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _checkAnswer(false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getButtonColor(false),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            'false'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (showFeedback) ...[
                      const SizedBox(height: 24),
                      Text(
                        selectedAnswer == questions[currentQuestionIndex].isTrue
                            ? 'correct'.tr
                            : 'incorrect'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: selectedAnswer == questions[currentQuestionIndex].isTrue
                              ? AppTheme.calPolyGreen
                              : Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
