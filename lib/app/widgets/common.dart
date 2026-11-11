import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../theme.dart';

/// Abre un enlace externo en una pestaña nueva.
Future<void> abrirUrl(String url) async {
  if (url.isEmpty) return;
  final uri = url.contains('@') && !url.startsWith('http') ? Uri(scheme: 'mailto', path: url) : Uri.parse(url);
  await launchUrl(uri, webOnlyWindowName: '_blank');
}

/// Área clicable con cursor de mano (igual que `Tap` en Asmodeo).
class Tap extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final String? tooltip;
  const Tap({super.key, this.onTap, required this.child, this.tooltip});

  @override
  Widget build(BuildContext context) {
    Widget w = MouseRegion(
      cursor: onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: child),
    );
    if (tooltip != null) w = Tooltip(message: tooltip!, child: w);
    return w;
  }
}

/// Contenedor de sección: ancho máximo de 1200, márgenes responsive y fondo.
class SectionBox extends StatelessWidget {
  final Widget child;
  final bool superficie;
  final bool transparente;
  final double? top, bottom;
  final Key? anchor;
  const SectionBox({super.key, required this.child, this.superficie = false, this.transparente = false, this.top, this.bottom, this.anchor});

  @override
  Widget build(BuildContext context) {
    final g = PL.gutter(context);
    final v = PL.section(context);
    return Container(
      key: anchor,
      width: double.infinity,
      color: transparente ? null : (superficie ? PC.surface : PC.bg),
      padding: EdgeInsets.fromLTRB(g, top ?? v, g, bottom ?? v),
      // Align + SizedBox(infinity) = el contenido siempre ocupa todo el ancho
      // disponible (hasta 1200) y queda alineado a la izquierda de la grilla.
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: PL.content),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}

/// Encabezado de sección: overline + título H1 + intro.
class SectionHeader extends StatelessWidget {
  final String? overline, titulo, intro;
  const SectionHeader({super.key, this.overline, this.titulo, this.intro});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (overline != null) ...[Overline(overline!), const SizedBox(height: 12)],
      if (titulo != null) Text(titulo!, style: PT.h1(context)),
      if (intro != null) ...[
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(intro!, style: PT.bodyL()),
        ),
      ],
    ]);
  }
}

class Overline extends StatelessWidget {
  final String text;
  final Color color;
  const Overline(this.text, {super.key, this.color = PC.muted});

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: PT.overline(color: color));
}

/// Etiqueta (componente «Tag» del Figma).
class TagChip extends StatelessWidget {
  final String label;
  const TagChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: PC.surface,
        borderRadius: BorderRadius.circular(PR.full),
        border: Border.all(color: PC.line),
      ),
      child: Text(label, style: PT.labelM(color: PC.muted)),
    );
  }
}

class TagWrap extends StatelessWidget {
  final List<String> tags;
  const TagWrap(this.tags, {super.key});

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 8, runSpacing: 8, children: [for (final t in tags) TagChip(t)]);
}

/// Badge de reconocimiento o contexto (fondo de acento suave).
class Insignia extends StatelessWidget {
  final String label;
  final bool trofeo;
  const Insignia(this.label, {super.key, this.trofeo = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: PC.primarySoft, borderRadius: BorderRadius.circular(PR.full)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (trofeo) ...[const Icon(Icons.emoji_events_outlined, size: 16, color: PC.primary), const SizedBox(width: 8)],
        Flexible(child: Text(label, style: PT.labelM(color: PC.primary).copyWith(fontWeight: FontWeight.w700))),
      ]),
    );
  }
}

enum BtnKind { primary, secondary }

/// Botón píldora (componente «Button» del Figma: Primary / Secondary).
class PillButton extends StatefulWidget {
  final String label;
  final BtnKind kind;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool expand;
  const PillButton(this.label, {super.key, this.kind = BtnKind.primary, this.onTap, this.icon, this.expand = false});

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final primary = widget.kind == BtnKind.primary;
    final bg = primary ? (hover ? const Color(0xFFD0560B) : PC.primary) : (hover ? PC.bg : PC.surface);
    final fg = primary ? Colors.white : PC.ink;
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: Tap(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: widget.expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(PR.full),
            border: primary ? null : Border.all(color: PC.line),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(widget.label, style: PT.labelL(color: fg)),
            if (widget.icon != null) ...[const SizedBox(width: 8), Icon(widget.icon, size: 16, color: fg)],
          ]),
        ),
      ),
    );
  }
}

/// Enlace de texto con flecha («Ver caso de estudio →», «Experiencia web ↗»).
class ArrowLink extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool externo;
  const ArrowLink(this.label, {super.key, this.onTap, this.externo = false});

  @override
  State<ArrowLink> createState() => _ArrowLinkState();
}

class _ArrowLinkState extends State<ArrowLink> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: Tap(
        onTap: widget.onTap,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.label, style: PT.labelL(color: PC.primary)),
          AnimatedPadding(
            duration: const Duration(milliseconds: 160),
            padding: EdgeInsets.only(left: hover ? 10 : 6),
            child: Icon(widget.externo ? Icons.open_in_new_rounded : Icons.arrow_forward_rounded, size: 18, color: PC.primary),
          ),
        ]),
      ),
    );
  }
}

/// Imagen con esquinas redondeadas. Si el archivo aún no existe en assets/images,
/// muestra un bloque de color en su lugar para que la web nunca se rompa.
class RoundedImage extends StatelessWidget {
  final String asset;
  final double? aspecto;
  final double radius;
  final BoxFit fit;
  final Color fondo;
  final Alignment alignment;
  const RoundedImage(
    this.asset, {
    super.key,
    this.aspecto,
    this.radius = PR.lg,
    this.fit = BoxFit.cover,
    this.fondo = PC.lilac,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_outlined, color: PC.muted, size: 28)),
    );
    final box = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(color: fondo, child: img),
    );
    return aspecto == null ? box : AspectRatio(aspectRatio: aspecto!, child: box);
  }
}

/// Tarjeta que se eleva al pasar el cursor.
class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color color;
  final double radius;
  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
    this.color = PC.surface,
    this.radius = PR.xl,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final active = hover && widget.onTap != null;
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: Tap(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, active ? -4 : 0, 0),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: PC.line),
            boxShadow: active ? PS.md : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Caja con borde y radio del sistema (tarjeta estática).
class CardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final double radius;
  final bool borde;
  const CardBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.color = PC.surface,
    this.radius = PR.lg,
    this.borde = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: borde ? Border.all(color: PC.line) : null,
      ),
      child: child,
    );
  }
}

/// Ítem con divisor superior (pasos del proceso, áreas de experiencia).
class DividerItem extends StatelessWidget {
  final String? numero;
  final String titulo, texto;
  const DividerItem({super.key, this.numero, required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: PC.line))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (numero != null) ...[Overline(numero!), const SizedBox(height: 6)],
        Text(titulo, style: PT.h4()),
        const SizedBox(height: 6),
        Text(texto, style: PT.bodyS()),
      ]),
    );
  }
}

/// Ítem de lista con check verde (resultados).
class CheckItem extends StatelessWidget {
  final String text;
  const CheckItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 26,
        height: 26,
        margin: const EdgeInsets.only(top: 1),
        decoration: const BoxDecoration(color: PC.mint, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, size: 16, color: PC.success),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: PT.bodyM(color: PC.ink))),
    ]);
  }
}

/// Grilla responsive con filas de igual altura.
/// Desktop: [columnas] · Tablet: hasta 2 · Móvil: [columnasMovil].
class GridRows extends StatelessWidget {
  final List<Widget> children;
  final int columnas;
  final int columnasMovil;
  final double gap;
  final bool igualAltura;
  const GridRows({
    super.key,
    required this.children,
    this.columnas = 3,
    this.columnasMovil = 1,
    this.gap = 16,
    this.igualAltura = true,
  });

  @override
  Widget build(BuildContext context) {
    final w = PL.width(context);
    final cols = w < PL.mobile ? columnasMovil : (w < PL.desktop ? (columnas < 2 ? columnas : 2) : columnas);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final cells = <Widget>[];
      for (var j = 0; j < cols; j++) {
        if (j > 0) cells.add(SizedBox(width: gap));
        final k = i + j;
        cells.add(Expanded(child: k < children.length ? children[k] : const SizedBox()));
      }
      final row = Row(crossAxisAlignment: igualAltura ? CrossAxisAlignment.stretch : CrossAxisAlignment.start, children: cells);
      if (rows.isNotEmpty) rows.add(SizedBox(height: gap));
      rows.add(igualAltura ? IntrinsicHeight(child: row) : row);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
  }
}

/// Fila que se vuelve columna en móvil.
class SplitRow extends StatelessWidget {
  final Widget left, right;
  final double? leftWidth, rightWidth;
  final double gap;
  final CrossAxisAlignment align;
  const SplitRow({
    super.key,
    required this.left,
    required this.right,
    this.leftWidth,
    this.rightWidth,
    this.gap = 80,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (PL.isMobile(context)) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [left, const SizedBox(height: 32), right]);
    }
    final g = PL.isDesktop(context) ? gap : gap / 2;
    return Row(crossAxisAlignment: align, children: [
      leftWidth != null ? SizedBox(width: leftWidth, child: left) : Expanded(child: left),
      SizedBox(width: g),
      rightWidth != null ? SizedBox(width: rightWidth, child: right) : Expanded(child: right),
    ]);
  }
}

/// Video en bucle, sin sonido y con reproducción automática (como un GIF).
/// Muestra [poster] mientras carga o si el navegador bloquea el video.
class VideoLoop extends StatefulWidget {
  final String asset, poster;
  final double aspecto;
  final double radius;
  const VideoLoop(this.asset, {super.key, required this.poster, this.aspecto = 9 / 16, this.radius = PR.lg});

  @override
  State<VideoLoop> createState() => _VideoLoopState();
}

class _VideoLoopState extends State<VideoLoop> {
  late final VideoPlayerController _c = VideoPlayerController.asset(widget.asset);
  bool _listo = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    try {
      await _c.initialize();
      // En web el navegador solo permite la reproducción automática si el video está en silencio.
      await _c.setVolume(0);
      await _c.setLooping(true);
      await _c.play();
      if (mounted) setState(() => _listo = true);
    } catch (_) {
      // Si falla, se queda la imagen de portada.
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = _c.value.size;
    return AspectRatio(
      aspectRatio: widget.aspecto,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: ColoredBox(
          color: PC.ink,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset(widget.poster, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()),
            AnimatedOpacity(
              opacity: _listo ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: _listo && size.width > 0
                  ? FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(width: size.width, height: size.height, child: VideoPlayer(_c)),
                    )
                  : const SizedBox(),
            ),
          ]),
        ),
      ),
    );
  }
}
