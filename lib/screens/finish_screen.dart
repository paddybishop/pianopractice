import 'package:flutter/material.dart';

class FinishScreen extends StatefulWidget {
  @override
  _FinishScreenState createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  String _practiceType = 'Pieces';
  String _notes = "";
  String _selectedPiece = '';
  List<String> _pieces = ["Piece 1", "Piece 2", "Piece 3"]; // Placeholder pieces

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
              Text('What did you do?', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Row(
                children: [
                    Radio<String>(
                      value: 'Pieces',
                    groupValue: _practiceType,
                    onChanged: (value) {
                        setState(() {
                             _practiceType = value!;
                            });
                     },
                 ),
                     Text('Pieces'),
                    Radio<String>(
                    value: 'Scales',
                     groupValue: _practiceType,
                   onChanged: (value) {
                      setState(() {
                        _practiceType = value!;
                        });
                  },
                    ),
                       Text('Scales'),
                   Radio<String>(
                       value: 'Sight-Reading',
                        groupValue: _practiceType,
                     onChanged: (value) {
                         setState(() {
                           _practiceType = value!;
                        });
                       },
                    ),
                       Text('Sight-Reading'),
                   Radio<String>(
                       value: 'Fun',
                        groupValue: _practiceType,
                    onChanged: (value) {
                       setState(() {
                           _practiceType = value!;
                        });
                   },
                    ),
                       Text('Fun'),
                ],
              ),
          SizedBox(height: 20),
          if (_practiceType == 'Pieces')
             Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Select a Piece', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                DropdownButton<String>(
                   value: _selectedPiece.isEmpty ? _pieces.first : _selectedPiece,
                  onChanged: (String? value) {
                     setState(() {
                        _selectedPiece = value!;
                     });
                   },
                     items: _pieces.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                            child: Text(value),
                       );
                     }).toList(),
                 ),
               ],
            ),
              SizedBox(height: 20),
              Text('Notes', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                   setState(() {
                      _notes = value;
                    });
                  },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                    hintText: 'Enter Notes',
                 ),
               ),
          ]
        ),
      )
    );
  }
}