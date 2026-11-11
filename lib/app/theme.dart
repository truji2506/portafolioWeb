import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tokens de color del sistema de diseño (Figma · Sistema de diseño · 01 Color).
class PC {
  static const bg = Color(0xFFF8F7F4);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF15171C);
  static const muted = Color(0xFF5E6573);
  static const line = Color(0xFFE7E5DF);
  static const primary = Color(0xFFE8620F);
  static const primarySoft = Color(0xFFFFF0E4);
  static const mint = Color(0xFFE4F3EC);
  static const peach = Color(0xFFFDF3DA);
  static const lilac = Color(0xFFEFEBFB);
  static const sky = Color(0xFFE6EFFA);
  static const success = Color(0xFF2F9E6B);
  static const night = Color(0xFF0B1230);
}

/// Radios (colección «Layout Tokens» · radius/*).
class PR {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 999.0;
}

/// Puntos de quiebre y medidas de layout (grilla del sistema).
class PL {
  static const mobile = 720.0;
  static const desktop = 1100.0;
  static const content = 1200.0;

  static double width(BuildContext c) => MediaQuery.sizeOf(c).width;
  static bool isMobile(BuildContext c) => width(c) < mobile;
  static bool isDesktop(BuildContext c) => width(c) >= desktop;

  /// Margen lateral: 20 en móvil, 40 en tablet y lo necesario para centrar 1200 en desktop.
  static double gutter(BuildContext c) {
    final w = width(c);
    if (w < mobile) return 20;
    if (w < desktop) return 40;
    final g = (w - content) / 2;
    return g < 64 ? 64 : g;
  }

  /// Espacio vertical entre secciones: 64 móvil · 112 desktop.
  static double section(BuildContext c) => isMobile(c) ? 64 : 112;

  /// Separación entre bloques dentro de una sección: 28 móvil · 48 desktop.
  static double block(BuildContext c) => isMobile(c) ? 28 : 48;
}

/// Estilos de texto (Figma · Sistema de diseño · 02 Tipografía). Nunito en toda la interfaz.
class PT {
  static TextStyle _n(double size, FontWeight w, double height, {double ls = 0, Color color = PC.ink, FontStyle? style}) =>
      GoogleFonts.nunito(
        fontSize: size,
        fontWeight: w,
        height: height,
        letterSpacing: size * ls / 100,
        color: color,
        fontStyle: style,
      );

  static TextStyle display(BuildContext c, {Color color = PC.ink}) => PL.isMobile(c)
      ? _n(44, FontWeight.w800, 1.10, ls: -1.5, color: color)
      : _n(PL.isDesktop(c) ? 72 : 56, FontWeight.w800, 1.08, ls: -2, color: color);

  static TextStyle h1(BuildContext c, {Color color = PC.ink}) =>
      PL.isMobile(c) ? _n(32, FontWeight.w700, 1.18, ls: -1, color: color) : _n(48, FontWeight.w700, 1.15, ls: -1.5, color: color);

  static TextStyle h2(BuildContext c, {Color color = PC.ink}) =>
      PL.isMobile(c) ? _n(26, FontWeight.w700, 1.25, ls: -.5, color: color) : _n(32, FontWeight.w700, 1.25, ls: -1, color: color);

  static TextStyle h3({Color color = PC.ink}) => _n(22, FontWeight.w700, 1.30, ls: -.5, color: color);
  static TextStyle h4({Color color = PC.ink}) => _n(18, FontWeight.w700, 1.35, color: color);
  static TextStyle bodyL({Color color = PC.muted}) => _n(18, FontWeight.w400, 1.65, color: color);
  static TextStyle bodyM({Color color = PC.muted}) => _n(16, FontWeight.w400, 1.60, color: color);
  static TextStyle bodyS({Color color = PC.muted}) => _n(14, FontWeight.w400, 1.55, color: color);
  static TextStyle labelL({Color color = PC.ink}) => _n(15, FontWeight.w700, 1.30, color: color);
  static TextStyle labelM({Color color = PC.ink}) => _n(13, FontWeight.w600, 1.30, color: color);
  static TextStyle overline({Color color = PC.muted}) => _n(12, FontWeight.w700, 1.30, ls: 10, color: color);
  static TextStyle caption({Color color = PC.muted}) => _n(12, FontWeight.w400, 1.40, color: color);
  static TextStyle quote(BuildContext c, {Color color = PC.ink}) =>
      _n(PL.isMobile(c) ? 20 : 24, FontWeight.w700, 1.40, color: color, style: FontStyle.italic);

  /// Número grande de KPI / estadística (Display en color de acento).
  static TextStyle kpi(BuildContext c, {Color color = PC.primary}) =>
      _n(PL.isMobile(c) ? 44 : 64, FontWeight.w800, 1.0, ls: -2, color: color);
}

/// Sombras (Figma · Shadow/sm y Shadow/md).
class PS {
  static const sm = [BoxShadow(color: Color(0x0F15171C), offset: Offset(0, 2), blurRadius: 8)];
  static const md = [BoxShadow(color: Color(0x1A15171C), offset: Offset(0, 12), blurRadius: 32)];
}

ThemeData portfolioTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: PC.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: PC.primary, primary: PC.primary, surface: PC.surface),
    textTheme: GoogleFonts.nunitoTextTheme(),
    splashFactory: NoSplash.splashFactory,
    hoverColor: Colors.transparent,
  );
}
