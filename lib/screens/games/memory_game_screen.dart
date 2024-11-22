import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../theme/app_theme.dart';

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
    {'insect': '🦋 Mariposa', 'fact': 'Sufre metamorfosis completa'},
    {'insect': '🐝 Abeja', 'fact': 'Polinizador esencial'},
    {'insect': '🐞 Catarina', 'fact': 'Come plagas de áfidos'},
    {'insect': '🦗 Grillo', 'fact': 'Canta frotando sus alas'},
    {'insect': '🐜 Hormiga', 'fact': 'Vive en colonias organizadas'},
    {'insect': '🪲 Escarabajo', 'fact': 'Tiene élitros protectores'},
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
          title: const Text('¡Felicitaciones! 🎉'),
          content: Text(
              '¡Has completado el juego en ${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Jugar de nuevo'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Memoria de Insectos'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Tiempo: ${secondsElapsed ~/ 60}:${(secondsElapsed % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Parejas encontradas: $matchesFound/${insectFacts.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
