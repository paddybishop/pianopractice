import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piano/screens/settings_screen.dart';
import 'package:piano/screens/finish_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // Dependencies
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Variables
  bool _isTimerRunning = false;
  bool _isDurationSelected = false;
  int _duration = 0; // Timer starts at zero
  int _activeDurationButton = 0;
  int _weeklyPracticeDays = 3;
  double _weeklyProgress = 0.0;
  double _practiceProgress = 0.0;
  String _selectedColor = 'deepPurple';
  Map<String, bool> _practiceTypes = {
    'Pieces': false,
    'Scales': false,
    'Sight-Reading': false,
    'Fun': false,
  };
  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _selectedColor = prefs.getString('selectedColor') ?? 'deepPurple';
      _weeklyPracticeDays = prefs.getInt('weeklyPracticeDays') ?? 3;
      _weeklyProgress = prefs.getDouble('weeklyProgress') ?? 0.0;
    });
  }

  Color _getColor() {
    switch (_selectedColor) {
      case 'pink':
        return Colors.pink;
      case 'deepPurple':
        return Colors.deepPurple;
      case 'green':
        return Colors.green;
      default:
        return Colors.deepPurple;
    }
  }

  void _setDuration(int durationInSeconds, int buttonIndex) {
    setState(() {
      _duration = durationInSeconds ~/ 60; // Store duration in minutes for display
      _activeDurationButton = buttonIndex;
      _isDurationSelected = true;
      _secondsLeft = durationInSeconds;
    });
  }

  void _startTimer() {
    if (_practiceTypes.values.where((e) => e).length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least 3 types of practice.')),
      );
      return;
    }

    if (_isTimerRunning) {
      _timer?.cancel();
    } else {
      if (_secondsLeft == 0) _secondsLeft = _duration * 60;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_secondsLeft > 0) {
            _secondsLeft--;
          } else {
            timer.cancel();
            _showTimerFinishedOptions();
          }
        });
      });
    }

    setState(() => _isTimerRunning = !_isTimerRunning);
  }

  void _endTimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text("You'll lose all your points."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              setState(() {
                _isTimerRunning = false;
                _secondsLeft = 0;
                _isDurationSelected = false;
                _activeDurationButton = 0;
              });
              Navigator.pop(context); // Close dialog
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showTimerFinishedOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Timer Finished'),
        content: Text('What would you like to do next?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _secondsLeft += 10 * 60; // Add 10 minutes
              });
              Navigator.pop(context); // Close dialog
              _startTimer(); // Restart timer
            },
            child: Text('Add 10 Minutes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FinishScreen(
                  extraMinutes: _duration,
                  practicePieces: _practiceTypes['Pieces'] ?? false,
                )
              ),
              );
            },
            child: Text('Finish Lesson'),
          ),
        ],
      ),
    );
  }

  String getTimerText() {
    int minutes = _secondsLeft ~/ 60;
    int seconds = _secondsLeft % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piano Tracker'),
        backgroundColor: _getColor(),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and User Info
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Bella Bishop',
                    style: TextStyle(fontSize: 20, color: _getColor()),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Duration Selection Buttons
            Text(
              'How long have you got?',
              style: TextStyle(fontSize: 18, color: _getColor()),
            ),
            if (!_isTimerRunning) ...[
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _DurationButton(
                      label: '10 Secs',
                      isActive: _activeDurationButton == 1,
                      buttonColor: _getColor(),
                      onPressed: () => _setDuration(10, 1),
                    ),
                    _DurationButton(
                      label: '10 Mins',
                      isActive: _activeDurationButton == 2,
                      buttonColor: _getColor(),
                      onPressed: () => _setDuration(10 * 60, 2),
                    ),
                    _DurationButton(
                      label: '20 Mins',
                      isActive: _activeDurationButton == 3,
                      buttonColor: _getColor(),
                      onPressed: () => _setDuration(20 * 60, 3),
                    ),
                    _DurationButton(
                      label: '30 Mins',
                      isActive: _activeDurationButton == 4,
                      buttonColor: _getColor(),
                      onPressed: () => _setDuration(30 * 60, 4),
                    ),
                    _DurationButton(
                      label: '45 Mins',
                      isActive: _activeDurationButton == 5,
                      buttonColor: _getColor(),
                      onPressed: () => _setDuration(45 * 60, 5),
                    ),
                    _DurationButton(
                      label: '60 Mins',
                      isActive: _activeDurationButton == 6,
                      buttonColor: _getColor(),
                      onPressed: () => _setDuration(60 * 60, 6),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],

            // Practice Types Section
            Text(
              'What do you fancy practicing today?',
              style: TextStyle(fontSize: 18, color: _getColor()),
            ),
            ..._practiceTypes.keys.map((type) {
              return CheckboxListTile(
                title: Text(type),
                value: _practiceTypes[type],
                onChanged: (bool? value) {
                  setState(() => _practiceTypes[type] = value ?? false);
                },
              );
            }),
            SizedBox(height: 20),

            // Timer and Buttons
            Center(
              child: Column(
                children: [
                  Text(
                    getTimerText(),
                    style: TextStyle(fontSize: 40, color: _getColor()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _startTimer,
                        child: Text(_isTimerRunning ? 'Pause' : 'Start'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _endTimer,
                        child: Text('End'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Weekly Progress Indicator
            LinearProgressIndicator(
              value: _weeklyProgress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
            ),
          ],
        ),
      ),
    );
  }
}

// Duration Button Widget
class _DurationButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color buttonColor;
  final VoidCallback onPressed;

  const _DurationButton({
    required this.label,
    required this.isActive,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.grey : buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}