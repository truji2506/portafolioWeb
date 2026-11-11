import 'package:flutter/material.dart';
import '../data.dart';
import '../shell.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/particulas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final kProyectos = GlobalKey();
  final kSobreMi = GlobalKey();
  final kExperiencia = GlobalKey();
  final kContacto = GlobalKey();

  void _ir(GlobalKey k) {
    final ctx = k.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageShell(
      titulo: 'José Trujillo · Diseñador UI/UX y de experiencias interactivas',
      links: [
        NavLink('Proyectos', () => _ir(kProyectos)),
        NavLink('Sobre mí', () => _ir(kSobreMi)),
        NavLink('Experiencia', () => _ir(kExperiencia)),
        NavLink('Contacto', () => _ir(kContacto)),
      ],
      children: [
        _Hero(onVerProyectos: () => _ir(kProyectos)),
        _Proyectos(anchor: kProyectos),
        _SobreMi(anchor: kSobreMi),
        _Experiencia(anchor: kExperiencia),
        const _Habilidades(),
        _Contacto(anchor: kContacto),
      ],
    );
  }
}

// ── Hero ────────────────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  final VoidCallback onVerProyectos;
  const _Hero({required this.onVerProyectos});

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(Home.titulo, style: PT.display(context)),
      const SizedBox(height: 24),
      Text(Home.intro, style: PT.bodyL()),
      const SizedBox(height: 28),
      Flex(
        direction: movil ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: movil ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
        children: [
          PillButton('Ver proyectos', onTap: onVerProyectos, expand: movil),
          if (Enlaces.cv.isNotEmpty) ...[
            const SizedBox(width: 12, height: 12),
            PillButton('Descargar CV', kind: BtnKind.secondary, onTap: () => abrirUrl(Enlaces.cv), expand: movil),
          ],
        ],
      ),
      const SizedBox(height: 28),
      Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
        Padding(padding: const EdgeInsets.only(right: 4), child: Text('Trabajo con', style: PT.bodyS())),
        for (final h in Home.herramientas) TagChip(h),
      ]),
    ]);

    final t = Home.trabajoReciente;
    final collage = Column(children: [
      _Tile(t[0], aspecto: 480 / 300),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _Tile(t[1], aspecto: 234 / 200)),
        const SizedBox(width: 12),
        Expanded(child: _Tile(t[2], aspecto: 234 / 200)),
      ]),
    ]);

    // Fondo de partículas (three.js) detrás de todo el hero.
    return Stack(children: [
      const Positioned.fill(child: ColoredBox(color: PC.bg)),
      const Positioned.fill(child: FondoParticulas()),
      SectionBox(
        transparente: true,
        top: movil ? 48 : 96,
        child: SplitRow(left: copy, right: collage, rightWidth: PL.isDesktop(context) ? 480 : null, gap: 72, align: CrossAxisAlignment.center),
      ),
    ]);
  }
}

class _Tile extends StatelessWidget {
  final (String, String, String, BoxFit, Color) item;
  final double aspecto;
  const _Tile(this.item, {required this.aspecto});

  @override
  Widget build(BuildContext context) {
    final (asset, caption, slug, ajuste, fondo) = item;
    return Tap(
      onTap: () => Rutas.irACaso(context, slug),
      child: AspectRatio(
        aspectRatio: aspecto,
        child: Stack(children: [
          Positioned.fill(child: RoundedImage(asset, fit: ajuste, fondo: fondo)),
          Positioned(
            left: 12,
            bottom: 12,
            right: 12,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: PC.surface, borderRadius: BorderRadius.circular(PR.sm)),
                child: Text(caption, style: PT.labelM(), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Casos de estudio ────────────────────────────────────────────────────────
class _Proyectos extends StatelessWidget {
  final Key anchor;
  const _Proyectos({required this.anchor});

  @override
  Widget build(BuildContext context) {
    final header = SplitRow(
      left: const SectionHeader(overline: 'Proyectos seleccionados', titulo: 'Casos de estudio'),
      right: Text('Proyectos académicos y retos de diseño, desde la investigación hasta la interfaz final.', style: PT.bodyM()),
      rightWidth: PL.isDesktop(context) ? 440 : null,
      gap: 40,
      align: CrossAxisAlignment.end,
    );
    return SectionBox(
      anchor: anchor,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        header,
        SizedBox(height: PL.block(context)),
        for (var i = 0; i < proyectos.length; i++) ...[
          if (i > 0) SizedBox(height: PL.isMobile(context) ? 20 : 32),
          _ProyectoCard(proyectos[i]),
        ],
      ]),
    );
  }
}

class _ProyectoCard extends StatelessWidget {
  final Proyecto p;
  const _ProyectoCard(this.p);

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    void abrir() => Rutas.irACaso(context, p.slug);

    final imagen = RoundedImage(p.tarjetaImagen, aspecto: 620 / 440, fondo: p.portadaFondo);
    final cuerpo = Padding(
      padding: EdgeInsets.fromLTRB(movil ? 12 : 40, movil ? 22 : 40, movil ? 12 : 40, movil ? 12 : 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Insignia(p.tarjetaBadge, trofeo: p.tarjetaTrofeo),
        const SizedBox(height: 16),
        TagWrap(p.tarjetaEtiquetas),
        const SizedBox(height: 16),
        Text(p.titulo, style: PT.h1(context)),
        const SizedBox(height: 16),
        Text(p.tarjetaResumen, style: PT.bodyL()),
        const SizedBox(height: 20),
        Wrap(spacing: 24, runSpacing: 10, children: [
          ArrowLink('Ver caso de estudio', onTap: abrir),
          if (p.urlWeb != null)
            ArrowLink('Experiencia web', externo: true, onTap: () => abrirUrl(p.urlWeb!)),
        ]),
      ]),
    );

    return HoverCard(
      onTap: abrir,
      child: movil
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [imagen, cuerpo])
          : IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(flex: 52, child: Center(child: imagen)),
                Expanded(flex: 48, child: cuerpo),
              ]),
            ),
    );
  }
}

// ── Sobre mí ────────────────────────────────────────────────────────────────
class _SobreMi extends StatelessWidget {
  final Key anchor;
  const _SobreMi({required this.anchor});

  @override
  Widget build(BuildContext context) {
    final foto = AspectRatio(
      aspectRatio: 440 / 560,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PR.xl),
        child: ColoredBox(
          color: PC.peach,
          child: Image.asset(
            png('retrato'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
      ),
    );
    final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Overline('Sobre mí'),
      const SizedBox(height: 12),
      Text(Home.sobreMiTitulo, style: PT.h1(context)),
      const SizedBox(height: 20),
      Text(Home.sobreMi, style: PT.bodyL()),
      const SizedBox(height: 28),
      Text('Cómo trabajo', style: PT.h4()),
      const SizedBox(height: 12),
      GridRows(
        columnas: 2,
        gap: 24,
        igualAltura: false,
        children: [for (final p in Home.proceso) DividerItem(numero: p.numero, titulo: p.titulo, texto: p.texto)],
      ),
    ]);
    return SectionBox(
      anchor: anchor,
      superficie: true,
      child: SplitRow(
        left: PL.isMobile(context) ? foto : ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: foto),
        right: copy,
        leftWidth: PL.isDesktop(context) ? 440 : null,
        gap: 80,
        align: CrossAxisAlignment.center,
      ),
    );
  }
}

// ── Experiencia ─────────────────────────────────────────────────────────────
class _Experiencia extends StatelessWidget {
  final Key anchor;
  const _Experiencia({required this.anchor});

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    final tarjeta = CardBox(
      radius: PR.xl,
      padding: EdgeInsets.all(movil ? 24 : 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: movil ? 64 : 80,
            height: movil ? 64 : 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: PC.bg, borderRadius: BorderRadius.circular(PR.md)),
            child: Image.asset(png('logo_crediexcel'), fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox()),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(Home.empresa, style: movil ? PT.h2(context) : PT.h3()),
              const SizedBox(height: 4),
              Text(Home.empresaRol, style: PT.bodyS()),
            ]),
          ),
        ]),
        const SizedBox(height: 24),
        Text(Home.empresaTexto, style: PT.bodyL()),
        const SizedBox(height: 24),
        GridRows(
          columnas: 2,
          gap: 24,
          igualAltura: false,
          children: [for (final a in Home.empresaAreas) DividerItem(titulo: a.titulo, texto: a.texto)],
        ),
        const SizedBox(height: 16),
        TagWrap(Home.empresaEtiquetas),
      ]),
    );
    return SectionBox(
      anchor: anchor,
      child: SplitRow(
        left: const SectionHeader(overline: 'Experiencia', titulo: Home.experienciaTitulo),
        right: tarjeta,
        leftWidth: PL.isDesktop(context) ? 380 : null,
        gap: 80,
      ),
    );
  }
}

// ── Habilidades ─────────────────────────────────────────────────────────────
class _Habilidades extends StatelessWidget {
  const _Habilidades();

  @override
  Widget build(BuildContext context) {
    final grupos = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var i = 0; i < Home.habilidades.length; i++) ...[
        if (i > 0) const SizedBox(height: 32),
        Text(Home.habilidades[i].$1, style: PT.labelL()),
        const SizedBox(height: 14),
        Wrap(spacing: 10, runSpacing: 10, children: [for (final h in Home.habilidades[i].$2) TagChip(h)]),
      ],
    ]);
    return SectionBox(
      child: SplitRow(
        left: const SectionHeader(overline: 'Habilidades', titulo: 'Lo que aporto a tu equipo'),
        right: grupos,
        leftWidth: PL.isDesktop(context) ? 380 : null,
        gap: 80,
      ),
    );
  }
}

// ── Contacto ────────────────────────────────────────────────────────────────
class _Contacto extends StatelessWidget {
  final Key anchor;
  const _Contacto({required this.anchor});

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    return SectionBox(
      anchor: anchor,
      top: 0,
      child: CardBox(
        radius: PR.xl,
        padding: EdgeInsets.symmetric(horizontal: movil ? 24 : 80, vertical: movil ? 48 : 88),
        child: Column(children: [
          const Overline('Contacto'),
          const SizedBox(height: 20),
          Text('¿Hablamos?', style: PT.display(context), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(Home.contactoTexto, style: PT.bodyL(), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 28),
          Flex(
            direction: movil ? Axis.vertical : Axis.horizontal,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: movil ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
            children: [
              PillButton('Escríbeme', onTap: () => abrirUrl(Enlaces.email), expand: movil),
              if (Enlaces.linkedin.isNotEmpty) ...[
                const SizedBox(width: 12, height: 12),
                PillButton('Ver LinkedIn', kind: BtnKind.secondary, onTap: () => abrirUrl(Enlaces.linkedin), expand: movil),
              ],
            ],
          ),
          const SizedBox(height: 20),
          Tap(onTap: () => abrirUrl(Enlaces.email), child: Text(Enlaces.email, style: PT.labelL(color: PC.muted))),
        ]),
      ),
    );
  }
}
