import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../widgets/base_screen.dart';

class LifecycleGameScreen extends StatefulWidget {
  const LifecycleGameScreen({Key? key}) : super(key: key);

  @override
  State<LifecycleGameScreen> createState() => _LifecycleGameScreenState();
}

class _LifecycleGameScreenState extends State<LifecycleGameScreen> {
  final List<Insect> insects = [
    Insect(
      name: 'monarch_butterfly'.tr,
      stages: [
        Stage(name: 'egg'.tr, emoji: '🥚', order: 0),
        Stage(name: 'caterpillar'.tr, emoji: '🐛', order: 1),
        Stage(name: 'chrysalis'.tr, emoji: '🧬', order: 2),
        Stage(name: 'butterfly'.tr, emoji: '🦋', order: 3),
      ],
    ),
    Insect(
      name: 'beetle'.tr,
      stages: [
        Stage(name: 'egg'.tr, emoji: '🥚', order: 0),
        Stage(name: 'larva'.tr, emoji: '🪱', order: 1),
        Stage(name: 'pupa'.tr, emoji: '🧬', order: 2),
        Stage(name: 'beetle'.tr, emoji: '🪲', order: 3),
      ],
    ),
    Insect(
      name: 'fly'.tr,
      stages: [
        Stage(name: 'egg'.tr, emoji: '🥚', order: 0),
        Stage(name: 'larva'.tr, emoji: '🪱', order: 1),
        Stage(name: 'pupa'.tr, emoji: '🧬', order: 2),
        Stage(name: 'fly'.tr, emoji: '🪰', order: 3),
      ],
    ),
  ];

  int currentInsectIndex = 0;
  late List<Stage> currentStages;
  bool showSuccess = false;

  @override
  void initState() {
    super.initState();
    _initializeStages();
  }

  void _initializeStages() {
    currentStages = List.from(insects[currentInsectIndex].stages)..shuffle();
  }

  void _checkOrder() {
    bool isCorrect = true;
    for (int i = 0; i < currentStages.length; i++) {
      if (currentStages[i].order != i) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      setState(() {
        showSuccess = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showSuccess = false;
            if (currentInsectIndex < insects.length - 1) {
              currentInsectIndex++;
              _initializeStages();
            } else {
              _showCompletionDialog();
            }
          });
        }
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('lifecycle_game_won_title'.tr),
          content: Text('lifecycle_game_won_message'.tr),
          actions: <Widget>[
            TextButton(
              child: Text('lifecycle_game_play_again'.tr),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentInsectIndex = 0;
                  _initializeStages();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'lifecycle_game_title'.tr,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              insects[currentInsectIndex].name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.calPolyGreen,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'lifecycle_game_instruction'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.officeGreen.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentStages.length,
                    itemBuilder: (context, index) {
                      final stage = currentStages[index];
                      return Card(
                        key: ValueKey(stage),
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppTheme.calPolyGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                stage.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          title: Text(
                            stage.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final Stage item = currentStages.removeAt(oldIndex);
                        currentStages.insert(newIndex, item);
                        _checkOrder();
                      });
                    },
                  ),
                ),
                if (showSuccess)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¡Correcto! 🎉',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Has ordenado correctamente el ciclo de vida de ${insects[currentInsectIndex].name}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Insect {
  final String name;
  final List<Stage> stages;

  Insect({
    required this.name,
    required this.stages,
  });
}

class Stage {
  final String name;
  final String emoji;
  final int order;

  Stage({
    required this.name,
    required this.emoji,
    required this.order,
  });
}
