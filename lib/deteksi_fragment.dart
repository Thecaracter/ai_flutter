import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'bottom_nav_bar.dart';

class DeteksiFragment extends StatefulWidget {
  const DeteksiFragment({super.key});

  @override
  _DeteksiFragmentState createState() => _DeteksiFragmentState();
}

class _DeteksiFragmentState extends State<DeteksiFragment>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  XFile? _imageFile;
  String _detectionResult = '';
  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();
  bool _isCameraInitialized = false;
  bool _isCameraMode = false;
  List<double> _confidenceValues = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeTFLite();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _initializeTFLite() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/daging.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat model: $e')),
      );
    }
  }

  Future<void> _initializeCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );

        try {
          await _cameraController!.initialize();
          setState(() {
            _isCameraInitialized = true;
            _isCameraMode = true;
          });
        } catch (e) {
          print('Camera initialization error: $e');
        }
      }
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamera belum siap')),
      );
      return;
    }

    try {
      XFile? photo = await _cameraController!.takePicture();
      setState(() {
        _imageFile = photo;
        _isCameraMode = false;
      });

      if (photo != null) {
        await _processImage(File(photo.path));
      }
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _imageFile = photo;
        _isCameraMode = false;
      });

      // Proses deteksi setelah foto dipilih
      if (photo != null) {
        await _processImage(File(photo.path));
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar: $e')),
      );
    }
  }

  Future<void> _processImage(File imageFile) async {
    try {
      // Validasi model sudah dimuat
      if (_interpreter == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Model belum dimuat')),
        );
        return;
      }

      // Baca dan proses gambar
      img.Image? image = img.decodeImage(await imageFile.readAsBytes());

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memproses gambar')),
        );
        return;
      }

      // Resize gambar sesuai input model (misalnya 224x224)
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Konversi ke tensor float
      var inputImage = List.generate(
          1,
          (_) => List.generate(224,
              (_) => List.generate(224, (_) => List.generate(3, (_) => 0.0))));

      // Normalisasi pixel
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          inputImage[0][y][x][0] = (pixel.r / 255.0 - 0.5) * 2.0;
          inputImage[0][y][x][1] = (pixel.g / 255.0 - 0.5) * 2.0;
          inputImage[0][y][x][2] = (pixel.b / 255.0 - 0.5) * 2.0;
        }
      }

      // Output tensor
      var output = List.filled(1 * 3, 0.0).reshape([1, 3]);

      // Jalankan inferensi
      _interpreter?.run(inputImage, output);

      // Proses hasil deteksi
      var confidence = output[0] as List<double>;

      // Debugging: print semua confidence
      print('Confidence values: $confidence');

      int maxIndex =
          confidence.indexOf(confidence.reduce((a, b) => a > b ? a : b));

      // Tambahkan kondisi untuk memastikan kepercayaan minimal
      final categories = ['Busuk', 'Segar', 'Tidak Segar'];

      String detectionCategory;
      double maxConfidence = confidence[maxIndex];

      // Tentukan kategori berdasarkan tingkat kepercayaan
      if (maxConfidence < 0.5) {
        detectionCategory = 'Tidak Yakin';
      } else if (maxConfidence < 0.7) {
        detectionCategory = categories[maxIndex];
      } else {
        detectionCategory = categories[maxIndex];
      }

      setState(() {
        _confidenceValues = confidence;
        _detectionResult = 'Hasil Deteksi: $detectionCategory'
            '\nKepercayaan: ${(maxConfidence * 100).toStringAsFixed(2)}%\n'
            'Busuk: ${(confidence[0] * 100).toStringAsFixed(2)}%\n'
            'Segar: ${(confidence[1] * 100).toStringAsFixed(2)}%\n'
            'Tidak Segar: ${(confidence[2] * 100).toStringAsFixed(2)}%';
      });
    } catch (e) {
      print('Error processing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses gambar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Stack(
              children: [
                // Background dengan pattern
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.03,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      itemBuilder: (_, __) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),

                // Konten utama
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tampilkan gambar atau pratinjau kamera
                        if (_imageFile != null) ...[
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(_imageFile!.path),
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.refresh,
                                            color: Colors.white, size: 30),
                                        onPressed: () {
                                          setState(() {
                                            _imageFile = null;
                                            _detectionResult = '';
                                            _initializeCamera();
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 20),
                                      IconButton(
                                        icon: const Icon(Icons.photo_library,
                                            color: Colors.white, size: 30),
                                        onPressed: _pickImageFromGallery,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ] else if (_isCameraMode && _isCameraInitialized) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.photo_library,
                                      color: secondaryColor),
                                  iconSize: 40,
                                  onPressed: _pickImageFromGallery,
                                ),
                              ),
                              const SizedBox(width: 40),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt,
                                      color: Colors.white),
                                  iconSize: 50,
                                  onPressed: _takePicture,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Tampilkan hasil deteksi
                        if (_detectionResult.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              _detectionResult,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Tampilan default sebelum kamera
                        if (!_isCameraMode) ...[
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 70,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Deteksi Daging Kambing',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Mulai pemindaian untuk menganalisis kualitas daging',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: 240,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                colors: [primaryColor, secondaryColor],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: _initializeCamera,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Mulai Deteksi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextButton.icon(
                            onPressed: _pickImageFromGallery,
                            icon: const Icon(Icons.photo_library,
                                color: secondaryColor),
                            label: const Text(
                              'Pilih dari Galeri',
                              style: TextStyle(color: secondaryColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
