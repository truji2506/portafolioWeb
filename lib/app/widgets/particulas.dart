import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

// Definidas en web/index.html (versiones vacías mientras carga) y en
// web/particulas.js (three.js).
@JS('iniciarParticulas')
external void _iniciar(web.HTMLElement el);
@JS('particulasMover')
external void _mover(web.HTMLElement el, double x, double y);
@JS('particulasSalir')
external void _salir(web.HTMLElement el);

/// Fondo de partículas naranjas (three.js) detrás de [child].
/// Flutter lee el mouse y se lo pasa a las partículas, que se barren en la
/// dirección del movimiento y luego vuelven solas a su sitio.
/// No bloquea clics: todo lo que está en [child] funciona igual.
class FondoParticulas extends StatefulWidget {
  final Widget child;
  final Color fondo;
  const FondoParticulas({super.key, required this.child, required this.fondo});

  static const _tipo = 'fondo-particulas';
  static final _divs = <int, web.HTMLDivElement>{};
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
      _divs[id] = div;
      _iniciar(div);
      return div;
    });
  }

  @override
  State<FondoParticulas> createState() => _FondoParticulasState();
}

class _FondoParticulasState extends State<FondoParticulas> {
  int? _id;

  web.HTMLDivElement? get _div => _id == null ? null : FondoParticulas._divs[_id];

  void _mueve(PointerEvent e) {
    final div = _div;
    if (div != null) _mover(div, e.localPosition.dx, e.localPosition.dy);
  }

  void _sale() {
    final div = _div;
    if (div != null) _salir(div);
  }

  @override
  void dispose() {
    if (_id != null) FondoParticulas._divs.remove(_id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FondoParticulas._registrar();
    return MouseRegion(
      opaque: false,
      onExit: (_) => _sale(),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerHover: _mueve, // mouse
        onPointerMove: _mueve, // dedo o arrastre
        onPointerUp: (e) {
          if (e.kind == PointerDeviceKind.touch) _sale();
        },
        child: Stack(children: [
          Positioned.fill(child: ColoredBox(color: widget.fondo)),
          Positioned.fill(
            child: IgnorePointer(
              child: HtmlElementView(
                viewType: FondoParticulas._tipo,
                onPlatformViewCreated: (id) => _id = id,
              ),
            ),
          ),
          widget.child,
        ]),
      ),
    );
  }
}
