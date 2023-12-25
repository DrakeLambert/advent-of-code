import 'dart:collection';
import 'dart:io';

void main() {
  final input = File('./input.txt').readAsLinesSync();

  // iterate through symbols
  // find adjacent digits
  // - beware of edges
  // foreach digit, search left and right to get full number
  // - beware of some digits belonging to the same number
  // - track position of number so we don't count it twice
  // add up all numbers

  var characters = Characters.parse(input);

  var partNumberSum = solve1(characters);
  print('solution 1: ${partNumberSum}');

  int gearRatioSum = solve2(characters);
  print('solution 2: ${gearRatioSum}');
}

int solve2(Characters characters) {
  final starSymbols = characters.where((element) => element.value == '*');
  final adjacentPartNumbers = starSymbols.map((starSymbol) {
    final searchCoordinates = getSearchCoordinates(starSymbol);
    final partNumbers =
        getAdjacentPartNumbers(searchCoordinates, characters).toList();
    return (starSymbol: starSymbol, adjacentPartNumbers: partNumbers);
  });
  final gears = adjacentPartNumbers
      .where((element) => element.adjacentPartNumbers.length == 2);
  final gearRatios = gears.map((e) => e.adjacentPartNumbers
      .map(getPartNumberInt)
      .reduce((product, partNumber) => product * partNumber));
  final gearRatioSum = gearRatios.reduce((sum, gearRatio) => sum + gearRatio);
  return gearRatioSum;
}

int solve1(Characters characters) {
  final symbols =
      characters.where((character) => character.type == CharacterType.Symbol);
  final searchCoordinates = symbols.expand(getSearchCoordinates).toSet();
  final partNumbers = getAdjacentPartNumbers(searchCoordinates, characters);
  final partNumberSum = partNumbers
      .map(getPartNumberInt)
      .reduce((sum, partNumber) => sum + partNumber);
  return partNumberSum;
}

int getPartNumberInt(Iterable<Character> characters) {
  final partNumberString = characters.map((digit) => digit.value).join();
  return int.parse(partNumberString);
}

Iterable<Iterable<Character>> getAdjacentPartNumbers(
    Iterable<(int, int)> searchCoordinates, Characters characters) {
  final searchResults = searchCoordinates
      .map((coordinate) => characters.atOrNull(coordinate.$1, coordinate.$2));
  final adjacentDigits = searchResults
      .where((element) => element?.type == CharacterType.Digit)
      .cast<Character>();
  final partNumbers = deduplicatePartNumbers(
      adjacentDigits.map((digit) => getFullNumber(characters, digit)));
  return partNumbers;
}

Iterable<Iterable<Character>> deduplicatePartNumbers(
    Iterable<Iterable<Character>> partNumbers) {
  final seenPartNumberPositions = <(int, int)>{};
  return partNumbers.where((partNumber) => seenPartNumberPositions
      .add((partNumber.first.row, partNumber.first.column)));
}

Iterable<Character> getFullNumber(Characters characters, Character origin) {
  search(int columnIncrement) {
    Character? current = origin;
    moveNextDigit() {
      current =
          characters.atOrNull(current!.row, current!.column + columnIncrement);
      return current?.type == CharacterType.Digit;
    }

    final digits = <Character>[];
    while (moveNextDigit()) {
      digits.add(current!);
    }
    return digits;
  }

  final leftDigits = search(-1);
  final rightDigits = search(1);

  return [...leftDigits.reversed, origin, ...rightDigits];
}

Iterable<(int row, int column)> getSearchCoordinates(
    Character character) sync* {
  const directions = {-1, 0, 1};
  for (var rowDirection in directions) {
    for (var columnDirection in directions) {
      if (rowDirection == 0 && columnDirection == 0) continue;
      yield (rowDirection + character.row, columnDirection + character.column);
    }
  }
}

class Characters with IterableMixin<Character> {
  final List<List<Character>> data;

  Characters.parse(List<String> input)
      : data = List.generate(
          input.length,
          (i) => List.generate(
              input[i].length, (j) => Character(input[i][j], i, j)),
        );

  Character? atOrNull(int row, int column) {
    if (row < 0 || row >= data.length) return null;

    if (column < 0 || column >= data[row].length) return null;

    return data[row][column];
  }

  @override
  Iterator<Character> get iterator {
    iterate() sync* {
      for (var row in data) {
        for (var character in row) {
          yield character;
        }
      }
    }

    return iterate().iterator;
  }
}

class Character {
  final int row;
  final int column;
  final String value;
  final int codeUnit;
  final CharacterType type;

  Character(this.value, this.row, this.column)
      : codeUnit = value.codeUnitAt(0),
        type = getCharacterType(value);
}

enum CharacterType { Nothing, Symbol, Digit }

CharacterType getCharacterType(String value) {
  const period = 46;
  const zero = 48;
  const nine = 57;
  return switch (value.codeUnitAt(0)) {
    period => CharacterType.Nothing,
    >= zero && <= nine => CharacterType.Digit,
    _ => CharacterType.Symbol
  };
}
