import 'package:flutter_test/flutter_test.dart';
import 'package:portafolio_jose/app/data.dart';

void main() {
  test('El portafolio tiene los 4 casos y la cadena de «Siguiente proyecto» es circular', () {
    expect(proyectos.map((p) => p.slug), ['luz-memorias-eternidad', 'flux', 'vr-herencia', 'safetrip']);
    expect(siguienteDe(proyectos.last).slug, proyectos.first.slug);
  });
}
