import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'RepositoryParPalavra.dart';
import 'edit_page..dart';
import 'ParPalavra.dart';

void main() {
  runApp(const MyApp());
}

RepositoryParPalavra repositoryParPalavra = RepositoryParPalavra();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white, foregroundColor: Colors.black),
      ),
      initialRoute: '/',
      routes: {
        RandomWords.routeName: (context) => const RandomWords(),
        EditScreen.routeName: (context) => const EditScreen(),
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  // ignore: library_private_types_in_public_api
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _saved = <ParPalavra>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  bool cardMode = false;
  bool screenEditmode = false;
  String nome = "Startup Name Generator";

  @override
  Widget build(BuildContext context) {
    print("widght state");
    return Scaffold(
        appBar: AppBar(
          title: Text(nome),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
            IconButton(
              onPressed: (() {
                setState(() {
                  if (cardMode == false) {
                    cardMode = true;
                    debugPrint('$cardMode');
                  } else if (cardMode == true) {
                    cardMode = false;
                    debugPrint('$cardMode');
                  }
                });
              }),
              tooltip:
                  cardMode ? 'List Vizualization' : 'Card Mode Vizualization',
              icon: const Icon(Icons.auto_fix_normal_outlined),
            ),
            IconButton(
                icon: const Icon(Icons.plus_one),
                tooltip: 'Add new word',
                onPressed: () {
                  screenEditmode = true;
                  setState(() {
                    Navigator.popAndPushNamed(context, '/edit', arguments: {
                      'parPalavra': repositoryParPalavra.getAll(),
                      'palavra': screenEditmode
                    });
                  });
                }),
          ],
        ),
        body: _buildSuggestions(cardMode));
  }

  // Tela de favoritos
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        final tiles = _saved.map(
          (ParPalavra pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
      }),
    );
  }

  // Construindo sugestoes
  Widget _buildSuggestions(bool cardMode) {
    if (kDebugMode) {
      print('list mode changed');
    }

    if (cardMode == false) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          if (kDebugMode) {
            print("list view");
          }
          final index = i ~/ 2;

          if (index >= repositoryParPalavra.getAll().length) {
            repositoryParPalavra.CreateParPalavra(10);
            if (kDebugMode) {
              print("create word");
            }
          }
          return _buildRow(repositoryParPalavra.getByIndex(index));
        },
      );
    } else {
      return _cardVizualizaton();
    }
  }

  // Lista de construcao de linhas
  Widget _buildRow(ParPalavra pair) {
    if (kDebugMode) {
      print("build row");
    }
    final alreadySaved = _saved.contains(pair);
    var color = Colors.transparent;
    return Dismissible(
        key: Key(pair.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            }
            repositoryParPalavra.removeParPalavra(pair);
          });
        },
        background: Container(
          color: const Color.fromARGB(255, 255, 0, 0),
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: const Text(
            "Deletar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        child: ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
            trailing: IconButton(
                icon: Icon(
                    alreadySaved ? Icons.favorite : Icons.favorite_border,
                    color: alreadySaved
                        ? const Color.fromARGB(255, 255, 0, 0)
                        : null,
                    semanticLabel: alreadySaved ? 'Remove from saved' : 'Save'),
                tooltip: "Favorite",
                hoverColor: color,
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(pair);
                    } else {
                      _saved.add(pair);
                    }
                  });
                }),
            onTap: () {
              setState(() {
                Navigator.popAndPushNamed(context, '/edit', arguments: {
                  'parPalavra': repositoryParPalavra.getAll(),
                  'palavra': pair,
                });
              });
            }));
  }

  // Construcao de cards de visualizacao
  Widget _cardVizualizaton() {
    if (kDebugMode) {
      print('card mode changed');
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 8),
      itemBuilder: (context, index) {
        if (index >= repositoryParPalavra.getAll().length) {
          repositoryParPalavra.CreateParPalavra(10);
        }
        return Column(
          children: [_buildRow(repositoryParPalavra.getByIndex(index))],
        );
      },
    );
  }
}
