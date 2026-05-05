import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../main.dart';
import '../theme.dart';
 import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

// Animasyonları kullanabilmek için "SingleTickerProviderStateMixin" ekliyoruz
class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  // Lazer Tarama Animasyonu İçin Kontrolcüler
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Kamera Kurulumu
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
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

    // 2. Tarama Lazer Animasyonu Kurulumu
    _scanController = AnimationController(
      duration: const Duration(seconds: 2), // Lazerin bir tur inip çıkma süresi
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scanController.dispose(); // Bellek sızıntısını önlemek için animasyonu da kapatıyoruz
    super.dispose();
  }

  Future<void> _captureAndSendToOCR() async {
    if (!_controller.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _scanController.repeat(reverse: true); // Lazer animasyonunu başlat (Aşağı-Yukarı)
    });

    try {
      final XFile imageFile = await _controller.takePicture();
      debugPrint("Fotoğraf başarıyla çekildi: ${imageFile.path}");

      // Backend'e Gönderme Simülasyonu
      await _processImageWithDio(imageFile.path);

    } catch (e) {
      debugPrint("Fotoğraf çekilirken hata oluştu: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğraf çekilemedi, lütfen tekrar deneyin.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _scanController.stop(); // İşlem bitince lazeri durdur
        });
      }
    }
  }

  Future<void> _processImageWithDio(String filePath) async {
    // API bekleme simülasyonu (Lazerin tarama süresi)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // Navigator.pushReplacement kullanıyoruz çünkü kullanıcı
      // sonuç ekranından "geri" tuşuna basarsa tekrar kameraya değil ana sayfaya dönsün.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultScreen(
            // Şimdilik OCR'dan geliyormuş gibi sahte (mock) veri veriyoruz
            productName: "Taranan Kozmetik Ürünü",
            score: 45,
            riskLevel: "Yüksek",
            safeIngredients: ['Su', 'Gliserin'],
            riskyIngredients: ['Paraben', 'Sülfat', 'Yapay Renklendirici'],
            alternativeSuggestion: "Bu ürün sentetik koruyucular içeriyor. Hassas bir cildiniz (Karma) olduğu için %100 doğal içerikli, aloe vera bazlı ürünler tercih etmeniz önerilir.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vizörün (Çerçevenin) boyutları
    final double viewfinderWidth = MediaQuery.of(context).size.width * 0.8;
    const double viewfinderHeight = 250.0;

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

          // 3. Katman: YENİ AKILLI VİZÖR (Tarama Çerçevesi)
          Center(
            child: Container(
              width: viewfinderWidth,
              height: viewfinderHeight,
              decoration: BoxDecoration(
                border: Border.all(
                    color: _isProcessing ? AppTheme.secondaryGreen : Colors.white70,
                    width: _isProcessing ? 3 : 2
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Sadece işlem sırasında çalışan Lazer Çizgisi Animasyonu
                    if (_isProcessing)
                      AnimatedBuilder(
                        animation: _scanAnimation,
                        builder: (context, child) {
                          // Lazerin yukarıdan aşağı inme pozisyonu
                          return Positioned(
                            top: _scanAnimation.value * (viewfinderHeight - 4),
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4, // Lazerin kalınlığı
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryGreen,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.secondaryGreen.withOpacity(0.8),
                                    blurRadius: 15,
                                    spreadRadius: 3, // Etrafa yayılan parlak yeşil ışık efekti
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Katman: İşlem Sırasında Çıkan Yükleniyor Ekranı (Daha Akıllı Hissiyat)
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 320), // Vizörün hemen altına yerleştirmek için
                    CircularProgressIndicator(color: AppTheme.secondaryGreen),
                    SizedBox(height: 16),
                    Text(
                      "İçerik ve Sertifikalar Analiz Ediliyor...", // Logo tanıdığını hissettiren metin
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)]
                      ),
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
                    "Ürün etiketini veya sertifika logolarını hizalayın",
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
                        onTap: _captureAndSendToOCR,
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