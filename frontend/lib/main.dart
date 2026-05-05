import 'package:flutter/material.dart';
import 'theme.dart'; // Tema dosyamızı içeri aktarıyoruz
import 'package:camera/camera.dart'; // Kamerayı dahil ettik
import 'screens/onboarding_screen.dart'; // İlk açılacak ekranımızı içeri aktarıyoruz
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

// Sistemdeki kameraları tutacak global değişken
late List<CameraDescription> cameras;

Future<void> main() async {
  // Flutter motorunun donanımla haberleşebilmesi için bu şart:
  WidgetsFlutterBinding.ensureInitialized();

  // Cihazdaki kullanılabilir kameraları alıyoruz
  cameras = await availableCameras();

  runApp(const BakimAnalizoruApp());
}
class BakimAnalizoruApp extends StatelessWidget {
  const BakimAnalizoruApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bakım Analizörü',
      debugShowCheckedModeBanner: false, // Sağ üstteki "DEBUG" yazısını kaldırır

      // ThemeData dosyasında hazırladığımız tasarımı buraya bağlıyoruz
      theme: AppTheme.lightTheme,

      // Uygulama açıldığında ilk hangi sayfa gösterilecek?
      home: const HomeScreen()
      ,
    );
  }
}