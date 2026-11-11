import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'app/data.dart';
import 'app/screens/caso.dart';
import 'app/screens/home.dart';
import 'app/shell.dart';
import 'app/theme.dart';

void main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de arrancar Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // URLs limpias (/proyectos/flux en lugar de /#/proyectos/flux).
  // Firebase Hosting reescribe todas las rutas a index.html (ver firebase.json).
  usePathUrlStrategy();

  // Inicializa Firebase con las opciones generadas por `flutterfire configure`
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PortafolioApp());
}

class PortafolioApp extends StatelessWidget {
  const PortafolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'José Trujillo · Diseñador UI/UX',
      debugShowCheckedModeBanner: false,
      theme: portfolioTheme(),
      initialRoute: Rutas.home,
      onGenerateInitialRoutes: (name) => [_ruta(RouteSettings(name: name))],
      onGenerateRoute: _ruta,
    );
  }
}

/// `/` → home · `/proyectos/<slug>` → caso de estudio · cualquier otra → home.
Route<void> _ruta(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? Rutas.home);
  final seg = uri.pathSegments;
  Widget page = const HomeScreen();
  if (seg.length == 2 && seg[0] == 'proyectos' && proyectos.any((p) => p.slug == seg[1])) {
    page = CasoScreen(proyectoPorSlug(seg[1]));
  }
  return PageRouteBuilder<void>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
      child: child,
    ),
  );
}
