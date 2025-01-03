import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'quiz_data.dart';
import 'package:flutter/foundation.dart';

class QuizScreen extends HookWidget {
  const QuizScreen({super.key});
  static String id = "quiz_screen";

  @override
  Widget build(BuildContext context) {
    // State management using hooks
    final currentQuestionIndex = useState(0);
    final score = useState(0);
    final countdown = useState(10);
    final isCapturing = useState(false);
    final isCameraOn = useState(false);
    final isOptionSelected = useState(false);
    final selectedAnswer = useState('');
    final isAnswerCorrect = useState(false);
    final showNextButton = useState(false);
    final mediaStream = useState<html.MediaStream?>(null);
    
    // Video elements
    final videoElement = useMemoized(() {
      final element = html.VideoElement()
        ..autoplay = true
        ..style.width = '700px'
        ..style.height = '700px';
      return element;
    });
    
    final canvasElement = useMemoized(() => html.CanvasElement(width: 500, height: 500));

    // Initialize video element registration
    useEffect(() {
      if (kIsWeb) {
        js.context['HTMLElementWrappingImplementation'] ??= js.allowInterop(() {});
        final viewType = 'video-player-${DateTime.now().millisecondsSinceEpoch}';
        final viewFactory = (int viewId) => videoElement;
        js.context['$viewType'] = viewFactory;
      }
      return null;
    }, []);

    // Timer effect
    useEffect(() {
      if (!isOptionSelected.value && countdown.value > 0) {
        final timer = Future.delayed(const Duration(seconds: 1), () {
          countdown.value--;
          if (countdown.value == 0) {
            showNextButton.value = true;
          }
        });
        return () => timer;
      }
      return null;
    }, [countdown.value, isOptionSelected.value]);

    // Camera control functions
    Future<void> startCamera() async {
      try {
        if (kIsWeb) {
          final stream = await html.window.navigator.getUserMedia(video: true);
          mediaStream.value = stream;
          videoElement.srcObject = stream;
          isCameraOn.value = true;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }

    void stopCamera() {
      if (kIsWeb) {
        mediaStream.value?.getTracks().forEach((track) => track.stop());
        videoElement.srcObject = null;
        isCameraOn.value = false;
      }
    }

    void handleOptionSelected(String selected) {
      if (isOptionSelected.value) return;

      final correctAnswer = QuizData.questions[currentQuestionIndex.value]['answer'];
      isOptionSelected.value = true;
      selectedAnswer.value = selected;
      isAnswerCorrect.value = selected == correctAnswer;
      
      if (isAnswerCorrect.value) {
        score.value++;
      }
      showNextButton.value = true;
    }

    void nextQuestion() {
      if (currentQuestionIndex.value < QuizData.questions.length - 1) {
        currentQuestionIndex.value++;
        countdown.value = 10;
        isOptionSelected.value = false;
        showNextButton.value = false;
        selectedAnswer.value = '';
      } else {
        showResultDialog(context, score.value, stopCamera);
      }
    }

    final currentQuestion = QuizData.questions[currentQuestionIndex.value];
    final options = currentQuestion['options'] as List<Map<String, String>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Quiz' , style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lobster',
        ),),
        backgroundColor: Colors.teal.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isCameraOn.value ? Icons.camera_alt : Icons.camera_alt_outlined,
              color: Colors.white,
              size: options.length > 4 ? 24 : 28,
            ),
            onPressed: isCameraOn.value ? stopCamera : startCamera,
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressIndicator(
                currentQuestionIndex.value,
                QuizData.questions.length,
                countdown.value,
              ),
              _buildQuestionCard(currentQuestion['question'] as String),
              if (isCameraOn.value)
                _buildCameraPreview(videoElement),
              Expanded(
                child: _buildOptionsGrid(
                  options,
                  selectedAnswer.value,
                  isAnswerCorrect.value,
                  isOptionSelected.value,
                  handleOptionSelected,
                ),
              ),
              if (showNextButton.value)
                _buildNextButton(nextQuestion),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview(html.VideoElement videoElement) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: HtmlElementView(
        key: UniqueKey(),
        viewType: 'video-player-${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  Widget _buildProgressIndicator(int currentIndex, int total, int timeLeft) { 
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentIndex + 1}/$total',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: timeLeft > 5 ? Colors.white : Colors.red.shade400,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '$timeLeft seconds',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: timeLeft > 20 ? Colors.teal.shade800 : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (currentIndex + 1) / total,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          question,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade800,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(
    List<Map<String, String>> options,
    String selectedAnswer,
    bool isAnswerCorrect,
    bool isOptionSelected,
    Function(String) onOptionSelected,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedAnswer == option['name'];
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected
                ? (isAnswerCorrect ? Colors.green.shade100 : Colors.red.shade100)
                : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => onOptionSelected(option['name']!),
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    option['gif']!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  option['name']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                if (isSelected)
                  Icon(
                    isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                    color: isAnswerCorrect ? Colors.green : Colors.red,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton(VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Next Question',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void showResultDialog(BuildContext context, int score, VoidCallback onClose) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quiz Completed! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You scored $score out of ${QuizData.questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                onClose();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

