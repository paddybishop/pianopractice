import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPiecesScreen extends StatefulWidget {
  @override
  _AddPiecesScreenState createState() => _AddPiecesScreenState();
}

class _AddPiecesScreenState extends State<AddPiecesScreen> {
  List<String> _pieces = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPieces();
  }

  Future<void> _loadPieces() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pieces = prefs.getStringList('pieces') ?? [];
    });
  }

  Future<void> _savePieces() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pieces', _pieces);
  }

  void _addPiece(String piece) {
    if (piece.isNotEmpty) {
      setState(() {
        _pieces.add(piece);
      });
      _savePieces();
      _controller.clear();
    }
  }

  void _removePiece(int index) {
    setState(() {
      _pieces.removeAt(index);
    });
    _savePieces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pieces'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Piece Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addPiece(_controller.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pieces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_pieces[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removePiece(index),
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