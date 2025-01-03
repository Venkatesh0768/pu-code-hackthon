import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'quiz_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  static String id = "quiz_screen";

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late html.VideoElement _videoElement;
  late html.CanvasElement _canvasElement;
  bool isCapturing = false;
  bool isCameraOn = false;
  int countdown = 3;
  int currentQuestionIndex = 0;
  int score = 0;
  html.MediaStream? _mediaStream;

  @override
  void initState() {
    super.initState();
    _initializeVideoElement();
  }

  void _initializeVideoElement() {
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..style.width = '700px'
      ..style.height = '700px';

    _canvasElement = html.CanvasElement(width: 500, height: 500);

    // Register video element
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'videoElement',
      (int viewId) => _videoElement,
    );
  }

  Future<void> startCamera() async {
    try {
      _mediaStream = await html.window.navigator.getUserMedia(video: true);
      _videoElement.srcObject = _mediaStream;
      setState(() => isCameraOn = true);
    } catch (e) {
      print('Error starting camera: $e');
    }
  }

  void stopCamera() {
    _mediaStream?.getTracks().forEach((track) => track.stop());
    _videoElement.srcObject = null;
    setState(() => isCameraOn = false);
  }

  void startCapture() {
    if (!isCameraOn) return;
    
    setState(() {
      isCapturing = true;
      countdown = 3;
    });

    Future.doWhile(() async {
      if (countdown > 0) {
        setState(() => countdown--);
        await Future.delayed(const Duration(seconds: 1));
        return true;
      } else {
        captureAndAnalyze();
        return false;
      }
    });
  }

  void captureAndAnalyze() {
    _canvasElement.context2D.drawImage(_videoElement, 300, 300);
    bool isCorrect = DateTime.now().millisecond % 2 == 0;
    
    if (isCorrect) score++;

    setState(() {
      isCapturing = false;
      if (currentQuestionIndex < QuizData.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Text(
          'You scored $score out of ${QuizData.questions.length}.',
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              stopCamera();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Quiz'),
        backgroundColor: Colors.teal.shade400,
        actions: [
          IconButton(
            icon: Icon(isCameraOn ? Icons.camera_alt : Icons.camera_alt_outlined),
            onPressed: isCameraOn ? stopCamera : startCamera,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.teal.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                QuizData.questions[currentQuestionIndex]['question'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (isCameraOn) ...[
              SizedBox(
                
                height: 700,
                width: 700,
                child: HtmlElementView(viewType: 'videoElement'),
              ),
              const SizedBox(height: 20),
              if (isCapturing)
                Text(
                  countdown.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                ElevatedButton(
                  onPressed: startCapture,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal.shade800,
                  ),
                  child: const Text('Start Sign Capture'),
                ),
            ] else
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Click the camera icon to start',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopCamera();
    super.dispose();
  }
}