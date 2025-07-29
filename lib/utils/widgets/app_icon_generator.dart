import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class AppIconGenerator {
  static Future<void> generateSIcon() async {
    // Custom painter ile S ikonu oluştur
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = const Size(512, 512);
    
    // Siyah background
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(80),
      ),
      backgroundPaint,
    );
    
    // S harfi çiz
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'S',
        style: TextStyle(
          fontSize: 300,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFF5C842), // SinFlix sarısı
          shadows: [
            Shadow(
              color: Colors.black,
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // S'yi ortala
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    
    textPainter.paint(canvas, Offset(xCenter, yCenter));
    
    // Picture'ı image'a çevir
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();
    
    // Dosyaya kaydet
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sinflix_s_icon.png');
    await file.writeAsBytes(uint8List);
    
    print('✅ S Icon generated: ${file.path}');
  }
}

// Widget olarak da kullanabilmek için
class SinFlixIconWidget extends StatelessWidget {
  final double size;
  
  const SinFlixIconWidget({super.key, this.size = 100});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(size * 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'S',
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF5C842),
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(size * 0.01, size * 0.01),
                blurRadius: size * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 