import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../widgets/base_screen.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({Key? key}) : super(key: key);

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<MemoryCard> cards = [];
  bool isProcessing = false;
  int matchesFound = 0;
  Timer? timer;
  int secondsElapsed = 0;
  MemoryCard? selectedCard;

  final List<Map<String, String>> insectFacts = [
    {'insect': '🦋 ' + 'butterfly'.tr, 'fact': 'butterfly_fact'.tr},
    {'insect': '🐝 ' + 'bee'.tr, 'fact': 'bee_fact'.tr},
    {'insect': '🐞 ' + 'ladybug'.tr, 'fact': 'ladybug_fact'.tr},
    {'insect': '🦗 ' + 'cricket'.tr, 'fact': 'cricket_fact'.tr},
    {'insect': '🐜 ' + 'ant'.tr, 'fact': 'ant_fact'.tr},
    {'insect': '🪲 ' + 'beetle'.tr, 'fact': 'beetle_fact'.tr},
  ];

  @override
  void initState() {
    super.initState();
    initializeCards();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void initializeCards() {
    // Crear pares de cartas
    List<MemoryCard> newCards = [];
    for (var fact in insectFacts) {
      newCards.add(MemoryCard(
        content: fact['insect']!,
        type: CardType.insect,
        matchId: newCards.length ~/ 2,
      ));
      newCards.add(MemoryCard(
        content: fact['fact']!,
        type: CardType.fact,
        matchId: newCards.length ~/ 2,
      ));
    }

    // Mezclar las cartas
    newCards.shuffle(Random());
    setState(() {
      cards = newCards;
    });
  }

  void onCardTap(int index) {
    if (isProcessing || cards[index].isMatched || cards[index].isFlipped) return;

    setState(() {
      cards[index].isFlipped = true;
    });

    if (selectedCard == null) {
      selectedCard = cards[index];
    } else {
      isProcessing = true;
      if (selectedCard!.matchId == cards[index].matchId &&
          selectedCard!.type != cards[index].type) {
        // ¡Encontramos un par!
        setState(() {
          selectedCard!.isMatched = true;
          cards[index].isMatched = true;
          matchesFound++;
        });
        selectedCard = null;
        isProcessing = false;

        if (matchesFound == insectFacts.length) {
          timer?.cancel();
          showWinDialog();
        }
      } else {
        // No coinciden
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            selectedCard!.isFlipped = false;
            cards[index].isFlipped = false;
            selectedCard = null;
            isProcessing = false;
          });
        });
      }
    }
  }

  void showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('memory_game_won_title'.tr),
          content: Text(
              'memory_game_won_message'.tr + ' ${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}'),
          actions: <Widget>[
            TextButton(
              child: Text('memory_game_play_again'.tr),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  matchesFound = 0;
                  secondsElapsed = 0;
                  initializeCards();
                });
                startTimer();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'memory_game_title'.tr,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'memory_game_matches'.tr + ': $matchesFound/6',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.calPolyGreen,
                  ),
                ),
                Text(
                  'memory_game_time'.tr + ': ${secondsElapsed}s',
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
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: Card(
                    elevation: cards[index].isFlipped ? 8 : 4,
                    color: cards[index].isMatched
                        ? Colors.green[100]
                        : cards[index].isFlipped
                            ? Colors.white
                            : AppTheme.calPolyGreen.withOpacity(0.8),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          cards[index].isFlipped ? cards[index].content : '?',
                          style: TextStyle(
                            fontSize: cards[index].isFlipped ? 12 : 20,
                            fontWeight: FontWeight.bold,
                            color: cards[index].isFlipped 
                                ? AppTheme.calPolyGreen
                                : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum CardType { insect, fact }

class MemoryCard {
  final String content;
  final CardType type;
  final int matchId;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.content,
    required this.type,
    required this.matchId,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
