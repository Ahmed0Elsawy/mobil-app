import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../widgets/curved_app_bar_painter.dart';
import '../widgets/neumorphic_button.dart';

class BrainTumorScreen extends StatefulWidget {
  const BrainTumorScreen({super.key});

  @override
  State<BrainTumorScreen> createState() => _BrainTumorScreenState();
}

class _BrainTumorScreenState extends State<BrainTumorScreen> {
  Interpreter? _interpreter;
  File? _image;
  String _result = "Upload an image to classify";
  double _confidence = 0.0;
  final picker = ImagePicker();
  final List<String> classNames = [
    'Glioma',
    'Meningioma',
    'No Tumor',
    'Pituitary',
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      setState(() {});
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      classifyImage(File(pickedFile.path));
    }
  }

  Future<void> classifyImage(File imageFile) async {
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) return;

    // Preprocess image
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
    Uint8List imageBytes = resizedImage.getBytes(order: img.ChannelOrder.rgb);

    List input = [
      imageBytes.buffer.asUint8List().map((e) => e / 255.0).toList(),
    ];
    List<List<double>> output = List.generate(1, (_) => List.filled(4, 0));

    _interpreter?.run(input, output);

    int predictedIndex = output[0].indexOf(
      output[0].reduce((a, b) => a > b ? a : b),
    );
    double confidence = output[0][predictedIndex] * 100;

    setState(() {
      _result = classNames[predictedIndex];
      _confidence = confidence;
    });
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200,
              child: CustomPaint(painter: CurvedAppBarPainter()),
            ),
          ),

          // App Bar Content
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Brain Tumor Classifier',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text(
                              'About Brain Tumor Classification',
                            ),
                            content: const Text(
                              'This tool uses AI to classify MRI scans into four categories: Glioma, Meningioma, No Tumor, or Pituitary tumor. Upload a brain MRI scan to get started.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Main Content
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child:
                        _image == null
                            ? const Center(
                              child: Text(
                                "No image selected",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(_image!, fit: BoxFit.contain),
                            ),
                  ),
                  const SizedBox(height: 30),
                  NeumorphicButton(
                    onPressed: pickImage,
                    child: const Text(
                      "Upload MRI Image",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Results",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Classification: $_result",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Confidence: ${_confidence.toStringAsFixed(2)}%",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
