import 'package:flutter/material.dart';
import '../theme.dart';
import 'camera_screen.dart';
import 'profile_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // --- LOGOYU BÜYÜTMEK İÇİN YAPILAN AYARLAR ---
        leadingWidth: 100, // Sol köşenin genişliğini 56'dan 80'e çıkardık
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Image.asset(
            'assets/images/bka_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        // ---------------------------------------------

        title: const Text(
          'Bakım Analizatörü',
          style: TextStyle(
            color: AppTheme.primaryNavy,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppTheme.primaryNavy, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
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
              _buildEducationalCard(context),

              const SizedBox(height: 30),

              Text(
                'Son Analizler',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22, color: AppTheme.primaryNavy),
              ),
              const SizedBox(height: 15),

              _buildRecentScansList(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

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
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 16, color: AppTheme.primaryNavy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScansList() {
    final List<Map<String, dynamic>> recentScans = [
      {"name": "Nemlendirici Yüz Kremi", "score": 85, "risk": "Düşük"},
      {"name": "Güneş Kremi 50+ SPF", "score": 40, "risk": "Yüksek"},
      {"name": "C Vitamini Serumu", "score": 95, "risk": "Temiz"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentScans.length,
      itemBuilder: (context, index) {
        final item = recentScans[index];
        final bool isHighRisk = item["risk"] == "Yüksek";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: isHighRisk
                  ? AppTheme.warningOrange.withOpacity(0.15)
                  : AppTheme.secondaryGreen.withOpacity(0.15),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    productName: item["name"],
                    score: item["score"],
                    riskLevel: item["risk"],
                    // Aşağıdaki veriler şimdilik test amaçlıdır, backend'den gelecek
                    safeIngredients: const ['Gül Suyu', 'Aloe Vera Özü', 'Gliserin'],
                    riskyIngredients: isHighRisk ? const ['Paraben', 'Suni Parfüm'] : const [],
                    alternativeSuggestion: isHighRisk
                        ? 'Bu ürün yerine evde 1 çay bardağı doğal gül suyu ve 2 damla çay ağacı yağını karıştırarak kendi toniğinizi yapabilirsiniz.'
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}