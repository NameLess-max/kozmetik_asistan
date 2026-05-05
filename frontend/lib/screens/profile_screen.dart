import 'package:flutter/material.dart';
import '../theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- KULLANICI VERİLERİ (Backend'den Gelecek) ---
  String userName = 'Çağla Su';
  String userEmail = 'cagla@example.com';
  String userAge = '21';
  String userGender = 'Kadın';
  String userSkinType = 'Karma';
  String userPreferences = 'Vegan, Doğal İçerik';
  String userAllergies = 'Paraben, Sülfat';

  // Düzenleme formunu alttan açan fonksiyon
  void _showEditProfileSheet() {
    // Text formları için controller'lar
    final TextEditingController nameController = TextEditingController(text: userName);
    final TextEditingController emailController = TextEditingController(text: userEmail);
    final TextEditingController ageController = TextEditingController(text: userAge);
    final TextEditingController preferencesController = TextEditingController(text: userPreferences);
    final TextEditingController allergiesController = TextEditingController(text: userAllergies);

    // Dropdown'lar için geçici değişkenler
    String selectedGender = userGender;
    String selectedSkinType = userSkinType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // StatefulBuilder: BottomSheet içindeki Dropdown'ların anlık değişebilmesini sağlar
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Üstteki sürükleme çubuğu
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        'Profili Düzenle',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22, color: AppTheme.primaryNavy),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // 1. Temel Bilgiler
                      _buildEditField('Ad Soyad', Icons.person_outline, nameController),
                      const SizedBox(height: 16),
                      _buildEditField('E-posta', Icons.email_outlined, emailController, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),

                      // 2. Yaş ve Cinsiyet
                      Row(
                        children: [
                          Expanded(child: _buildEditField('Yaş', Icons.calendar_today, ageController, keyboardType: TextInputType.number)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedGender,
                              decoration: _buildDropdownDecoration('Cinsiyet'),
                              items: ['Kadın', 'Erkek', 'Diğer'].map((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value));
                              }).toList(),
                              onChanged: (newValue) {
                                setModalState(() { selectedGender = newValue!; });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 3. Cilt Tipi
                      DropdownButtonFormField<String>(
                        value: selectedSkinType,
                        decoration: _buildDropdownDecoration('Cilt Tipi'),
                        items: ['Kuru', 'Yağlı', 'Karma', 'Hassas', 'Normal'].map((String value) {
                          return DropdownMenuItem<String>(value: value, child: Text(value));
                        }).toList(),
                        onChanged: (newValue) {
                          setModalState(() { selectedSkinType = newValue!; });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 4. Ürün Tercihleri ve Alerjiler
                      _buildEditField('Ürün Tercihleri', Icons.eco_outlined, preferencesController, hintText: 'Örn: Vegan, Cruelty-Free...'),
                      const SizedBox(height: 16),
                      _buildEditField('Alerjiler', Icons.warning_amber_rounded, allergiesController, maxLines: 2, hintText: 'Örn: Paraben, Fındık Yağı...'),
                      const SizedBox(height: 30),

                      // Kaydet Butonu
                      ElevatedButton(
                        onPressed: () {
                          // Tüm verileri ana State'e kaydedip ekranı güncelliyoruz
                          setState(() {
                            userName = nameController.text;
                            userEmail = emailController.text;
                            userAge = ageController.text;
                            userGender = selectedGender;
                            userSkinType = selectedSkinType;
                            userPreferences = preferencesController.text;
                            userAllergies = allergiesController.text;
                          });

                          // TODO: FastAPI'ye PUT/PATCH isteği atılacak

                          Navigator.pop(context); // Menüyü kapat

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profil bilgileri başarıyla güncellendi!'),
                              backgroundColor: AppTheme.secondaryGreen,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Kaydet', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  // Düzenleme alanları (TextFormField) için yardımcı widget
  Widget _buildEditField(String label, IconData icon, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType, String? hintText}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.primaryNavy),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.secondaryGreen, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Dropdown'lar için ortak tasarım
  InputDecoration _buildDropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppTheme.secondaryGreen, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profilim', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryNavy,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. KULLANICI TEMEL KARTI (Ad, Mail, Yaş, Cinsiyet)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.secondaryGreen.withOpacity(0.15),
                    child: const Icon(Icons.person, size: 40, color: AppTheme.secondaryGreen),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            userName,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)
                        ),
                        const SizedBox(height: 4),
                        Text(userEmail, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        // Yaş ve Cinsiyet Etiketleri
                        Row(
                          children: [
                            _buildSmallTag(Icons.cake, '$userAge Yaş'),
                            const SizedBox(width: 10),
                            _buildSmallTag(Icons.wc, userGender),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primaryNavy),
                    onPressed: _showEditProfileSheet,
                    tooltip: 'Profili Düzenle',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. CİLT VE TERCİH PROFİLİ (Yeni eklendi)
            _buildActionCard(
              context,
              title: 'Cilt & Tercih Profili',
              subtitle: 'Cilt Tipi: $userSkinType\nTercihler: $userPreferences',
              icon: Icons.face_retouching_natural,
              color: AppTheme.secondaryGreen,
              onTap: _showEditProfileSheet,
            ),
            const SizedBox(height: 12),

            // 3. ALERJİ RADARI
            _buildActionCard(
              context,
              title: 'Alerji Radarı',
              subtitle: 'Kayıtlı hassasiyetler: $userAllergies',
              icon: Icons.warning_amber_rounded,
              color: AppTheme.warningOrange,
              onTap: _showEditProfileSheet,
            ),
            const SizedBox(height: 12),

            // 4. TARAMA GEÇMİŞİ
            _buildActionCard(
              context,
              title: 'Tarama Geçmişi',
              subtitle: 'Bugüne kadar 12 ürün incelediniz',
              icon: Icons.history,
              color: AppTheme.primaryNavy,
              onTap: () {
                // Geçmiş sayfasına git
              },
            ),
            const SizedBox(height: 30),

            // ÇIKIŞ YAP BUTONU
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text('Çıkış Yap', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Yaş ve Cinsiyet gibi küçük bilgileri göstermek için rozet tasarımı
  Widget _buildSmallTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primaryNavy),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, color: AppTheme.primaryNavy, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // Listelenen kartların ortak tasarımı (Genişletildi)
  Widget _buildActionCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryNavy)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.3)), // Height eklendi (alt alta yazılar için)
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}