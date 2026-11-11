import 'package:flutter/material.dart';
import 'data.dart';
import 'theme.dart';
import 'widgets/common.dart';

/// Rutas de la web: `/` y `/proyectos/<slug>`.
class Rutas {
  static const home = '/';
  static String caso(String slug) => '/proyectos/$slug';

  static void irAlHome(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil(home, (_) => false);

  static void irACaso(BuildContext context, String slug) => Navigator.of(context).pushNamed(caso(slug));
}

/// Enlace del menú del home (ancla a una sección).
class NavLink {
  final String label;
  final VoidCallback onTap;
  const NavLink(this.label, this.onTap);
}

/// Estructura común de cada página: barra superior fija, contenido con scroll y footer.
class PageShell extends StatelessWidget {
  final String titulo;
  final List<Widget> children;
  final List<NavLink> links; // vacío = página de caso (muestra «Volver»)
  final VoidCallback? onHablemos; // botón «Hablemos» (lleva a Contacto)
  final ScrollController? controller;
  const PageShell({super.key, required this.titulo, required this.children, this.links = const [], this.onHablemos, this.controller});

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    return Title(
      title: titulo,
      color: PC.primary,
      child: Scaffold(
        backgroundColor: PC.bg,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(movil ? 72 : 88),
          child: NavBar(links: links, onHablemos: onHablemos),
        ),
        endDrawer: links.isNotEmpty && NavBar.compacta(context) ? _MenuMovil(links: links, onHablemos: onHablemos) : null,
        body: SingleChildScrollView(
          controller: controller,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [...children, const Footer()]),
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  final List<NavLink> links;
  final VoidCallback? onHablemos;
  const NavBar({super.key, this.links = const [], this.onHablemos});

  /// Debajo de 900 px el menú se vuelve hamburguesa para que no se desborde.
  static bool compacta(BuildContext context) => PL.width(context) < 900;

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    final compacta = NavBar.compacta(context);
    final esHome = links.isNotEmpty;
    final g = PL.gutter(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: g),
      decoration: BoxDecoration(
        color: PC.bg.withValues(alpha: .94),
        border: const Border(bottom: BorderSide(color: PC.line)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: PL.content),
          child: Row(children: [
            Tap(
              onTap: () => Rutas.irAlHome(context),
              tooltip: 'Inicio',
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: PC.primary, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(PL.isDesktop(context) && esHome ? 'José Ignacio Trujillo Cano' : 'José Trujillo',
                    style: PT.h3().copyWith(fontWeight: FontWeight.w800, fontSize: movil ? 20 : 22)),
              ]),
            ),
            const Spacer(),
            if (!esHome)
              Tap(
                onTap: () => Rutas.irAlHome(context),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.arrow_back_rounded, size: 18, color: PC.muted),
                  const SizedBox(width: 8),
                  Text(movil ? 'Volver' : 'Volver a proyectos', style: PT.labelL(color: PC.muted)),
                ]),
              )
            else if (compacta)
              Builder(
                builder: (ctx) => Tap(
                  onTap: () => Scaffold.of(ctx).openEndDrawer(),
                  tooltip: 'Menú',
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: PC.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: PC.line),
                    ),
                    child: const Icon(Icons.menu_rounded, size: 20, color: PC.ink),
                  ),
                ),
              )
            else ...[
              for (final l in links)
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: _NavText(l),
                ),
              const SizedBox(width: 40),
              if (onHablemos != null) PillButton('Hablemos', onTap: onHablemos!),
            ],
          ]),
        ),
      ),
    );
  }
}

class _NavText extends StatefulWidget {
  final NavLink link;
  const _NavText(this.link);
  @override
  State<_NavText> createState() => _NavTextState();
}

class _NavTextState extends State<_NavText> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: Tap(
        onTap: widget.link.onTap,
        child: Text(widget.link.label, style: PT.bodyM(color: hover ? PC.ink : PC.muted)),
      ),
    );
  }
}

class _MenuMovil extends StatelessWidget {
  final List<NavLink> links;
  final VoidCallback? onHablemos;
  const _MenuMovil({required this.links, this.onHablemos});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: PC.bg,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Align(
              alignment: Alignment.centerRight,
              child: Tap(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close_rounded, color: PC.ink),
              ),
            ),
            const SizedBox(height: 24),
            for (final l in links)
              Tap(
                onTap: () {
                  Navigator.of(context).pop();
                  l.onTap();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: PC.line))),
                  child: Text(l.label, style: PT.h3()),
                ),
              ),
            if (onHablemos != null) ...[
              const SizedBox(height: 24),
              PillButton('Hablemos', expand: true, onTap: () {
                Navigator.of(context).pop();
                onHablemos!();
              }),
            ],
          ]),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    final g = PL.gutter(context);
    final redes = [
      ('LinkedIn', Enlaces.linkedin),
      ('Behance', Enlaces.behance),
      ('Dribbble', Enlaces.dribbble),
    ].where((r) => r.$2.isNotEmpty).toList();
    final copy = Text('© 2026 José Trujillo · Diseñador UI/UX', style: PT.bodyS());
    final links = Wrap(spacing: 24, runSpacing: 8, children: [
      for (final r in redes) Tap(onTap: () => abrirUrl(r.$2), child: Text(r.$1, style: PT.labelM())),
    ]);
    return Container(
      padding: EdgeInsets.fromLTRB(g, 32, g, movil ? 40 : 32),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: PC.line))),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: PL.content),
          child: movil
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [copy, const SizedBox(height: 12), links])
              : Row(children: [copy, const Spacer(), links]),
        ),
      ),
    );
  }
}
