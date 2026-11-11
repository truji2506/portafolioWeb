import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Definida en web/index.html (cola) y en web/particulas.js (three.js).
@JS('iniciarParticulas')
external void _iniciarParticulas(web.HTMLElement el);

/// Fondo de partículas naranjas hecho con three.js.
/// Las partículas se barren al pasar el mouse y vuelven solas a su sitio.
/// No recibe clics: todo lo que está encima sigue funcionando igual.
class FondoParticulas extends StatelessWidget {
  const FondoParticulas({super.key});

  static const _tipo = 'fondo-particulas';
  static bool _registrado = false;

  static void _registrar() {
    if (_registrado) return;
    _registrado = true;
    ui_web.platformViewRegistry.registerViewFactory(_tipo, (int id) {
      final div = web.HTMLDivElement();
      div.style
        ..width = '100%'
        ..height = '100%'
        ..setProperty('pointer-events', 'none');
      _iniciarParticulas(div);
      return div;
    });
  }

  @override
  Widget build(BuildContext context) {
    _registrar();
    return const IgnorePointer(child: HtmlElementView(viewType: _tipo));
  }
}
