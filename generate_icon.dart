import 'dart:io';
import 'package:image/image.dart';

void main() {
  const size = 1024;
  final image = Image(width: size, height: size);

  // Colores (Format: ABGR in hex for this library, or use getColor)
  final bg = ColorRgba8(0x0F, 0x0F, 0x1A, 0xFF); // #0F0F1A
  final violet = ColorRgba8(0x7C, 0x3A, 0xED, 0xFF); // #7C3AED
  final cyan = ColorRgba8(0x22, 0xD3, 0xEE, 0xFF); // #22D3EE
  
  // 1. Fondo
  fill(image, color: bg);

  // 2. Dibujar la 'T' (TechTrack)
  // Coordenadas
  final centerX = size ~/ 2;
  const barWidth = 200;
  const topBarHeight = 160;
  const stemHeight = 500;
  const borderRadius = 40;

  // Barra Superior (Top Bar)
  final topRectX1 = (centerX - 350).toInt();
  const topRectY1 = 200;
  final topRectX2 = (centerX + 350).toInt();
  final topRectY2 = 200 + topBarHeight;
  
  // Barra Vertical (Stem)
  final stemRectX1 = (centerX - (barWidth / 2)).toInt();
  final stemRectY1 = 200 + topBarHeight;
  final stemRectX2 = (centerX + (barWidth / 2)).toInt();
  final stemRectY2 = 200 + topBarHeight + stemHeight;

  // Dibujar Glow Cyan (Borde exterior)
  const glowSize = 20;
  fillCircle(image, x: centerX, y: 300, radius: 450, color: ColorRgba8(0x7C, 0x3A, 0xED, 0x33)); // Glow suave violeta
  
  // Dibujar la forma principal
  fillRect(image, x1: topRectX1, y1: topRectY1, x2: topRectX2, y2: topRectY2, color: violet, radius: borderRadius);
  fillRect(image, x1: stemRectX1, y1: stemRectY1, x2: stemRectX2, y2: stemRectY2, color: violet, radius: borderRadius);

  // Detalles en Cyan (Tech Lines)
  // Línea en la barra superior
  fillRect(image, x1: topRectX1 + 40, y1: topRectY1 + 60, x2: topRectX1 + 140, y2: topRectY1 + 100, color: cyan, radius: 10);
  // Punto en la base
  fillCircle(image, x: centerX, y: stemRectY2 - 60, radius: 40, color: cyan);

  // Guardar archivo
  final png = encodePng(image);
  final file = File('assets/icon/icon.png');
  file.createSync(recursive: true);
  file.writeAsBytesSync(png);

  print('Icono generado exitosamente en: ${file.path}');
}

// Extensiones simples para dibujar rectángulos redondeados básicos
void fillRect(Image img, {required int x1, required int y1, required int x2, required int y2, required Color color, int radius = 0}) {
  for (int y = y1; y < y2; y++) {
    for (int x = x1; x < x2; x++) {
      bool draw = true;
      if (radius > 0) {
        // Esquinas redondeadas simples
        if (x < x1 + radius && y < y1 + radius && (x - (x1 + radius)) * (x - (x1 + radius)) + (y - (y1 + radius)) * (y - (y1 + radius)) > radius * radius) draw = false;
        else if (x > x2 - radius && y < y1 + radius && (x - (x2 - radius)) * (x - (x2 - radius)) + (y - (y1 + radius)) * (y - (y1 + radius)) > radius * radius) draw = false;
        else if (x < x1 + radius && y > y2 - radius && (x - (x1 + radius)) * (x - (x1 + radius)) + (y - (y2 - radius)) * (y - (y2 - radius)) > radius * radius) draw = false;
        else if (x > x2 - radius && y > y2 - radius && (x - (x2 - radius)) * (x - (x2 - radius)) + (y - (y2 - radius)) * (y - (y2 - radius)) > radius * radius) draw = false;
      }
      if (draw) img.setPixel(x, y, color);
    }
  }
}
