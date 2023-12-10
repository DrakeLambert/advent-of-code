import 'dart:io';
import 'package:retrieval/trie.dart';

void main() {
  final input = File('./input.txt').readAsStringSync().split('\n');

  final sum =
      input.map(calibrationValue).reduce((value, element) => value + element);

  print(sum);
}

final numberTrie = buildNumberTrie();

int calibrationValue(String line) {
  final searchIndexes = <int>{};

  String? firstNumber = null;
  String? lastNumber = null;

  for (var i = 0; i < line.length; i++) {
    searchIndexes.add(i);

    final searchIndexesToRemove = <int>{};
    for (var searchIndex in searchIndexes) {
      final searchWord = line.substring(searchIndex, i + 1);
      final searchResults = numberTrie.find(searchWord);

      if (searchResults.isEmpty)
        searchIndexesToRemove.add(searchIndex);
      else if (searchResults case [final singleMatch]) {
        if (searchWord == singleMatch) {
          lastNumber = singleMatch;
          if (firstNumber == null) firstNumber = singleMatch;
        }
      }
    }
    searchIndexes.removeAll(searchIndexesToRemove);
  }

  final firstNumberValue = numberValues[firstNumber];
  final lastNumberValue = numberValues[lastNumber];

  return int.parse('$firstNumberValue$lastNumberValue');
}

const numberValues = {
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9,
  '1': 1,
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9
};

Trie buildNumberTrie() {
  final trie = new Trie();

  for (var number in numberValues.keys) {
    trie.insert(number);
  }

  return trie;
}
