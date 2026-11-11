import 'package:flutter/material.dart';
import '../data.dart';
import '../shell.dart';
import '../theme.dart';
import '../widgets/bloques.dart';
import '../widgets/common.dart';

class CasoScreen extends StatelessWidget {
  final Proyecto p;
  const CasoScreen(this.p, {super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      titulo: '${p.titulo} · José Trujillo',
      children: [
        _Hero(p),
        SectionBox(
          top: 0,
          child: RoundedImage(
            p.portada,
            aspecto: PL.isMobile(context) ? 4 / 3 : 1200 / 620,
            radius: PR.xl,
            fondo: p.portadaFondo,
            fit: p.portadaAjuste,
          ),
        ),
        for (final s in p.secciones) _SeccionView(s),
        _Siguiente(siguienteDe(p)),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final Proyecto p;
  const _Hero(this.p);

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    final meta = movil
        ? GridRows(
            columnas: 2,
            columnasMovil: 2,
            gap: 20,
            igualAltura: false,
            children: [for (final m in p.meta) _MetaItem(m)],
          )
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (var i = 0; i < p.meta.length; i++) ...[
              if (i > 0) const SizedBox(width: 24),
              Expanded(child: _MetaItem(p.meta[i])),
            ],
          ]);
    return SectionBox(
      top: movil ? 40 : 80,
      bottom: movil ? 40 : 64,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (p.insignia != null) ...[Insignia(p.insignia!), const SizedBox(height: 16)],
        TagWrap(p.etiquetas),
        const SizedBox(height: 20),
        Overline(p.overline),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Text(p.titulo, style: PT.display(context)),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Text(p.resumen, style: PT.bodyL()),
        ),
        if (p.urlWeb != null) ...[
          const SizedBox(height: 24),
          PillButton('Ver experiencia web', icon: Icons.open_in_new_rounded, onTap: () => abrirUrl(p.urlWeb!), expand: movil),
        ],
        SizedBox(height: movil ? 28 : 40),
        Container(
          padding: EdgeInsets.only(top: movil ? 20 : 28),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: PC.line))),
          child: meta,
        ),
      ]),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final Meta m;
  const _MetaItem(this.m);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Overline(m.etiqueta),
      const SizedBox(height: 6),
      Text(m.valor, style: PT.h4()),
    ]);
  }
}

class _SeccionView extends StatelessWidget {
  final Seccion s;
  const _SeccionView(this.s);

  @override
  Widget build(BuildContext context) {
    final tieneHeader = s.overline != null || s.titulo != null;
    final gap = PL.block(context);
    return SectionBox(
      superficie: s.superficie,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (tieneHeader) SectionHeader(overline: s.overline, titulo: s.titulo, intro: s.intro),
        for (var i = 0; i < s.bloques.length; i++) ...[
          if (i > 0 || tieneHeader) SizedBox(height: gap),
          BloqueView(s.bloques[i], enSuperficie: s.superficie),
        ],
      ]),
    );
  }
}

class _Siguiente extends StatelessWidget {
  final Proyecto next;
  const _Siguiente(this.next);

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    void abrir() => Navigator.of(context).pushReplacementNamed(Rutas.caso(next.slug));
    final texto = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      const Overline('Siguiente proyecto'),
      const SizedBox(height: 10),
      Text(next.titulo, style: PT.h2(context)),
      const SizedBox(height: 10),
      ArrowLink('Ver caso de estudio', onTap: abrir),
    ]);
    final mini = RoundedImage(next.tarjetaImagen, aspecto: 360 / 200, radius: PR.lg, fondo: next.portadaFondo);
    return SectionBox(
      top: 0,
      child: HoverCard(
        onTap: abrir,
        padding: EdgeInsets.all(movil ? 24 : 40),
        child: movil
            ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [texto, const SizedBox(height: 20), mini])
            : Row(children: [Expanded(child: texto), const SizedBox(width: 40), SizedBox(width: 360, child: mini)]),
      ),
    );
  }
}
