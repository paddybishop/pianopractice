import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piano/screens/add_pieces_screen.dart'; // Import for Add Pieces screen

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _userName = 'Bella Bishop';
  int _weeklyPracticeDays = 3;
  int _minutesPerWeek = 60;
  String _selectedColor = 'deepPurple'; // Default color

  // Text controllers for name and practice days
  late TextEditingController _nameController;
  late TextEditingController _practiceDaysController;

  @override
  void initState() {
    super.initState();
    _loadSettings();

    // Initialize controllers
    _nameController = TextEditingController();
    _practiceDaysController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _practiceDaysController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Bella Bishop';
      _weeklyPracticeDays = prefs.getInt('weeklyPracticeDays') ?? 3;
      _minutesPerWeek = _weeklyPracticeDays * 20; // Hardcoded for now
      _selectedColor = prefs.getString('selectedColor') ?? 'deepPurple';

      // Update controllers with loaded values
      _nameController.text = _userName;
      _practiceDaysController.text = _weeklyPracticeDays.toString();
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setInt('weeklyPracticeDays', _weeklyPracticeDays);
    await prefs.setString('selectedColor', _selectedColor);
    setState(() {
      _minutesPerWeek = _weeklyPracticeDays * 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Input
              Text('Name', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                  _saveSettings();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: getColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: getColor()),
                  ),
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 20),

              // Weekly Practice Days Input
              Text('Weekly Practice Days', style: TextStyle(fontSize: 18)),
              TextField(
                keyboardType: TextInputType.number,
                controller: _practiceDaysController,
                onChanged: (value) {
                  setState(() {
                    _weeklyPracticeDays = int.tryParse(value) ?? 3;
                  });
                  _saveSettings();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: getColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: getColor()),
                  ),
                  hintText: 'Enter Weekly Practice Days',
                ),
              ),
              SizedBox(height: 20),

              // Minutes per Week Display
              Text('Minutes per Week:', style: TextStyle(fontSize: 18)),
              Text('$_minutesPerWeek', style: TextStyle(fontSize: 18, color: getColor())),
              SizedBox(height: 20),

              // Color Palette Picker
              Text('Color Palette', style: TextStyle(fontSize: 18)),
              Row(
                children: [
                  _buildColorButton(Colors.pink, 'pink', context),
                  _buildColorButton(Colors.deepPurple, 'deepPurple', context),
                  _buildColorButton(Colors.green, 'green', context),
                  _buildColorButton(Colors.red, 'red', context),
                ],
              ),
              SizedBox(height: 20),

              // Manage Pieces Option
              Divider(),
              ListTile(
                leading: Icon(Icons.library_music),
                title: Text('Manage Pieces'),
                subtitle: Text('Add or remove pieces you practice'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPiecesScreen()),
                  );
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color, String colorName, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = colorName;
        });
        _saveSettings();
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: _selectedColor == colorName ? Border.all(color: Colors.black, width: 2) : null,
        ),
      ),
    );
  }

  Color getColor() {
    switch (_selectedColor) {
      case 'pink':
        return Colors.pink;
      case 'deepPurple':
        return Colors.deepPurple;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      default:
        return Colors.deepPurple;
    }
  }
}