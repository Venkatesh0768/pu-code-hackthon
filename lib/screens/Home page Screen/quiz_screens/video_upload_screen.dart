// import 'package:flutter/material.dart';
// import 'dart:html' as html;
// import 'dart:ui' as ui;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:js' as js;
// import 'quiz_data.dart';

// class QuizScreen extends StatefulWidget {
//   const QuizScreen({super.key});
//   static String id = "quiz_screen";

//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   late html.VideoElement _videoElement;
//   late html.MediaRecorder _mediaRecorder;
//   bool isCapturing = false;
//   bool isCameraOn = false;
//   bool isRecording = false;
//   int countdown = 3;
//   int currentQuestionIndex = 0;
//   int score = 0;
//   html.MediaStream? _mediaStream;
//   List<html.Blob> recordedChunks = [];

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoElement();
//   }

//   void _initializeVideoElement() {
//     _videoElement = html.VideoElement()
//       ..autoplay = true
//       ..style.width = '300px'
//       ..style.height = '300px';

//     // Register video element
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(
//       'videoElement',
//       (int viewId) => _videoElement,
//     );
//   }

//   Future<void> startCamera() async {
//     try {
//       _mediaStream = await html.window.navigator.getUserMedia(video: true);
//       _videoElement.srcObject = _mediaStream;
      
//       // Initialize MediaRecorder
//       _mediaRecorder = html.MediaRecorder(_mediaStream!, {
//         'mimeType': 'video/webm'
//       });
      
//       _mediaRecorder.addEventListener('dataavailable', (event) {
//         final blobEvent = event as html.BlobEvent;
//         if (blobEvent.data != null && blobEvent.data!.size > 0) {
//           if (blobEvent.data != null) {
//             recordedChunks.add(blobEvent.data!);
//           }
//         }
//       });

//       _mediaRecorder.addEventListener('stop', (e) {
//         final blob = html.Blob(recordedChunks, 'video/webm');
//         sendVideoToServer(blob);
//         recordedChunks = [];
//       });

//       setState(() => isCameraOn = true);
//     } catch (e) {
//       print('Error starting camera: $e');
//     }
//   }

//   void stopCamera() {
//     _mediaStream?.getTracks().forEach((track) => track.stop());
//     _videoElement.srcObject = null;
//     setState(() => isCameraOn = false);
//   }

//   void startRecording() {
//     if (!isCameraOn) return;
    
//     setState(() {
//       isCapturing = true;
//       isRecording = true;
//       countdown = 3;
//     });

//     Future.doWhile(() async {
//       if (countdown > 0) {
//         setState(() => countdown--);
//         await Future.delayed(const Duration(seconds: 1));
//         return true;
//       } else {
//         _mediaRecorder.start();
//         await Future.delayed(const Duration(seconds: 3)); // Record for 3 seconds
//         stopRecording();
//         return false;
//       }
//     });
//   }

//   void stopRecording() {
//     if (isRecording) {
//       _mediaRecorder.stop();
//       setState(() {
//         isRecording = false;
//         isCapturing = false;
//       });
//     }
//   }

//   Future<void> sendVideoToServer(html.Blob videoBlob) async {
//     try {
//       final url = Uri.parse('http://localhost:3000/predict');
      
//       // Create FormData
//       final formData = html.FormData();
//       formData.appendBlob('video', videoBlob);

//       // Send request using native HTML request
//       final request = html.HttpRequest();
//       request.open('POST', url.toString());
      
//       request.onLoad.listen((e) {
//         if (request.status == 200) {
//           final responseText = request.responseText ?? '';
//           final predictions = json.decode(responseText)['predictions'] as List;
//           checkPrediction(predictions);
//         } else {
//           print('Error: ${request.statusText}');
//         }
//       });

//       request.send(formData);
//     } catch (e) {
//       print('Error sending video: $e');
//     }
//   }

//   void checkPrediction(List predictions) {
//     final correctSign = QuizData.questions[currentQuestionIndex]['correctSign'];
    
//     if (predictions.contains(correctSign)) {
//       score++;
//     }

//     setState(() {
//       if (currentQuestionIndex < QuizData.questions.length - 1) {
//         currentQuestionIndex++;
//       } else {
//         _showResultDialog();
//       }
//     });
//   }

//   void _showResultDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Quiz Completed!'),
//         content: Text(
//           'You scored $score out of ${QuizData.questions.length}.',
//           style: const TextStyle(fontSize: 18),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               stopCamera();
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             child: const Text('Back to Home'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Language Quiz'),
//         backgroundColor: Colors.teal.shade400,
//         actions: [
//           IconButton(
//             icon: Icon(isCameraOn ? Icons.camera_alt : Icons.camera_alt_outlined),
//             onPressed: isCameraOn ? stopCamera : startCamera,
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.teal.shade400, Colors.teal.shade900],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 QuizData.questions[currentQuestionIndex]['question'],
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             if (isCameraOn) ...[
//               SizedBox(
//                 height: 300,
//                 width: 300,
//                 child: HtmlElementView(viewType: 'videoElement'),
//               ),
//               const SizedBox(height: 20),
//               if (isCapturing)
//                 Text(
//                   countdown.toString(),
//                   style: const TextStyle(
//                     fontSize: 48,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               else
//                 ElevatedButton(
//                   onPressed: startRecording,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.teal.shade800,
//                   ),
//                   child: Text(isRecording ? 'Recording...' : 'Start Recording'),
//                 ),
//             ] else
//               const Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Text(
//                   'Click the camera icon to start',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     stopCamera();
//     super.dispose();
//   }
// }