// ignore: depend_on_referenced_packages

import 'ParPalavra.dart';

class RepositoryParPalavra {
  // Lista de palavras do tipo ParPalavra
  final _suggestions = <ParPalavra>[];

  // Construtor de repositório que inicializa com uma chamada de função para criar vinte novas palavras
  RepositoryParPalavra() {
    CreateParPalavra(20);
  }

  // ignore: non_constant_identifier_names
  void CreateParPalavra(int num) {
    for (int i = 0; i < num; i++) {
      _suggestions.add(ParPalavra.constructor());
    }
  }

  List getAll() {
    return _suggestions;
  }

  ParPalavra getByIndex(int index) {
    return _suggestions[index];
  }

  void removeParPalavra(ParPalavra word) {
    _suggestions.removeAt(_suggestions.indexOf(word));
  }
}
