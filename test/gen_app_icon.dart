// Generador one-off del PNG del ícono de la app a partir del SVG.
// Correr: flutter test test/gen_app_icon.dart
// Produce: assets/icon/app_icon.png (1024x1024) con el logo (cuadro verde) al ~80%.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('genera assets/icon/app_icon.png desde el SVG', (tester) async {
    tester.view.physicalSize = const ui.Size(1024, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final svg = File('assets/icon/login-icon.svg').readAsStringSync();

    // El cuadro verde ocupa ~57% del viewBox 122. Para que quede al ~80% del
    // canvas de 1024, renderizo el SVG a 1024*(0.80/0.57) y lo centro (clip).
    const double svgSize = 1024 * 0.80 / 0.57; // ≈ 1437

    final key = GlobalKey();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RepaintBoundary(
          key: key,
          child: SizedBox(
            width: 1024,
            height: 1024,
            child: ClipRect(
              child: OverflowBox(
                minWidth: 0,
                maxWidth: double.infinity,
                minHeight: 0,
                maxHeight: double.infinity,
                child: SvgPicture.string(
                  svg,
                  width: svgSize,
                  height: svgSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.0);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    Directory('assets/icon').createSync(recursive: true);
    final out = File('assets/icon/app_icon.png');
    out.writeAsBytesSync(bytes!.buffer.asUint8List());
    expect(out.existsSync(), true);
    // ignore: avoid_print
    print('ICONO: ${out.path} ${image.width}x${image.height} ${out.lengthSync()}B');
  });
}
