import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io'; // Dosya işlemleri için
import '../main.dart';
import '../theme.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  bool _isProcessing = false; // OCR işlemi sırasında ekranı dondurmak için

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high, // Yüksek çözünürlük OCR'ın yazıları okuyabilmesi için şart
      enableAudio: false,
    );

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    }).catchError((e) {
      debugPrint("Kamera Hatası: $e");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- OCR İÇİN FOTOĞRAF ÇEKME VE HAZIRLIK ALTYAPISI ---
  Future<void> _captureAndSendToOCR() async {
    // Eğer kamera hazır değilse veya zaten bir işlem yapılıyorsa butonu kilitle
    if (!_controller.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true; // Yükleniyor animasyonunu başlat
    });

    try {
      // 1. Fotoğrafı Çek
      final XFile imageFile = await _controller.takePicture();
      debugPrint("Fotoğraf başarıyla çekildi: ${imageFile.path}");

      // 2. Backend'e (Python FastAPI) Gönderme Simülasyonu
      await _processImageWithDio(imageFile.path);

    } catch (e) {
      debugPrint("Fotoğraf çekilirken hata oluştu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğraf çekilemedi, lütfen tekrar deneyin.')),
      );
    } finally {
      setState(() {
        _isProcessing = false; // İşlem bitince ekranı normale döndür
      });
    }
  }

  // Backend API bağlandığında çalışacak olan asıl fonksiyon
  Future<void> _processImageWithDio(String filePath) async {
    // Burada 2 saniyelik sahte bir bekleme (API isteği gidip geliyormuş gibi) yapıyoruz
    await Future.delayed(const Duration(seconds: 2));

    /* TODO: Backend hazır olduğunda buradaki yorum satırlarını kaldırıp kodu aktifleştireceğiz
    try {
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: 'etiket.jpg'),
      });

      var response = await dio.post('http://SENIN_IP_ADRESIN:8000/analiz/ocr', data: formData);

      if(response.statusCode == 200) {
        // Gelen veriyi (örneğin Gemini AI'ın bulduğu riskleri) yeni sayfaya gönder
      }
    } catch (e) {
      print("API Hatası: $e");
    }
    */

    if (mounted) {
      // Başarılı olduğunu göstermek için kullanıcıya bildirim ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etiket başarıyla okundu! Sonuçlar getiriliyor...'),
          backgroundColor: AppTheme.secondaryGreen,
        ),
      );
      // Not: Normalde burada Navigator.push ile sonuç ekranına (Kıyaslama/Risk) geçeceğiz.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Katman: Kamera Görüntüsü
          _isCameraInitialized
              ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_controller),
          )
              : const Center(child: CircularProgressIndicator(color: AppTheme.secondaryGreen)),

          // 2. Katman: Geri Butonu
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 3. Katman: Kılavuz Çizgiler (Vizör)
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: _isProcessing ? AppTheme.warningOrange : AppTheme.secondaryGreen, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // 4. Katman: İşlem Sırasında Çıkan Yükleniyor Ekranı
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5), // Ekranı hafif karartır
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppTheme.secondaryGreen),
                    SizedBox(height: 16),
                    Text(
                      "Etiket taranıyor, lütfen bekleyin...",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),

          // 5. Katman: Alt Kontroller
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Ürün etiketini çerçevenin içine hizalayın",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _isProcessing ? null : () {},
                        icon: const Icon(Icons.edit_note, color: Colors.white, size: 32),
                        tooltip: "İçeriği Elle Gir",
                      ),

                      // DEKLANŞÖR BUTONU
                      GestureDetector(
                        onTap: _captureAndSendToOCR, // Yazdığımız fonksiyonu bağladık
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: _isProcessing ? Colors.grey : AppTheme.secondaryGreen,
                          ),
                          child: _isProcessing
                              ? const Icon(Icons.hourglass_empty, color: Colors.white)
                              : const Icon(Icons.camera, color: Colors.white, size: 35),
                        ),
                      ),

                      IconButton(
                        onPressed: _isProcessing ? null : () {},
                        icon: const Icon(Icons.flash_on, color: Colors.white, size: 32),
                        tooltip: "Flaş",
                      ),
                    ],
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