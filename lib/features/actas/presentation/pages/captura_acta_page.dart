import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:appwrite/appwrite.dart';
import 'package:elecciones/injection_container.dart';

class CapturaActaPage extends StatefulWidget {
  const CapturaActaPage({Key? key}) : super(key: key);

  @override
  State<CapturaActaPage> createState() => _CapturaActaPageState();
}

class _CapturaActaPageState extends State<CapturaActaPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPhotoValid = false;

  // Umbral (threshold) de nitidez. Valores más altos requieren fotos más nítidas.
  // 150.0 suele ser un buen balance para evitar fotos movidas, 
  // pero puede ajustarse según las pruebas reales con las cámaras.
  static const double blurThreshold = 150.0;
  static const String bucketId = '6a3d5fe40013ee2986cf';

  late final Storage _storage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _storage = Storage(getIt<Client>());
  }

  Future<void> _procesarImagen(ImageSource source) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isPhotoValid = false;
      _imageFile = null;
    });

    try {
      final XFile? photo = await _picker.pickImage(source: source);
      
      if (photo != null) {
        final File file = File(photo.path);
        
        // Ejecutamos la validación matemática pesada en un Isolate secundario
        // para no congelar la interfaz gráfica mientras procesa los píxeles.
        bool isSharp = await compute(_calculateLaplacianVariance, file.path);

        setState(() {
          if (isSharp) {
            _imageFile = file;
            _isPhotoValid = true;
          } else {
            _errorMessage = '¡La foto está muy borrosa! Vuelve a seleccionarla o tomarla de nuevo.';
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al procesar la foto: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _subirActa() async {
    if (_imageFile == null) return;
    
    setState(() {
      _isUploading = true;
    });

    try {
      final inputFile = InputFile.fromPath(path: _imageFile!.path);
      await _storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: inputFile,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Acta subida correctamente!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir el acta: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  /// Calcula la Varianza del Laplaciano de la imagen para determinar su nitidez.
  /// Se ejecuta en un Isolate separado (gracias a compute()).
  static bool _calculateLaplacianVariance(String imagePath) {
    try {
      final bytes = File(imagePath).readAsBytesSync();
      // Decodificamos la imagen original
      final img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) return false;

      // Convertimos a escala de grises y reducimos tamaño a 400px de ancho
      // para que la iteración de píxeles sea ultra-rápida.
      final img.Image grayscale = img.grayscale(decodedImage);
      final img.Image small = img.copyResize(grayscale, width: 400);

      final int width = small.width;
      final int height = small.height;

      double sum = 0.0;
      List<double> laplacianValues = [];

      // Aplicamos el kernel de convolución de Laplace:
      //  0  1  0
      //  1 -4  1
      //  0  1  0
      for (int y = 1; y < height - 1; y++) {
        for (int x = 1; x < width - 1; x++) {
          final num top = small.getPixel(x, y - 1).r;
          final num bottom = small.getPixel(x, y + 1).r;
          final num left = small.getPixel(x - 1, y).r;
          final num right = small.getPixel(x + 1, y).r;
          final num center = small.getPixel(x, y).r;

          final double laplacian = (top + bottom + left + right - (4 * center)).toDouble();
          laplacianValues.add(laplacian);
          sum += laplacian;
        }
      }

      if (laplacianValues.isEmpty) return false;

      // 1. Calculamos la media del Laplaciano
      final double mean = sum / laplacianValues.length;

      // 2. Calculamos la varianza (nitidez)
      double varianceSum = 0.0;
      for (final val in laplacianValues) {
        varianceSum += (val - mean) * (val - mean);
      }
      final double variance = varianceSum / laplacianValues.length;

      print(">> Varianza de Laplaciano calculada: \$variance");

      return variance >= blurThreshold;
    } catch (e) {
      print("Error en calculo laplaciano: \$e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captura de Acta'),
      ),
      body: Center(
        child: _isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analizando nitidez de la imagen...'),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (_imageFile != null && _isPhotoValid) ...[
                      Image.file(
                        _imageFile!,
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isUploading ? null : _subirActa,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: _isUploading 
                            ? const SizedBox(
                                width: 24, 
                                height: 24, 
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              )
                            : const Text('Enviar a Central (Appwrite)', style: TextStyle(fontSize: 16)),
                      ),
                    ] else ...[
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Aún no has capturado el acta o la anterior fue descartada.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _procesarImagen(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Abrir Cámara'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _procesarImagen(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Subir Foto'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
