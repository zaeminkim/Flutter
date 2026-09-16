import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons; // 불필요한 Theme 임포트 제거 (경고 해결)
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const WhackAMoleApp());
}

class WhackAMoleApp extends StatelessWidget {
  const WhackAMoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Whack-a-Mole',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeGreen,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'Roboto',
            color: CupertinoColors.label,
          ),
        ),
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int timeLeft = 30;
  bool isPlaying = false;

  List<bool> activeMoles = List.filled(9, false);

  Timer? gameTimer;
  Timer? moleTimer;
  final Random random = Random();

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      isPlaying = true;
      activeMoles = List.filled(9, false);
    });

    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          endGame();
        }
      });
    });

    moleTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) return;
      if (!isPlaying) return;

      setState(() {
        activeMoles = List.filled(9, false);

        int activeCount = random.nextBool() ? 1 : 2;
        for (int i = 0; i < activeCount; i++) {
          int index = random.nextInt(9);
          while (activeMoles[index]) {
            index = random.nextInt(9);
          }
          activeMoles[index] = true;
        }
      });
    });
  }

  void endGame() {
    gameTimer?.cancel();
    moleTimer?.cancel();
    if (!mounted) return;
    setState(() {
      isPlaying = false;
      activeMoles = List.filled(9, false);
    });

    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('⏰ 게임 종료!', textAlign: TextAlign.center),
        content: Text(
          '최종 점수: $score점\n\n정말 대단한 순발력이네요!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void whackMole(int index) {
    if (!isPlaying) return;

    if (activeMoles[index]) {
      setState(() {
        score += 10;
        activeMoles[index] = false;
      });
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    moleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // lightGreen 대신 systemGreen 사용 (에러 해결)
      backgroundColor: CupertinoColors.systemGreen.withValues(alpha: 0.1),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                _buildGameHeader(),
                const Spacer(flex: 2),
                _buildMoleGrid(),
                const Spacer(flex: 3),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: _buildStartButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    final themeData = CupertinoTheme.of(context);
    final textStyle = themeData.textTheme.textStyle;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemFill.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: CupertinoColors.systemGrey5.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('SCORE', style: textStyle.copyWith(color: CupertinoColors.inactiveGray, fontWeight: FontWeight.bold, fontSize: 14)),
                Text('$score', style: textStyle.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen)),
              ],
            ),
            Column(
              children: [
                Text('TIME', style: textStyle.copyWith(color: CupertinoColors.inactiveGray, fontWeight: FontWeight.bold, fontSize: 14)),
                Text('$timeLeft', style: textStyle.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: timeLeft <= 5 ? CupertinoColors.systemRed : CupertinoColors.activeOrange)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoleGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => whackMole(index),
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBrown.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [
                      CupertinoColors.systemBrown,
                      CupertinoColors.black,
                    ],
                    stops: [0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 5),
                      spreadRadius: -2,
                    )
                  ],
                ),
                child: AnimatedScale(
                  scale: activeMoles[index] ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  child: Center(
                    child: activeMoles[index] ? _buildMoleCharacter() : const SizedBox.shrink(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMoleCharacter() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBrown,
            shape: BoxShape.circle,
            border: Border.all(color: CupertinoColors.black.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        Positioned(
          top: 25,
          left: 18,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(color: CupertinoColors.black, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          top: 25,
          right: 18,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(color: CupertinoColors.black, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          bottom: 15,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: CupertinoColors.systemPink.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              border: Border.all(color: CupertinoColors.black.withValues(alpha: 0.1)),
            ),
          ),
        ),
        // const 키워드 제거 (에러 해결)
        Positioned(
          bottom: 10,
          child: Icon(Icons.face, size: 20, color: CupertinoColors.black.withValues(alpha: 0.3)),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    final themeData = CupertinoTheme.of(context);
    final textStyle = themeData.textTheme.textStyle;

    return AnimatedOpacity(
      opacity: isPlaying ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: CupertinoButton.filled(
        borderRadius: BorderRadius.circular(30),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        onPressed: isPlaying ? null : startGame,
        child: Text(
          '게임 시작',
          style: textStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: CupertinoColors.white),
        ),
      ),
    );
  }
}