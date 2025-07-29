import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ImageHelper {
  /// Fotoğrafı belirtilen kalitede sıkıştırır
  /// [quality] 0-100 arası (100 = maksimum kalite, 0 = minimum kalite)
  /// [maxWidth] maksimum genişlik (pixel)
  /// [maxHeight] maksimum yükseklik (pixel)
  static Future<File> compressImage(
    File imageFile, {
    int quality = 85,
    int? maxWidth = 1024,
    int? maxHeight = 1024,
  }) async {
    // Orijinal dosya boyutunu kontrol et
    final originalSize = await imageFile.length();
    print('📷 Orijinal dosya boyutu: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB');

    // API limiti çok düşük - her dosyayı sıkıştır (test için)
    print('🔄 Her dosya sıkıştırılacak (API limiti düşük)');

    // Dosyayı oku
    final bytes = await imageFile.readAsBytes();
    
    // Image package ile decode et
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Fotoğraf okunamadı');
    }

    print('📐 Orijinal boyutlar: ${image.width}x${image.height}');

    // Boyutu yeniden boyutlandır (eğer gerekiyorsa)
    if (maxWidth != null && maxHeight != null) {
      if (image.width > maxWidth || image.height > maxHeight) {
        image = img.copyResize(
          image, 
          width: maxWidth, 
          height: maxHeight,
          maintainAspect: true,
        );
        print('📏 Yeni boyutlar: ${image.width}x${image.height}');
      }
    }

    // JPEG formatında sıkıştır
    final compressedBytes = img.encodeJpg(image, quality: quality);
    
    // Yeni dosya oluştur
    final String dir = path.dirname(imageFile.path);
    final String fileName = path.basenameWithoutExtension(imageFile.path);
    final String extension = '.jpg'; // Her zaman JPEG olarak kaydet
    final String newPath = path.join(dir, '${fileName}_compressed$extension');
    
    final compressedFile = File(newPath);
    await compressedFile.writeAsBytes(compressedBytes);
    
    final compressedSize = await compressedFile.length();
    print('📷 Sıkıştırılmış dosya boyutu: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB');
    print('📊 Sıkıştırma oranı: %${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}');
    
    return compressedFile;
  }

  /// Fotoğrafın boyutunu kontrol eder (MB cinsinden)
  static Future<double> getFileSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  /// Maximum upload boyutunu kontrol eder
  static Future<bool> isFileSizeValid(File file, {double maxSizeMB = 5.0}) async {
    final sizeMB = await getFileSizeInMB(file);
    return sizeMB <= maxSizeMB;
  }
} 