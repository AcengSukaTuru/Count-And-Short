import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package
import 'home.dart'; // Import the Home screen
import 'database_helper.dart'; // Import the database helper

class Play extends StatefulWidget {
  const Play({super.key});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  late List<int> numbers;
  late List<String> bubbleImages;
  late List<bool> isBubbleClicked; // Tambakan daftar untuk status klikh
  int currentIndex = 0;
  bool isGameOver = false;
  late Timer _timer;
  double timeLeft = 30.0;
  int mistakes = 0;
  double highScore = double.infinity; // Default waktu tertinggi
  int highScoreMistakes = 0; // Default kesalahan pada waktu tertinggi
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Initialize DatabaseHelper

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHighScore();
  }

  void _initializeGame() {
    numbers = List.generate(10, (index) => Random().nextInt(99) + 1);
    numbers.shuffle();
    bubbleImages =
        List.generate(10, (index) => 'assets/images/number_bubble.png');
    isBubbleClicked = List.generate(10, (index) => false); // Inisialisasi klik
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (timeLeft > 0 && !isGameOver) {
        setState(() {
          timeLeft -= 0.1;
        });
      } else {
        _timer.cancel();
        setState(() {
          isGameOver = true;
        });
        _onGameOver();
      }
    });
  }

  void _loadHighScore() async {
    final highScoreData = await _databaseHelper.getHighScore();
    if (highScoreData != null) {
      setState(() {
        highScore = highScoreData['score'];
        highScoreMistakes = highScoreData['mistakes'];
      });
    }
  }

  void _onGameOver() {
    _timer.cancel();
    setState(() {
      isGameOver = true;
      double currentTime = 30.0 - timeLeft;
      // Tambahkan kesalahan untuk bubble yang tidak diklik
      mistakes += isBubbleClicked.where((clicked) => !clicked).length;
      if (currentTime < highScore) {
        highScore = currentTime; // Perbarui waktu terbaik
        highScoreMistakes = mistakes; // Perbarui kesalahan pada waktu terbaik
        _databaseHelper.insertHighScore(highScore, highScoreMistakes); // Simpan ke database
      }
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isGameOver && currentIndex == numbers.length
                  ? 'Kamu Berhasil'
                  : 'Game Over',
              style: const TextStyle(
                fontSize: 96.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7C7DEB),
                fontFamily: 'Baloo',
              ),
            ),
            const SizedBox(height: 20),
            // Dua Kolom untuk High Score dan Waktu Sekarang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // High Score Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'High Score',
                      style: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey[600],
                        fontFamily: 'Baloo',
                      ),
                    ),
                    Text(
                      highScore == double.infinity
                          ? 'Belum Ada'
                          : highScore.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7C7DEB),
                        fontFamily: 'Baloo',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kesalahan: $highScoreMistakes',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                        color: Colors.red[400],
                        fontFamily: 'Baloo',
                      ),
                    ),
                  ],
                ),
                // Spacer for spacing between columns
                const SizedBox(width: 20),
                // Current Waktu Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waktu',
                      style: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[400],
                        fontFamily: 'Baloo',
                      ),
                    ),
                    Text(
                      (30.0 - timeLeft).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: 'Baloo',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kesalahan: $mistakes',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w500,
                        color: Colors.red[400],
                        fontFamily: 'Baloo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _initializeGame(); // Mulai ulang game
                setState(() {
                  currentIndex = 0;
                  isGameOver = false;
                  timeLeft = 30.0;
                  mistakes = 0;
                });
                _startTimer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C7DEB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Main lagi',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'Baloo',
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Kembali ke Menu',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'Baloo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBubbleClick(int number, int index) {
    if (isGameOver || isBubbleClicked[index]) return; // Cegah klik ulang

    List<int> sortedNumbers = List.from(numbers)..sort();

    setState(() {
      isBubbleClicked[index] = true; // Tandai bubble sudah diklik
    });

    _audioPlayer.play(AssetSource('sounds/bubble_sound.mp3')); // Play sound

    if (number == sortedNumbers[currentIndex]) {
      setState(() {
        bubbleImages[index] = 'assets/images/benar.png';
        currentIndex++;
      });

      // Cek jika semua angka sudah diklik dengan urutan benar
      if (currentIndex == sortedNumbers.length && !isGameOver) {
        setState(() {
          isGameOver = true; // Akhiri permainan
        });
        _onGameOver();
      }
    } else {
      setState(() {
        bubbleImages[index] = 'assets/images/salah.png';
        mistakes++;
      });
    }

    // Cek jika semua bubble sudah diklik (baik benar/salah)
    if (isBubbleClicked.every((clicked) => clicked) && !isGameOver) {
      setState(() {
        isGameOver = true; // Akhiri permainan
      });
      _onGameOver();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EAFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF7C7DEB)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF7C7DEB)),
            onPressed: () {
              _initializeGame(); // Mulai ulang game
              setState(() {
                currentIndex = 0;
                isGameOver = false;
                timeLeft = 30.0;
                mistakes = 0;
              });
              _startTimer();
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, color: Color(0xFF7C7DEB)),
            const SizedBox(width: 5),
            Text(
              timeLeft.toStringAsFixed(1),
              style: const TextStyle(
                color: Color(0xFF7C7DEB),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return BubbleWidget(
                  number: numbers[index],
                  imagePath: bubbleImages[index],
                  onBubbleClick: () =>
                      _handleBubbleClick(numbers[index], index),
                );
              }),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return BubbleWidget(
                  number: numbers[index + 5],
                  imagePath: bubbleImages[index + 5],
                  onBubbleClick: () =>
                      _handleBubbleClick(numbers[index + 5], index + 5),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleWidget extends StatelessWidget {
  final int number;
  final String imagePath;
  final VoidCallback onBubbleClick;

  const BubbleWidget({
    required this.number,
    required this.imagePath,
    required this.onBubbleClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBubbleClick,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 160,
              height: 160,
            ),
            if (imagePath == 'assets/images/number_bubble.png')
              Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 62,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Baloo',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
