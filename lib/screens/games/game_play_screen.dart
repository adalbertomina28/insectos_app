import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_controller.dart';
import '../../models/game_models.dart';

class GamePlayScreen extends StatelessWidget {
  const GamePlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.currentGame?.title ?? ''),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          if (controller.isGameOver) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offNamed('/game-result', arguments: controller.getGameResult());
            });
            return const Center(child: CircularProgressIndicator());
          }

          final currentQuestion = controller.currentQuestion;
          if (currentQuestion == null) {
            return const Center(child: Text('Error al cargar la pregunta'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (controller.currentQuestionIndex + 1) /
                      controller.currentGame!.questions.length,
                ),
                const SizedBox(height: 16),
                Text(
                  'Pregunta ${controller.currentQuestionIndex + 1}/${controller.currentGame!.questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (currentQuestion.imageUrl.isNotEmpty)
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      currentQuestion.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  currentQuestion.text,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion.options[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          onPressed: () => controller.answerQuestion(option),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: Text(option.text),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Puntuación: ${controller.score}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
