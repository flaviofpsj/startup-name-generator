import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//stateless widget
class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'Startup Name Generator',
			//theme color
			theme: new ThemeData(
				primaryColor: Colors.redAccent,
			),
			//home calls RandomWords widget
			home: new RandomWords(),
		);
	}
}

//stateful widget
class RandomWords extends StatefulWidget {
	@override
	createState() => new RandomWordsState();
}

//stateful widget state
class RandomWordsState extends State<RandomWords> {
	//local variables declaration
	final _suggestions = <WordPair>[];
	final _saved = new Set<WordPair>();
	final _biggerFont = const TextStyle(fontSize: 18.0);

	@override
	//contains appBar and body of application informations
	Widget build(BuildContext context) {
		//Scaffold
		return new Scaffold(
			//Scaffold appBar
			appBar: new AppBar(
				//appBar title
				title: new Text('Startup Name Generator'),
				//right button action
				actions: <Widget>[
					//onPressed redirect to _pushSaved
					new IconButton(icon: new Icon(Icons.format_list_bulleted), onPressed: _pushSaved)
				],
			),
			//Scaffold body, composed by _buildSuggestions
			body: _buildSuggestions(),
		);
	}

	//body of Scaffold
	Widget _buildSuggestions() {
		//ListView created from _buildRow widget
		return new ListView.builder(
			padding: const EdgeInsets.all(16.0),
			//generate suggestions of word pairs
			itemBuilder: (context, i) {
				if (i.isOdd) return new Divider();

				final index = i ~/ 2;
				
				if (index >= _suggestions.length) {
					_suggestions.addAll(generateWordPairs().take(10));
				}
				//call _buildRow once
				return _buildRow(_suggestions[index]);
			},
		);
	}

	//single item
	Widget _buildRow(WordPair pair) {
	//local variable, assuming item was saved
	final alreadySaved = _saved.contains(pair);
		return new ListTile(
			//create a title of suggestion
			title: new Text(
				pair.asPascalCase,
				style: _biggerFont,
			),
			//change the color of heart icon
			trailing: new Icon(
				alreadySaved ? Icons.favorite : Icons.favorite_border,
				color: alreadySaved ? Colors.redAccent : null,
			),
			//by click in one suggestion
			onTap: () {
				setState(() {
					//remove pair if already saved
					if (alreadySaved) {
						_saved.remove(pair);
					//add pair if no already saved
					} else {
						_saved.add(pair);
					}
				},
				);
			},
		);
	}

	//_pushSaved screen
	void _pushSaved() {
		//create a navigation to first page
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					final tiles = _saved.map(
						(pair) {
							return new ListTile(
								title: new Text(
									pair.asPascalCase,
									style: _biggerFont,
								),
							);
						},
					);
					final divided = ListTile
						.divideTiles(
							context: context,
							tiles: tiles,
						)
						.toList();

						return new Scaffold(
							appBar: new AppBar(
								title: new Text('Saved Suggestions'),
							),
							body: new ListView(children: divided),
						);
				},
			),
		);
	}
}