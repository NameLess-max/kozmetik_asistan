import 'package:flutter/material.dart';
import '../theme.dart';
import 'camera_screen.dart'; // Bu satırı ekle

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoş Geldin! 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Profil sayfasına gidiş
            },
          ),
        ],
      ),

      // Merkezi Tarama Butonu (CTA)[cite: 1]
      // Ekranın alt ortasında, kamerayı açacak belirgin buton[cite: 1]
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Sayfa geçiş kodu
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CameraScreen()),
          );
        },
        backgroundColor: AppTheme.primaryNavy,
        elevation: 4,
        icon: const Icon(Icons.document_scanner, color: Colors.white),
        label: const Text(
          'Etiket Tara',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Eğitici İçerik Kartı[cite: 1]
              _buildEducationalCard(context),

              const SizedBox(height: 30),

              // Son Analizler Başlığı[cite: 1]
              Text(
                'Son Analizler',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 15),

              // Son 3 taratılan ürünün listesi[cite: 1]
              _buildRecentScansList(),

              // Altta butonun üstüne binmemesi için ekstra boşluk
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Bileşen: Günlük Eğitici İçerik (Örn: Paraben nedir?)[cite: 1]
  Widget _buildEducationalCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryGreen.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondaryGreen.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.science, color: AppTheme.secondaryGreen, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günün Bilgisi',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Paraben nedir ve cilde etkileri nelerdir?',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Bileşen: Son Analizler Kısa Listesi (Son 3 Ürün)[cite: 1]
  Widget _buildRecentScansList() {
    // Şimdilik UI görmek için 3 adet sahte (mock) veri oluşturuyoruz
    final List<Map<String, dynamic>> recentScans = [
      {"name": "Nemlendirici Yüz Kremi", "score": 85, "risk": "Düşük"},
      {"name": "Güneş Kremi 50+ SPF", "score": 40, "risk": "Yüksek"},
      {"name": "C Vitamini Serumu", "score": 95, "risk": "Temiz"},
    ];

    return ListView.builder(
      shrinkWrap: true, // Scroll içinde Scroll hatasını önler
      physics: const NeverScrollableScrollPhysics(), // Kaydırmayı ana SingleChildScrollView'a bırakır
      itemCount: recentScans.length,
      itemBuilder: (context, index) {
        final item = recentScans[index];
        final bool isHighRisk = item["risk"] == "Yüksek";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: isHighRisk
                  ? AppTheme.warningOrange.withOpacity(0.2)
                  : AppTheme.secondaryGreen.withOpacity(0.2),
              child: Icon(
                isHighRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: isHighRisk ? AppTheme.warningOrange : AppTheme.secondaryGreen,
              ),
            ),
            title: Text(
              item["name"],
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryNavy),
            ),
            subtitle: Text('Skor: ${item["score"]}/100'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              // TODO: Ürün detay ekranına yönlendirme
            },
          ),
        );
      },
    );
  }
}