import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const TasbeehApp());
}

class TasbeehApp extends StatelessWidget {
  const TasbeehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasbeeh Counter',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green[700],
        scaffoldBackgroundColor: Colors.green[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.green[900],
        scaffoldBackgroundColor: Colors.black87,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[900],
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TasbeehHome(),
    );
  }
}

class TasbeehHome extends StatefulWidget {
  const TasbeehHome({super.key});

  @override
  _TasbeehHomeState createState() => _TasbeehHomeState();
}

class _TasbeehHomeState extends State<TasbeehHome> {
  List<String> phrases = ['SubhanAllah', 'Alhamdulillah', 'Allahu Akbar'];
  int _currentPhraseIndex = 0;
  List<int> _counts = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < phrases.length; i++) {
        _counts[i] = prefs.getInt(phrases[i]) ?? 0;
      }
    });
  }

  Future<void> _saveCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < phrases.length; i++) {
      prefs.setInt(phrases[i], _counts[i]);
    }
  }

  void _incrementCounter() async {
    setState(() {
      _counts[_currentPhraseIndex]++;
    });
    _saveCounts();

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
  }

  void _resetCounter() {
    setState(() {
      _counts[_currentPhraseIndex] = 0;
    });
    _saveCounts();
  }

  void _nextPhrase() {
    setState(() {
      _currentPhraseIndex = (_currentPhraseIndex + 1) % phrases.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbeeh Counter'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  phrases[_currentPhraseIndex],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${_counts[_currentPhraseIndex]}',
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: _incrementCounter, child: const Text('Add')),
                    const SizedBox(width: 20),
                    ElevatedButton(onPressed: _resetCounter, child: const Text('Reset')),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _nextPhrase, child: const Text('Next Phrase')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
