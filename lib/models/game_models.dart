import 'package:flutter/material.dart';

class InsectGame {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final String imageAsset;
  final List<GameQuestion> questions;

  const InsectGame({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.imageAsset,
    required this.questions,
  });
}

class GameQuestion {
  final String text;
  final String imageUrl;
  List<GameOption> options;
  final String explanation;

  GameQuestion({
    required this.text,
    required this.imageUrl,
    required this.options,
    required this.explanation,
  });
}

class GameOption {
  final String text;
  final bool isCorrect;

  const GameOption({
    required this.text,
    required this.isCorrect,
  });
}

class GameResult {
  final String gameId;
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final Duration timeSpent;

  const GameResult({
    required this.gameId,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
  });
}
