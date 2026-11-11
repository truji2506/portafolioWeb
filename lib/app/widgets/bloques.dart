import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import 'common.dart';

/// Dibuja cualquier bloque de contenido de un caso de estudio.
class BloqueView extends StatelessWidget {
  final Bloque bloque;
  final bool enSuperficie; // la sección tiene fondo blanco
  const BloqueView(this.bloque, {super.key, this.enSuperficie = false});

  @override
  Widget build(BuildContext context) {
    return switch (bloque) {
      BloqueReto b => _Reto(b),
      BloqueTarjetas b => _Tarjetas(b, enSuperficie: enSuperficie),
      BloqueStats b => _Stats(b, enSuperficie: enSuperficie),
      BloqueDestacado b => _Destacado(b),
      BloqueImagenes b => _Imagenes(b),
      BloqueEtiquetas b => _Etiquetas(b),
      BloqueBarras b => _Barras(b),
      BloquePersona b => _Persona(b, enSuperficie: enSuperficie),
      BloqueMedia b => _Media(b),
      BloqueInstalaciones b => _Instalaciones(b),
      BloqueReconocimiento b => _Reconocimiento(b),
      BloqueCierre b => _Cierre(b),
      BloqueEstilo b => _Estilo(b, enSuperficie: enSuperficie),
    };
  }
}

// ── El reto + KPI ────────────────────────────────────────────────────────────
class _Reto extends StatelessWidget {
  final BloqueReto b;
  const _Reto(this.b);

  @override
  Widget build(BuildContext context) {
    final izq = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var i = 0; i < b.partes.length; i++) ...[
        if (i > 0) SizedBox(height: PL.isMobile(context) ? 32 : 44),
        Overline(b.partes[i].titulo),
        const SizedBox(height: 12),
        Text(b.partes[i].etiqueta ?? '', style: PT.h2(context)),
        const SizedBox(height: 12),
        Text(b.partes[i].texto, style: PT.bodyL()),
      ],
    ]);
    final k = b.kpi;
    final kpi = CardBox(
      radius: PR.xl,
      padding: EdgeInsets.all(PL.isMobile(context) ? 24 : 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (k.trofeo) ...[const Icon(Icons.emoji_events_outlined, size: 48, color: PC.primary), const SizedBox(height: 12)],
        Text(k.valor, style: k.trofeo ? PT.h1(context, color: PC.primary) : PT.kpi(context)),
        const SizedBox(height: 12),
        Text(k.titulo, style: PT.h4()),
        const SizedBox(height: 8),
        Text(k.nota, style: PT.bodyS()),
      ]),
    );
    return SplitRow(left: izq, right: kpi, rightWidth: 400, gap: 72, align: CrossAxisAlignment.center);
  }
}

// ── Tarjetas ────────────────────────────────────────────────────────────────
class _Tarjetas extends StatelessWidget {
  final BloqueTarjetas b;
  final bool enSuperficie;
  const _Tarjetas(this.b, {required this.enSuperficie});

  @override
  Widget build(BuildContext context) {
    return GridRows(
      columnas: b.columnas,
      gap: b.estilo == EstiloTarjeta.divisor ? 24 : 16,
      igualAltura: b.estilo != EstiloTarjeta.divisor,
      children: [for (final it in b.items) _tarjeta(context, it)],
    );
  }

  Widget _tarjeta(BuildContext context, Item it) {
    final pad = EdgeInsets.all(PL.isMobile(context) ? 22 : 28);
    final titulo = it.titulo.isEmpty ? null : Text(it.titulo, style: PT.h4());
    switch (b.estilo) {
      case EstiloTarjeta.divisor:
        return DividerItem(numero: it.numero, titulo: it.titulo, texto: it.texto);

      case EstiloTarjeta.plano:
        return CardBox(
          color: enSuperficie ? PC.bg : PC.surface,
          borde: !enSuperficie,
          padding: pad,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (it.color != null) ...[
              Container(width: 36, height: 8, decoration: BoxDecoration(color: it.color, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 16),
            ],
            if (it.numero != null) ...[Text(it.numero!, style: PT.h2(context, color: PC.primary)), const SizedBox(height: 8)],
            if (titulo != null) ...[titulo, const SizedBox(height: 8)],
            Text(it.texto, style: PT.bodyM(color: it.titulo.isEmpty ? PC.ink : PC.muted)),
          ]),
        );

      case EstiloTarjeta.numerada:
        return CardBox(
          padding: pad,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: it.color ?? PC.primarySoft, borderRadius: BorderRadius.circular(PR.md)),
                child: Text(it.numero ?? '', style: PT.h4(color: PC.primary).copyWith(fontWeight: FontWeight.w800)),
              ),
              if (it.etiqueta != null) ...[const SizedBox(width: 12), Expanded(child: Text(it.titulo, style: PT.h4()))],
            ]),
            const SizedBox(height: 16),
            if (it.etiqueta == null && titulo != null) ...[Text(it.titulo, style: PT.h3()), const SizedBox(height: 8)],
            Text(it.texto, style: PT.bodyM()),
            if (it.etiqueta != null) ...[const SizedBox(height: 14), TagChip(it.etiqueta!)],
          ]),
        );

      case EstiloTarjeta.punto:
        return CardBox(
          padding: EdgeInsets.all(PL.isMobile(context) ? 20 : 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(color: it.color ?? PC.primarySoft, shape: BoxShape.circle)),
            const SizedBox(height: 14),
            if (titulo != null) ...[titulo, const SizedBox(height: 6)],
            Text(it.texto, style: PT.bodyS()),
          ]),
        );

      case EstiloTarjeta.borde:
        return CardBox(
          padding: pad,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (it.numero != null) ...[Overline(it.numero!, color: PC.primary), const SizedBox(height: 10)],
            if (titulo != null) ...[titulo, const SizedBox(height: 8)],
            Text(it.texto, style: PT.bodyS()),
            if (it.etiqueta != null) ...[const SizedBox(height: 12), TagChip(it.etiqueta!)],
          ]),
        );
    }
  }
}

// ── Estadísticas ────────────────────────────────────────────────────────────
class _Stats extends StatelessWidget {
  final BloqueStats b;
  final bool enSuperficie;
  const _Stats(this.b, {required this.enSuperficie});

  @override
  Widget build(BuildContext context) {
    return GridRows(columnas: 3, children: [
      for (var i = 0; i < b.stats.length; i++)
        CardBox(
          color: enSuperficie ? PC.bg : PC.surface,
          borde: !enSuperficie,
          padding: EdgeInsets.all(PL.isMobile(context) ? 22 : 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(b.stats[i].titulo, style: PT.h1(context, color: i.isEven ? PC.primary : PC.ink)),
            const SizedBox(height: 8),
            Text(b.stats[i].texto, style: PT.bodyM()),
          ]),
        ),
    ]);
  }
}

// ── Insight / problema central ──────────────────────────────────────────────
class _Destacado extends StatelessWidget {
  final BloqueDestacado b;
  const _Destacado(this.b);

  @override
  Widget build(BuildContext context) {
    return CardBox(
      color: PC.primarySoft,
      borde: false,
      radius: PR.xl,
      padding: EdgeInsets.all(PL.isMobile(context) ? 24 : 36),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Overline(b.overline, color: PC.primary),
        const SizedBox(height: 10),
        Text(b.texto, style: b.cita ? PT.quote(context) : PT.h3()),
      ]),
    );
  }
}

// ── Imágenes con título y descripción ───────────────────────────────────────
class _Imagenes extends StatelessWidget {
  final BloqueImagenes b;
  const _Imagenes(this.b);

  @override
  Widget build(BuildContext context) {
    final telefono = b.aspecto < 1; // pantallas verticales de app
    return GridRows(
      columnas: b.columnas,
      columnasMovil: telefono ? 2 : 1,
      gap: 24,
      igualAltura: false,
      children: [
        for (final it in b.items)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (telefono)
              AspectRatio(
                aspectRatio: 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(PR.lg),
                  child: ColoredBox(
                    color: b.fondo ?? PC.lilac,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Image.asset(it.asset,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, __, ___) => const SizedBox()),
                    ),
                  ),
                ),
              )
            else
              RoundedImage(it.asset, aspecto: b.aspecto, fit: b.ajuste, fondo: b.fondo ?? PC.lilac),
            if (it.titulo.isNotEmpty) ...[const SizedBox(height: 14), Text(it.titulo, style: PT.h4())],
            if (it.texto.isNotEmpty) ...[const SizedBox(height: 6), Text(it.texto, style: PT.bodyS())],
          ]),
      ],
    );
  }
}

// ── Etiquetas con título ────────────────────────────────────────────────────
class _Etiquetas extends StatelessWidget {
  final BloqueEtiquetas b;
  const _Etiquetas(this.b);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(b.titulo, style: PT.labelL()),
      const SizedBox(height: 12),
      TagWrap(b.etiquetas),
    ]);
  }
}

// ── Matriz de priorización (barras) ─────────────────────────────────────────
class _Barras extends StatelessWidget {
  final BloqueBarras b;
  const _Barras(this.b);

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CardBox(
        radius: PR.xl,
        padding: EdgeInsets.all(movil ? 24 : 40),
        child: Column(children: [
          for (var i = 0; i < b.barras.length; i++) ...[
            if (i > 0) SizedBox(height: movil ? 22 : 26),
            _barra(context, b.barras[i], movil),
          ],
        ]),
      ),
      const SizedBox(height: 20),
      Text(b.nota, style: PT.bodyM()),
    ]);
  }

  Widget _barra(BuildContext context, Item it, bool movil) {
    final valor = double.tryParse(it.numero ?? '0') ?? 0;
    final etiqueta = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(it.titulo, style: PT.h4()),
      Text(it.texto, style: PT.bodyS()),
    ]);
    final barra = Row(children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PR.sm),
          child: Stack(children: [
            Container(height: 16, color: PC.bg),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (valor / 5).clamp(0.0, 1.0).toDouble(),
              child: Container(height: 16, decoration: BoxDecoration(color: PC.primary, borderRadius: BorderRadius.circular(PR.sm))),
            ),
          ]),
        ),
      ),
      const SizedBox(width: 12),
      Text(it.numero ?? '', style: PT.h4(color: PC.primary).copyWith(fontWeight: FontWeight.w800)),
    ]);
    if (movil) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [etiqueta, const SizedBox(height: 8), barra]);
    return Row(children: [SizedBox(width: 276, child: etiqueta), const SizedBox(width: 24), Expanded(child: barra)]);
  }
}

// ── User persona ────────────────────────────────────────────────────────────
class _Persona extends StatelessWidget {
  final BloquePersona b;
  final bool enSuperficie;
  const _Persona(this.b, {required this.enSuperficie});

  @override
  Widget build(BuildContext context) {
    final izq = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 96,
        height: 96,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: PC.sky, shape: BoxShape.circle),
        child: Text(b.iniciales, style: PT.h2(context, color: PC.primary)),
      ),
      const SizedBox(height: 16),
      Text(b.nombre, style: PT.h3()),
      const SizedBox(height: 6),
      Text(b.descripcion, style: PT.bodyM()),
      const SizedBox(height: 16),
      Text(b.cita, style: PT.quote(context).copyWith(fontSize: 17)),
    ]);
    final der = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var i = 0; i < b.listas.length; i++) ...[
        if (i > 0) const SizedBox(height: 22),
        Text(b.listas[i].$1, style: PT.h4()),
        const SizedBox(height: 10),
        for (final t in b.listas[i].$2)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 9, right: 10),
                decoration: const BoxDecoration(color: PC.primary, shape: BoxShape.circle),
              ),
              Expanded(child: Text(t, style: PT.bodyM())),
            ]),
          ),
      ],
    ]);
    return CardBox(
      color: enSuperficie ? PC.bg : PC.surface,
      borde: !enSuperficie,
      radius: PR.xl,
      padding: EdgeInsets.all(PL.isMobile(context) ? 24 : 40),
      child: SplitRow(left: izq, right: der, leftWidth: 320, gap: 48),
    );
  }
}

// ── Texto + imagen vertical (registro en video) ─────────────────────────────
class _Media extends StatelessWidget {
  final BloqueMedia b;
  const _Media(this.b);

  @override
  Widget build(BuildContext context) {
    final items = Column(children: [
      for (final it in b.items) DividerItem(titulo: it.titulo, texto: it.texto),
    ]);
    final imagen = DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(PR.xl), boxShadow: PS.md),
      child: b.video != null
          ? VideoLoop(b.video!, poster: b.asset, aspecto: b.aspecto, radius: PR.xl)
          : RoundedImage(b.asset, aspecto: b.aspecto, radius: PR.xl, fondo: PC.ink),
    );
    return SplitRow(left: items, right: imagen, rightWidth: 360, gap: 96, align: CrossAxisAlignment.center);
  }
}

// ── Instalaciones interactivas ──────────────────────────────────────────────
class _Instalaciones extends StatelessWidget {
  final BloqueInstalaciones b;
  const _Instalaciones(this.b);

  @override
  Widget build(BuildContext context) {
    return GridRows(columnas: 2, gap: 24, children: [
      for (final ins in b.instalaciones)
        CardBox(
          radius: PR.xl,
          padding: EdgeInsets.all(PL.isMobile(context) ? 20 : 28),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RoundedImage(ins.asset, aspecto: 530 / 300),
            const SizedBox(height: 18),
            Text(ins.titulo, style: PT.h2(context)),
            const SizedBox(height: 10),
            Text(ins.texto, style: PT.bodyM()),
            const SizedBox(height: 18),
            for (var i = 0; i < ins.pasos.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: PC.primarySoft, shape: BoxShape.circle),
                    child: Text('${i + 1}', style: PT.labelM(color: PC.primary).copyWith(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(ins.pasos[i].titulo, style: PT.labelL()),
                      const SizedBox(height: 2),
                      Text(ins.pasos[i].texto, style: PT.bodyS()),
                    ]),
                  ),
                ]),
              ),
          ]),
        ),
    ]);
  }
}

// ── Banda de reconocimiento ─────────────────────────────────────────────────
class _Reconocimiento extends StatelessWidget {
  final BloqueReconocimiento b;
  const _Reconocimiento(this.b);

  @override
  Widget build(BuildContext context) {
    final texto = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.emoji_events_outlined, size: 40, color: PC.primary),
      const SizedBox(height: 12),
      const Overline('Reconocimiento'),
      const SizedBox(height: 12),
      Text(b.titulo, style: PT.h1(context)),
      const SizedBox(height: 12),
      Text(b.texto, style: PT.bodyL()),
    ]);
    return CardBox(
      color: PC.primarySoft,
      borde: false,
      radius: PR.xl,
      padding: EdgeInsets.all(PL.isMobile(context) ? 24 : 56),
      child: SplitRow(
        left: RoundedImage(b.asset, aspecto: 520 / 340, fondo: PC.surface, fit: BoxFit.contain),
        right: texto,
        leftWidth: PL.isDesktop(context) ? 520 : null,
        gap: 56,
        align: CrossAxisAlignment.center,
      ),
    );
  }
}

// ── Resultados + aprendizajes ───────────────────────────────────────────────
class _Cierre extends StatelessWidget {
  final BloqueCierre b;
  const _Cierre(this.b);

  @override
  Widget build(BuildContext context) {
    final izq = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(overline: b.overlineIzq, titulo: b.tituloIzq),
      const SizedBox(height: 24),
      for (final l in b.logros) Padding(padding: const EdgeInsets.only(bottom: 16), child: CheckItem(l)),
    ]);
    final der = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(overline: 'Aprendizajes', titulo: 'Qué me llevo'),
      const SizedBox(height: 24),
      CardBox(
        radius: PR.xl,
        padding: EdgeInsets.all(PL.isMobile(context) ? 24 : 32),
        child: Text(b.cita, style: PT.quote(context)),
      ),
      if (b.etiquetas.isNotEmpty) ...[
        const SizedBox(height: 24),
        if (b.etiquetasTitulo != null) ...[Text(b.etiquetasTitulo!, style: PT.labelL()), const SizedBox(height: 12)],
        TagWrap(b.etiquetas),
      ],
    ]);
    return SplitRow(left: izq, right: der, gap: 80);
  }
}

// ── Style guide del proyecto ────────────────────────────────────────────────
class _Estilo extends StatelessWidget {
  final BloqueEstilo b;
  final bool enSuperficie;
  const _Estilo(this.b, {required this.enSuperficie});

  @override
  Widget build(BuildContext context) {
    final movil = PL.isMobile(context);
    return CardBox(
      color: enSuperficie ? PC.bg : PC.surface,
      borde: !enSuperficie,
      padding: EdgeInsets.all(movil ? 22 : 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Style guide', style: PT.h4()),
        const SizedBox(height: 6),
        Text(b.nota, style: PT.bodyS()),
        const SizedBox(height: 18),
        Wrap(spacing: 14, runSpacing: 14, children: [
          for (final (nombre, hex) in b.colores)
            SizedBox(
              width: movil ? 92 : 136,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: movil ? 56 : 80,
                  decoration: BoxDecoration(
                    color: Color(int.parse('FF${hex.substring(1)}', radix: 16)),
                    borderRadius: BorderRadius.circular(PR.md),
                    border: Border.all(color: PC.line),
                  ),
                ),
                const SizedBox(height: 6),
                Text(nombre, style: PT.labelM()),
                Text(hex, style: PT.caption()),
              ]),
            ),
        ]),
      ]),
    );
  }
}
