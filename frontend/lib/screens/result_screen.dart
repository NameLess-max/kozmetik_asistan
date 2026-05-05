import 'package:flutter/material.dart';
import '../theme.dart';

class ResultScreen extends StatelessWidget {
  // Gerçek senaryoda bu veriler FastAPI (Gemini) üzerinden gelecek
  final String productName;
  final int score;
  final String riskLevel;
  final List<String> safeIngredients;
  final List<String> riskyIngredients;
  final String? alternativeSuggestion;

  const ResultScreen({
    Key? key,
    required this.productName,
    required this.score,
    required this.riskLevel,
    required this.safeIngredients,
    required this.riskyIngredients,
    this.alternativeSuggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Risk seviyesine göre ana renk belirleme
    Color mainColor = AppTheme.secondaryGreen;
    IconData statusIcon = Icons.check_circle;

    if (riskLevel == 'Yüksek' || riskLevel == 'Alerjenik') {
      mainColor = AppTheme.warningOrange; // Veya projende tanımlı kırmızımsı bir renk
      statusIcon = Icons.warning_rounded;
    } else if (riskLevel == 'Orta') {
      mainColor = Colors.orangeAccent;
      statusIcon = Icons.info_outline;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Analiz Sonucu'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryNavy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Üst Kısım: Genel Skor ve Durum
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(statusIcon, size: 80, color: mainColor),
                  const SizedBox(height: 16),
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24, color: AppTheme.primaryNavy),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'F/P Kalite Skoru: ',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                      Text(
                        '$score/100',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: mainColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Risk Seviyesi: $riskLevel',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Riskli İçerikler Listesi
                  if (riskyIngredients.isNotEmpty) ...[
                    _buildSectionTitle('Dikkat Edilmesi Gerekenler', Icons.warning_amber_rounded, AppTheme.warningOrange),
                    const SizedBox(height: 12),
                    ...riskyIngredients.map((ingredient) => _buildIngredientTile(ingredient, false)).toList(),
                    const SizedBox(height: 24),
                  ],

                  // 3. Güvenli İçerikler Listesi
                  if (safeIngredients.isNotEmpty) ...[
                    _buildSectionTitle('Güvenli Bileşenler', Icons.check_circle_outline, AppTheme.secondaryGreen),
                    const SizedBox(height: 12),
                    ...safeIngredients.map((ingredient) => _buildIngredientTile(ingredient, true)).toList(),
                    const SizedBox(height: 24),
                  ],

                  // 4. Çözüm Odaklı Yaklaşım (DIY Alternatif)
                  if (alternativeSuggestion != null) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNavy.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primaryNavy.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.eco, color: AppTheme.secondaryGreen),
                              const SizedBox(width: 8),
                              Text(
                                'Doğal Alternatif (DIY)',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 18, color: AppTheme.primaryNavy),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            alternativeSuggestion!,
                            style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // Alt Butonlar
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppTheme.primaryNavy),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Ana Sayfaya Dön', style: TextStyle(color: AppTheme.primaryNavy)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Ürünü favorilere veya "Benim Ürünlerim" listesine ekle
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryNavy,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Başlıklar için yardımcı widget
  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
        ),
      ],
    );
  }

  // İçerik maddeleri için yardımcı widget
  Widget _buildIngredientTile(String name, bool isSafe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSafe ? AppTheme.secondaryGreen.withOpacity(0.3) : AppTheme.warningOrange.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSafe ? Icons.check : Icons.close,
            color: isSafe ? AppTheme.secondaryGreen : AppTheme.warningOrange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}