import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Eğitici kartların içerikleri
  final List<Map<String, String>> onboardingData = [
    {
      "title": "Akıllı OCR Taraması",
      "description": "Kamera ile ürün etiketlerini saniyeler içinde tarayın. Karmaşık kimyasal isimleri biz çözelim.",
      "icon": "camera_alt"
    },
    {
      "title": "Gemini AI Analizi",
      "description": "Yapay zeka sayesinde, içeriklerin profilinize ve hassasiyetlerinize uygunluğunu anında öğrenin.",
      "icon": "psychology"
    },
    {
      "title": "Bilimsel Kanıtlar",
      "description": "Dürtüsel alışverişi bırakın. Güvenilir, şeffaf ve sağlıklı seçimler yaparak cildinizi koruyun.",
      "icon": "science"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Geç (Skip) Butonu
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Login ekranına yönlendirme eklenecek
                },
                child: const Text(
                  "Geç",
                  style: TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Marka Logosu Alanı
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.spa, // Logo gelene kadar geçici ikon
                    size: 60,
                    color: AppTheme.secondaryGreen,
                  ),
                ),
              ),
            ),

            // Kaydırılabilir Bilgi Kartları
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIcon(onboardingData[index]["icon"]!),
                          size: 80,
                          color: AppTheme.primaryNavy,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          onboardingData[index]["title"]!,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          onboardingData[index]["description"]!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Sayfa Göstergeleri (Noktalar) ve İleri Butonu
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        onboardingData.length,
                            (index) => buildDot(index: index),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == onboardingData.length - 1) {
                          // TODO: Son sayfadaysa Login ekranına geçiş yapılacak
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(_currentPage == onboardingData.length - 1 ? "Başla" : "İleri"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dinamik ikon seçici yardımcı fonksiyon
  IconData _getIcon(String iconName) {
    switch (iconName) {
      case "camera_alt": return Icons.camera_alt;
      case "psychology": return Icons.psychology;
      case "science": return Icons.science;
      default: return Icons.info;
    }
  }

  // Nokta göstergelerini çizen widget
  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppTheme.secondaryGreen : AppTheme.primaryNavy.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}