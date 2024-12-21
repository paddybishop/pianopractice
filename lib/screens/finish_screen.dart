import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishScreen extends StatefulWidget {
  final int extraMinutes;
  final bool practicePieces;

  FinishScreen({required this.extraMinutes, required this.practicePieces});

  @override
  _FinishScreenState createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  List<String> _pieces = [];
  Map<String, bool> _selectedPieces = {};

  @override
  void initState() {
    super.initState();
    _loadPieces();
  }

  Future<void> _loadPieces() async {
    final prefs = await SharedPreferences.getInstance();
    final pieces = prefs.getStringList('pieces') ?? [];
    setState(() {
      _pieces = pieces;
      for (var piece in pieces) {
        _selectedPieces[piece] = false; // Initialize all as unchecked
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finish Lesson'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Well done on your practice!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "You added an extra ${widget.extraMinutes} minutes to your time this week.",
              style: TextStyle(fontSize: 18),
            ),
            Text(
              "You earned ${widget.extraMinutes * 10} points!",
              style: TextStyle(fontSize: 18),
            ),
            if (widget.practicePieces && _pieces.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                "Which pieces did you practice?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._pieces.map((piece) {
                return CheckboxListTile(
                  title: Text(piece),
                  value: _selectedPieces[piece],
                  onChanged: (bool? value) {
                    setState(() {
                      _selectedPieces[piece] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}