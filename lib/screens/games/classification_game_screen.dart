import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';

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
      insectName: 'Mariposa Monarca',
      characteristic: '¿Tiene metamorfosis completa?',
      isTrue: true,
    ),
    InsectQuestion(
      insectEmoji: '🐜',
      insectName: 'Hormiga',
      characteristic: '¿Tiene alas?',
      isTrue: false,
    ),
    InsectQuestion(
      insectEmoji: '🐝',
      insectName: 'Abeja',
      characteristic: '¿Tiene 6 patas?',
      isTrue: true,
    ),
    InsectQuestion(
      insectEmoji: '🦗',
      insectName: 'Grillo',
      characteristic: '¿Puede volar?',
      isTrue: true,
    ),
    InsectQuestion(
      insectEmoji: '🐛',
      insectName: 'Oruga',
      characteristic: '¿Tiene alas?',
      isTrue: false,
    ),
  ];

  void checkAnswer(bool answer) {
    if (showFeedback) return;

    setState(() {
      selectedAnswer = answer;
      showFeedback = true;

      if (answer == questions[currentQuestionIndex].isTrue) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          selectedAnswer = null;
          showFeedback = false;
        } else {
          // Juego terminado
          showGameOverDialog();
        }
      });
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Juego Terminado!'),
          content: Text('Tu puntuación final: $score/${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text('Jugar de nuevo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.back();
              },
              child: const Text('Volver al menú'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      currentQuestionIndex = 0;
      selectedAnswer = null;
      showFeedback = false;
    });
  }

  Color getButtonColor(bool isTrue) {
    if (!showFeedback || selectedAnswer != isTrue) {
      return isTrue ? AppTheme.calPolyGreen : Colors.red;
    }
    return selectedAnswer == questions[currentQuestionIndex].isTrue
        ? AppTheme.calPolyGreen
        : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificación de Insectos'),
        backgroundColor: AppTheme.calPolyGreen,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.calPolyGreen.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Puntuación: $score/${questions.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          question.insectEmoji,
                          style: const TextStyle(fontSize: 72),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          question.insectName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            question.characteristic,
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
                              onPressed: () => checkAnswer(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: getButtonColor(true),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Verdadero',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => checkAnswer(false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: getButtonColor(false),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Falso',
                                style: TextStyle(
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
                                ? '¡Correcto! 🎉'
                                : '¡Incorrecto! 😢',
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
        ),
      ),
    );
  }
}
