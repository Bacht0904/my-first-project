import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';  // Add this line.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
 final _suggestions=<WordPair>[];
 final _saved=<WordPair>[];
 final _biggerFont= const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  void  _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context){
          final tiles = _saved.map(
            (pair){
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            }
          );
          final divided=tiles.isNotEmpty?ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList():<Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(
              children: divided,
            ),
          );
        }

      ),
    );
  }


@override
Widget _buildSuggestions(){
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemBuilder: (BuildContext _context,int i){
      if(i.isOdd){
        return Divider();
      }
      final int index = i ~/2;
      if(index>=_suggestions.length){
        _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
    },
  );
}

Widget _buildRow(WordPair pair ){
  final alrealySaved = _saved.contains(pair);
  final number=Random().nextInt(100);
  return ListTile(
    title: Text(
      pair.asPascalCase,
      style: _biggerFont,
    ),
    trailing: Column(
      children: [
        Icon(alrealySaved?Icons.favorite:Icons.favorite_border,
        color: alrealySaved?Colors.red:null,
        semanticLabel: alrealySaved?'Remove from saved':'Save',
        ),
        Text(number.toString())

      ],
    ),
    onTap: (){
      setState(() {
        if(alrealySaved)
        {
          _saved.remove(pair);
        }else{
          _saved.add(pair);
        }
      });
    },
  );
}
}