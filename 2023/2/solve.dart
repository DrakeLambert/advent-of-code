import 'dart:io';

void main() {
  final input = File('./input.txt').readAsStringSync().split('\n');

  final games = input.map(Game.parse);

  var solution1 = solve1(games);
  print('solution 1: ${solution1}');

  var solution2 = solve2(games);
  print('solution 2: ${solution2}');
}

int solve2(Iterable<Game> games) => games.map((game) {
      final maximums = {'red': 0, 'green': 0, 'blue': 0};

      for (var hand in game.hands) {
        for (var drawing in hand.entries) {
          if (drawing.value > maximums[drawing.key]!) {
            maximums[drawing.key] = drawing.value;
          }
        }
      }

      final power = maximums.values.reduce((value, element) => value * element);
      return power;
    }).reduce((total, power) => total + power);

int solve1(Iterable<Game> games) {
  const maximums = {'red': 12, 'green': 13, 'blue': 14};

  final possibleGames = games.where((game) {
    for (var hand in game.hands) {
      for (var drawing in hand.entries) {
        if (drawing.value > maximums[drawing.key]!) return false;
      }
    }
    return true;
  });

  final sumOfPossibleGameIds =
      possibleGames.map((game) => game.id).reduce((sum, id) => sum + id);

  return sumOfPossibleGameIds;
}

class Game {
  late int id;
  late List<Map<String, int>> hands;
  late String source;

  final gamePattern = RegExp('Game (\\d+): (.*)');
  final handPattern = RegExp('(\\d+) (\\w+)');

  Game.parse(this.source) {
    final match = gamePattern.firstMatch(source);

    id = int.parse(match![1]!);

    final game = match[2]!;
    hands = game
        .split(';')
        .map((hand) => handPattern
            .allMatches(hand)
            .map((match) => MapEntry(match[2]!, int.parse(match[1]!))))
        .map(Map.fromEntries)
        .toList();
  }
}
