import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryNavy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Üst kısımdaki gereksiz boşluğu aldık (vertical: 0)
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- LOGO ALANI ---
                  Image.asset(
                    'assets/images/bka_logo.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),

                  // LOGO İLE İÇERİK ARASINDAKİ BOŞLUĞU OPTİMİZE ETTİK (24'ten 12'ye düştü)
                  const SizedBox(height: 12),

                  Text(
                    'Hesap Oluştur',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, color: AppTheme.primaryNavy),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sana özel risk analizi yapabilmemiz için profili doldur.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  _buildTextField('Ad Soyad', Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildTextField('E-posta', Icons.email_outlined, isEmail: true),
                  const SizedBox(height: 16),
                  _buildTextField('Şifre', Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 16),

                  // Yaş ve Cinsiyet
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Yaş', Icons.calendar_today, isNumber: true)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Cinsiyet',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: AppTheme.secondaryGreen, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          value: _selectedGender,
                          items: ['Kadın', 'Erkek', 'Diğer'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() { _selectedGender = newValue; });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Alerji Bilgisi
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Bilinen Alerjileriniz (Opsiyonel)',
                      hintText: 'Örn: Paraben, Sülfat, Fındık yağı...',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppTheme.secondaryGreen, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Kayıt Ol ve Başla', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Text alanlarını çizen yardımcı fonksiyon
  Widget _buildTextField(String label, IconData icon, {bool isPassword = false, bool isEmail = false, bool isNumber = false}) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.number : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryNavy),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.secondaryGreen, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) => value!.isEmpty ? '$label boş bırakılamaz' : null,
    );
  }
}