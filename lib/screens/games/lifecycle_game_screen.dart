import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class LifecycleGameScreen extends StatefulWidget {
  const LifecycleGameScreen({Key? key}) : super(key: key);

  @override
  State<LifecycleGameScreen> createState() => _LifecycleGameScreenState();
}

class _LifecycleGameScreenState extends State<LifecycleGameScreen> {
  final List<Insect> insects = [
    Insect(
      name: 'Mariposa Monarca',
      stages: [
        Stage(name: 'Huevo', emoji: '🥚', order: 0),
        Stage(name: 'Oruga', emoji: '🐛', order: 1),
        Stage(name: 'Ninfa', emoji: '🧬', order: 2),
        Stage(name: 'Mariposa', emoji: '🦋', order: 3),
      ],
    ),
    Insect(
      name: 'Escarabajo',
      stages: [
        Stage(name: 'Huevo', emoji: '🥚', order: 0),
        Stage(name: 'Larva', emoji: '🪱', order: 1),
        Stage(name: 'Pupa', emoji: '🧬', order: 2),
        Stage(name: 'Escarabajo', emoji: '🪲', order: 3),
      ],
    ),
    Insect(
      name: 'Mosca',
      stages: [
        Stage(name: 'Huevo', emoji: '🥚', order: 0),
        Stage(name: 'Larva', emoji: '🪱', order: 1),
        Stage(name: 'Pupa', emoji: '🧬', order: 2),
        Stage(name: 'Mosca', emoji: '🪰', order: 3),
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
        setState(() {
          showSuccess = false;
          currentInsectIndex = (currentInsectIndex + 1) % insects.length;
          _initializeStages();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ciclo de Vida'),
        backgroundColor: AppTheme.calPolyGreen,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.calPolyGreen.withOpacity(0.1),
            child: Column(
              children: [
                Text(
                  insects[currentInsectIndex].name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calPolyGreen,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Arrastra y suelta las tarjetas para ordenarlas según el ciclo de vida del insecto',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  '👆 Mantén presionada una tarjeta y arrástrala a su posición correcta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
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
