import 'package:get/get.dart';
import '../models/game_models.dart';
import 'dart:math';

class GameController extends GetxController {
  final Rx<InsectGame?> _currentGame = Rx<InsectGame?>(null);
  final RxInt _currentQuestionIndex = 0.obs;
  final RxInt _score = 0.obs;
  final RxBool _isGameOver = false.obs;
  final Rx<DateTime> _startTime = DateTime.now().obs;

  InsectGame? get currentGame => _currentGame.value;
  int get currentQuestionIndex => _currentQuestionIndex.value;
  int get score => _score.value;
  bool get isGameOver => _isGameOver.value;
  GameQuestion? get currentQuestion => 
      _currentGame.value?.questions[_currentQuestionIndex.value];

  final List<InsectGame> availableGames = [
    InsectGame(
      id: '1',
      title: '¡Identifica los Polinizadores!',
      description: 'Pon a prueba tus conocimientos sobre los insectos polinizadores',
      difficulty: 'Principiante',
      imageAsset: 'assets/images/insects/bee.svg',
      questions: [
        GameQuestion(
          text: '¿Cuál de estos insectos es conocido por su importante papel en la polinización?',
          imageUrl: 'assets/images/insects/bee.svg',
          options: [
            GameOption(text: 'Hormiga', isCorrect: false),
            GameOption(text: 'Abeja', isCorrect: true),
            GameOption(text: 'Cucaracha', isCorrect: false),
            GameOption(text: 'Mosquito', isCorrect: false),
          ],
          explanation: 'Las abejas son polinizadores cruciales para la agricultura y los ecosistemas naturales.',
        ),
        GameQuestion(
          text: '¿Qué insecto puede volar hacia atrás y es un importante polinizador nocturno?',
          imageUrl: 'assets/images/insects/butterfly.svg',
          options: [
            GameOption(text: 'Mariposa diurna', isCorrect: false),
            GameOption(text: 'Escarabajo', isCorrect: false),
            GameOption(text: 'Polilla esfinge', isCorrect: true),
            GameOption(text: 'Libélula', isCorrect: false),
          ],
          explanation: 'Las polillas esfinge son expertas voladoras y polinizan flores nocturnas.',
        ),
        GameQuestion(
          text: '¿Cuál es la característica distintiva de una mariquita?',
          imageUrl: 'assets/images/insects/ladybug.svg',
          options: [
            GameOption(text: 'Alas transparentes', isCorrect: false),
            GameOption(text: 'Antenas largas', isCorrect: false),
            GameOption(text: 'Manchas en sus alas', isCorrect: true),
            GameOption(text: 'Patas peludas', isCorrect: false),
          ],
          explanation: 'Las mariquitas son conocidas por sus élitros manchados que les sirven como protección.',
        ),
        GameQuestion(
          text: '¿Qué insecto realiza la "danza del ocho" para comunicarse?',
          imageUrl: 'assets/images/insects/bee.svg',
          options: [
            GameOption(text: 'Hormiga reina', isCorrect: false),
            GameOption(text: 'Mariposa monarca', isCorrect: false),
            GameOption(text: 'Cigarra', isCorrect: false),
            GameOption(text: 'Abeja melífera', isCorrect: true),
          ],
          explanation: 'Las abejas usan la danza del ocho para comunicar la ubicación de las fuentes de alimento.',
        ),
        GameQuestion(
          text: '¿Cuál es el proceso de transformación de una mariposa?',
          imageUrl: 'assets/images/insects/butterfly.svg',
          options: [
            GameOption(text: 'Metamorfosis incompleta', isCorrect: false),
            GameOption(text: 'Metamorfosis completa', isCorrect: true),
            GameOption(text: 'División celular', isCorrect: false),
            GameOption(text: 'Fragmentación', isCorrect: false),
          ],
          explanation: 'Las mariposas experimentan metamorfosis completa: huevo, larva, pupa y adulto.',
        ),
      ],
    ),
  ];

  void startGame(String gameId) {
    final game = availableGames.firstWhere((game) => game.id == gameId);
    _currentGame.value = game;
    _currentQuestionIndex.value = 0;
    _score.value = 0;
    _isGameOver.value = false;
    _startTime.value = DateTime.now();
    
    // Mezclar las opciones de cada pregunta
    for (var question in game.questions) {
      final options = question.options.toList();
      options.shuffle(Random());
      question.options = options;
    }
  }

  void answerQuestion(GameOption selectedOption) {
    if (selectedOption.isCorrect) {
      _score.value += 20; // 20 puntos por pregunta correcta
    }

    if (_currentQuestionIndex.value < _currentGame.value!.questions.length - 1) {
      _currentQuestionIndex.value++;
    } else {
      _isGameOver.value = true;
    }
  }

  GameResult getGameResult() {
    return GameResult(
      gameId: _currentGame.value!.id,
      score: _score.value,
      correctAnswers: (_score.value ~/ 20),
      totalQuestions: _currentGame.value!.questions.length,
      timeSpent: DateTime.now().difference(_startTime.value),
    );
  }

  void restartGame() {
    if (_currentGame.value != null) {
      startGame(_currentGame.value!.id);
    }
  }
}
