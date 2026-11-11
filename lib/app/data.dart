import 'package:flutter/material.dart';
import 'theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enlaces personales. Completa los vacíos: los botones y enlaces sin URL no se
// muestran en la web.
// ─────────────────────────────────────────────────────────────────────────────
class Enlaces {
  static const email = 'josetrujillo631@gmail.com';
  static const cv = ''; // p. ej. 'https://…/cv-jose-trujillo.pdf' o 'assets/cv.pdf'
  static const linkedin = 'https://www.linkedin.com/in/jose-trujillo-24b168424/';
  static const behance = '';
  static const dribbble = '';
}

/// Rutas de las imágenes exportadas desde la página «Assets web» del Figma.
String jpg(String nombre) => 'assets/images/$nombre.jpg';
String png(String nombre) => 'assets/images/$nombre.png';

// ─────────────────────────────────────────────────────────────────────────────
// Modelos
// ─────────────────────────────────────────────────────────────────────────────

class Meta {
  final String etiqueta, valor;
  const Meta(this.etiqueta, this.valor);
}

class Item {
  final String? numero;
  final String titulo;
  final String texto;
  final String? etiqueta;
  final Color? color;
  const Item(this.titulo, this.texto, {this.numero, this.etiqueta, this.color});
}

class Kpi {
  final String valor, titulo, nota;
  final bool trofeo;
  const Kpi(this.valor, this.titulo, this.nota, {this.trofeo = false});
}

class ImagenItem {
  final String asset, titulo, texto;
  const ImagenItem(this.asset, this.titulo, this.texto);
}

class Instalacion {
  final String asset, titulo, texto;
  final List<Item> pasos;
  const Instalacion(this.asset, this.titulo, this.texto, this.pasos);
}

/// Bloques de contenido que componen cada sección de un caso de estudio.
sealed class Bloque {
  const Bloque();
}

/// El problema / el objetivo a la izquierda y una tarjeta de KPI a la derecha.
class BloqueReto extends Bloque {
  final List<Item> partes; // titulo = overline, texto = cuerpo, etiqueta = título H2
  final Kpi kpi;
  const BloqueReto(this.partes, this.kpi);
}

enum EstiloTarjeta { borde, plano, divisor, numerada, punto }

class BloqueTarjetas extends Bloque {
  final List<Item> items;
  final int columnas;
  final EstiloTarjeta estilo;
  const BloqueTarjetas(this.items, {this.columnas = 3, this.estilo = EstiloTarjeta.borde});
}

class BloqueStats extends Bloque {
  final List<Item> stats; // titulo = número, texto = descripción
  const BloqueStats(this.stats);
}

class BloqueDestacado extends Bloque {
  final String overline, texto;
  final bool cita;
  const BloqueDestacado(this.overline, this.texto, {this.cita = false});
}

class BloqueImagenes extends Bloque {
  final List<ImagenItem> items;
  final int columnas;
  final double aspecto; // ancho / alto
  final Color? fondo; // fondo detrás de la imagen (p. ej. pantallas de app)
  final BoxFit ajuste;
  const BloqueImagenes(this.items, {this.columnas = 3, this.aspecto = 16 / 10, this.fondo, this.ajuste = BoxFit.cover});
}

class BloqueEtiquetas extends Bloque {
  final String titulo;
  final List<String> etiquetas;
  const BloqueEtiquetas(this.titulo, this.etiquetas);
}

class BloqueBarras extends Bloque {
  final List<Item> barras; // titulo, texto = subtítulo, numero = valor (0–5)
  final String nota;
  const BloqueBarras(this.barras, this.nota);
}

class BloquePersona extends Bloque {
  final String iniciales, nombre, descripcion, cita;
  final List<(String, List<String>)> listas;
  const BloquePersona({
    required this.iniciales,
    required this.nombre,
    required this.descripcion,
    required this.cita,
    required this.listas,
  });
}

/// Texto con ítems a un lado y una imagen o video (vertical) al otro.
/// [asset] es la imagen de portada; si hay [video], se reproduce en bucle y sin sonido.
class BloqueMedia extends Bloque {
  final List<Item> items;
  final String asset;
  final String? video;
  final double aspecto;
  const BloqueMedia(this.items, this.asset, {this.video, this.aspecto = 9 / 16});
}

class BloqueInstalaciones extends Bloque {
  final List<Instalacion> instalaciones;
  const BloqueInstalaciones(this.instalaciones);
}

class BloqueReconocimiento extends Bloque {
  final String asset, titulo, texto;
  const BloqueReconocimiento(this.asset, this.titulo, this.texto);
}

class BloqueCierre extends Bloque {
  final String overlineIzq, tituloIzq;
  final List<String> logros;
  final String cita;
  final String? etiquetasTitulo;
  final List<String> etiquetas;
  const BloqueCierre({
    this.overlineIzq = 'Resultados',
    this.tituloIzq = 'Qué logramos',
    required this.logros,
    required this.cita,
    this.etiquetasTitulo,
    this.etiquetas = const [],
  });
}

class BloqueEstilo extends Bloque {
  final String nota;
  final List<(String, String)> colores; // (nombre, '#RRGGBB')
  const BloqueEstilo(this.nota, this.colores);
}

class Seccion {
  final String? overline, titulo, intro;
  final bool superficie; // fondo blanco en lugar del fondo cálido
  final List<Bloque> bloques;
  const Seccion({this.overline, this.titulo, this.intro, this.superficie = false, this.bloques = const []});
}

class Proyecto {
  final String slug, titulo, overline, resumen;
  final List<String> etiquetas;
  final String? insignia; // reconocimiento (con trofeo)
  final List<Meta> meta;
  final String portada;
  final Color portadaFondo;
  final BoxFit portadaAjuste;
  final String? urlWeb;
  final List<Seccion> secciones;

  // Tarjeta del home
  final String tarjetaBadge, tarjetaResumen, tarjetaImagen;
  final List<String> tarjetaEtiquetas;
  final bool tarjetaTrofeo;

  const Proyecto({
    required this.slug,
    required this.titulo,
    required this.overline,
    required this.resumen,
    required this.etiquetas,
    this.insignia,
    required this.meta,
    required this.portada,
    this.portadaFondo = PC.lilac,
    this.portadaAjuste = BoxFit.cover,
    this.urlWeb,
    required this.secciones,
    required this.tarjetaBadge,
    required this.tarjetaResumen,
    required this.tarjetaImagen,
    required this.tarjetaEtiquetas,
    this.tarjetaTrofeo = false,
  });
}

Proyecto proyectoPorSlug(String slug) => proyectos.firstWhere((p) => p.slug == slug, orElse: () => proyectos.first);

Proyecto siguienteDe(Proyecto p) {
  final i = proyectos.indexOf(p);
  return proyectos[(i + 1) % proyectos.length];
}

// ─────────────────────────────────────────────────────────────────────────────
// Home
// ─────────────────────────────────────────────────────────────────────────────

class Home {
  static const titulo = 'Diseñador UI/UX y de experiencias interactivas.';
  static const intro =
      'Soy José Trujillo. Estudio Ingeniería en Diseño de Entretenimiento Digital y diseño tanto productos digitales como '
      'instalaciones interactivas: investigo con usuarios, defino flujos, diseño interfaces y prototipo con AR, VR y Unity. '
      'Mi proyecto más reciente ganó Mejor Producto en la Muestra DEX UPB 2026.';
  static const herramientas = ['Figma', 'FigJam', 'Maze', '8th Wall', 'TouchDesigner', 'Unity', 'VR / AR'];
  /// Collage del hero: arriba Luz, abajo Flux y VR Herencia.
  /// (imagen, texto de la etiqueta, slug del caso, ajuste, color de fondo)
  static const trabajoReciente = [
    ('assets/images/hero_luz.jpg', 'Luz, Memorias y Eternidad · Instalación', 'luz-memorias-eternidad', BoxFit.cover, PC.lilac),
    ('assets/images/card_flux.jpg', 'Flux · Web app + AR', 'flux', BoxFit.contain, PC.night),
    ('assets/images/card_vr.jpg', 'VR Herencia · Unity VR', 'vr-herencia', BoxFit.cover, Color(0xFF2A1B12)),
  ];

  static const sobreMiTitulo = 'Entre el diseño de producto y las experiencias inmersivas.';
  static const sobreMi =
      'Estoy terminando Ingeniería en Diseño de Entretenimiento Digital, con énfasis en Experiencias Interactivas. '
      'Trabajo en dos frentes: diseño de producto (investigación, flujos, prototipos y UI) e instalaciones y experiencias '
      'inmersivas con TouchDesigner, 8th Wall y Unity. En ambos casos empiezo igual: hablando con las personas antes de diseñar.';
  static const proceso = [
    Item('Investigar', 'Benchmark, entrevistas y análisis de competidores para entender el problema.', numero: '01'),
    Item('Definir', 'Flujos, arquitectura de información y criterios de éxito medibles.', numero: '02'),
    Item('Diseñar', 'Wireframes, UI de alta fidelidad y sistemas de diseño consistentes.', numero: '03'),
    Item('Validar', 'Pruebas de usabilidad para iterar con evidencia, no con intuición.', numero: '04'),
  ];

  static const experienciaTitulo = 'Seis años del lado del usuario.';
  static const empresa = 'Crediexcel S.A.S.';
  static const empresaRol = 'Rol multidisciplinario · 6 años';
  static const empresaTexto =
      'Empresa de crédito donde he trabajado en varias áreas a la vez. Esa visión completa del negocio, del cliente al back '
      'office, es la que hoy llevo a mis proyectos de diseño.';
  static const empresaAreas = [
    Item('Atención al cliente', 'Escucho a diario dudas y problemas reales de las personas: research en la práctica.'),
    Item('Facturación, cartera y bancos', 'Conozco por dentro los procesos financieros que luego diseño en productos fintech.'),
    Item('Ingeniería de sistemas', 'Soporte y gestión de las herramientas internas de la empresa.'),
    Item('Piezas publicitarias', 'Diseño gráfico para las campañas y la comunicación de la marca.'),
  ];
  static const empresaEtiquetas = ['Atención al cliente', 'Procesos financieros', 'Sistemas', 'Diseño gráfico'];

  static const habilidades = [
    ('Diseño', [
      'UX Research', 'Arquitectura de información', 'Wireframing', 'UI Design', 'Design Systems', 'Prototipado',
      'Pruebas de usabilidad', 'Benchmark competitivo', 'Accesibilidad',
    ]),
    ('Herramientas', ['Figma', 'FigJam', 'Figma Make', 'Maze', '8th Wall', 'TouchDesigner']),
    ('Desarrollo e inmersivos', ['Desarrollador web', 'Unity', 'Experiencias VR', 'Experiencias AR']),
  ];

  static const contactoTexto =
      'Estoy abierto a práctica profesional, proyectos freelance y colaboraciones en diseño UI/UX y experiencias interactivas.';
}

// ─────────────────────────────────────────────────────────────────────────────
// Casos de estudio (mismo orden que el home; «Siguiente proyecto» sigue esta lista)
// ─────────────────────────────────────────────────────────────────────────────

final proyectos = <Proyecto>[_luz, _flux, _vr, _safetrip];

const _luz = Proyecto(
  slug: 'luz-memorias-eternidad',
  titulo: 'Luz, Memorias y Eternidad',
  overline: 'Caso de estudio · Taller 6 · Santa Fe de Antioquia',
  insignia: 'Mejor Producto: Experiencias Interactivas · DEX UPB 2026',
  etiquetas: ['Experiencia interactiva', 'Patrimonio', 'TouchDesigner'],
  resumen:
      'Una experiencia interactiva para el Museo de Arte Religioso de Santa Fe de Antioquia que revela cómo la fe se vive en '
      'comunidad: un patrimonio inmaterial hecho de vínculos, acompañamiento y memoria.',
  urlWeb: 'https://obras-vivas.vercel.app',
  meta: [
    Meta('Rol', 'Diseño de experiencia · UX'),
    Meta('Equipo', '6 integrantes'),
    Meta('Duración', 'Marzo a mayo de 2026'),
    Meta('Herramientas', 'TouchDesigner · FigJam · Figma'),
  ],
  portada: 'assets/images/luz_portada.jpg',
  portadaFondo: PC.ink,
  tarjetaBadge: 'Mejor Producto: Experiencias Interactivas · DEX 2026',
  tarjetaTrofeo: true,
  tarjetaEtiquetas: ['Experiencia interactiva', 'TouchDesigner'],
  tarjetaResumen:
      'Experiencia interactiva para el Museo de Arte Religioso de Santa Fe de Antioquia que revela cómo la fe se vive en '
      'comunidad. Elegida como el mejor proyecto del semestre.',
  tarjetaImagen: 'assets/images/card_luz.jpg',
  secciones: [
    Seccion(bloques: [
      BloqueReto(
        [
          Item('El reto',
              'El museo vive de espaldas a su entorno: la comunidad local no se siente representada, la función social y '
                  'educativa se pierde y el valor histórico y espiritual de las obras no se convierte en una experiencia significativa.',
              etiqueta: 'Un museo desconectado de su comunidad'),
          Item('La pregunta de diseño',
              '…visibilizar la vida de fe cotidiana como una red de apoyo en comunidad, transformando la observación pasiva '
                  'en una experiencia de empatía y acompañamiento comunitario?',
              etiqueta: '¿Cómo podríamos…'),
        ],
        Kpi('Mejor Producto', 'Experiencias Interactivas',
            'Reconocimiento en la Muestra DEX de Ingeniería en Diseño de Entretenimiento Digital UPB · 25 de mayo de 2026',
            trofeo: true),
      ),
    ]),
    Seccion(
      overline: 'Trabajo de campo',
      titulo: 'Salimos al territorio',
      intro: 'Visitamos Santa Fe de Antioquia para observar, escuchar y sentir el lugar. Organizamos todo en un muro de evidencias.',
      superficie: true,
      bloques: [
        BloqueTarjetas([
          Item('Lo que vimos', 'Calles coloniales, la sala de Semana Santa del museo y una procesión fúnebre solemne, pero sin tristeza.', color: PC.sky),
          Item('Lo que escuchamos', 'Tranquilidad: pasos, conversaciones lejanas, campanas y el eco de las calles.', color: PC.mint),
          Item('Lo que sentimos', 'Calma en las calles, calor intenso en la tarde y una plaza que se llena de turistas después de las 2 p. m.', color: PC.peach),
          Item('Puntos de fricción', 'Los locales saben que el museo existe, pero lo sienten como un espacio oficial para turistas y no lo visitan.', color: PC.primarySoft),
        ], columnas: 4, estilo: EstiloTarjeta.plano),
      ],
    ),
    Seccion(
      overline: 'Insights',
      titulo: 'Lo que descubrimos',
      intro:
          'Observación + la razón profunda = insight. Conversando con la comunidad entendimos que la fe agarra fuerza en familia '
          'y en comunidad: el dolor se comparte, se apoya y se acompaña.',
      bloques: [
        BloqueTarjetas([
          Item('La fe vicaria', 'Los jóvenes ya no practican, pero se sienten protegidos por la fe de sus madres y abuelas.', numero: '1', color: PC.primarySoft),
          Item('La música como narrativa', 'Las canciones de Semana Santa nacen de historias personales de dolor de compositores locales.', numero: '2', color: PC.mint),
          Item('El objeto como escudo', 'Imágenes como San Miguel o San Benito se compran por devoción, pero también como protección.', numero: '3', color: PC.peach),
          Item('La fe se aprende jugando', 'Con la «Semana Santica», los niños viven la procesión desde pequeños, por niveles.', numero: '4', color: PC.sky),
        ], columnas: 2, estilo: EstiloTarjeta.numerada),
        BloqueDestacado(
          'Problema central',
          '«En Santa Fe la fe funciona como una red de apoyo. Pero esas historias reales de acompañamiento se vuelven invisibles '
              'cuando el patrimonio religioso se muestra solo como objetos antiguos o eventos masivos como la Semana Santa».',
          cita: true,
        ),
      ],
    ),
    Seccion(
      overline: 'Hipótesis',
      titulo: 'Lo que quisimos validar',
      superficie: true,
      bloques: [
        BloqueTarjetas([
          Item('', 'Si conectamos las obras con las vivencias y los lugares cotidianos de los locales, el museo dejará de ser un edificio ajeno y será el espejo de su identidad.', numero: 'H1'),
          Item('', 'Contextualizar las obras desde la historia de Santa Fe permite conectar con el museo más allá de las creencias religiosas.', numero: 'H2'),
          Item('', 'Si el museo recibe al visitante con una atmósfera de calma, todos ajustarán su comportamiento y se abrirán a la conexión emocional.', numero: 'H3'),
        ], columnas: 3, estilo: EstiloTarjeta.plano),
      ],
    ),
    Seccion(
      overline: 'La comunidad',
      titulo: 'Cada pieza es esencial',
      intro: 'Identificamos los roles que sostienen la vida de fe en Santa Fe. Ellos se convirtieron en los protagonistas de la experiencia.',
      bloques: [
        BloqueTarjetas([
          Item('Matronas', 'Centro espiritual del hogar: su oración protege a hijos y nietos que ya no practican.', color: PC.peach),
          Item('Cargueros', 'Encarnan la fe a través del esfuerzo físico y el peso compartido.', color: PC.sky),
          Item('Sahumadoras', 'Mantienen viva una promesa familiar heredada a través del aroma.', color: PC.mint),
          Item('Hacedores', 'Las manos invisibles que restauran y preservan el arte sacro.', color: PC.primarySoft),
          Item('Mayordomos', 'Custodios de las imágenes: puente entre lo privado y lo público.', color: PC.lilac),
        ], columnas: 5, estilo: EstiloTarjeta.punto),
      ],
    ),
    Seccion(
      overline: 'La solución',
      titulo: 'Una experiencia en tres momentos',
      intro: 'El visitante recorre un camino que va de la luz íntima de una vela al encuentro con la comunidad, hasta reconocerse como parte de ella.',
      superficie: true,
      bloques: [
        BloqueImagenes([
          ImagenItem('assets/images/luz_fase1.jpg', 'Fase 1 · La cabina',
              'Un espacio oscuro, como un tenebrario. Con la luz de una vela se revelan capas ocultas de las obras, como lo hacen los hacedores al restaurarlas.'),
          ImagenItem('assets/images/luz_fase2.jpg', 'Fase 2 · La comunidad',
              'Las obras y el mapa de historias muestran cómo matronas, cargueros, sahumadoras y mayordomos sostienen la fe juntos.'),
          ImagenItem('assets/images/luz_fase3.jpg', 'Fase 3 · Tú, obra de fe',
              'El visitante se reconoce como un eslabón más: en Santa Fe cada persona es esencial para la fe comunitaria.'),
        ], columnas: 3, aspecto: 384 / 300),
        BloqueImagenes([
          ImagenItem('assets/images/luz_infancia.jpg', 'Infancia', ''),
          ImagenItem('assets/images/luz_adolescencia.jpg', 'Adolescencia', ''),
        ], columnas: 2, aspecto: 16 / 9),
      ],
    ),
    Seccion(
      overline: 'En funcionamiento',
      titulo: 'Así se vivió en la Muestra DEX.',
      intro: 'Registro del montaje real: visitantes recorriendo el mapa, activando las obras con gestos y entrando a la cabina.',
      bloques: [
        BloqueMedia([
          Item('Mapa de historias', 'Botones físicos, luces LED que conectan los puntos y audífonos para escuchar cada rol.'),
          Item('Obras vivas', 'Pantalla vertical donde la obra cobra vida al seguir los gestos de la mano.'),
          Item('La cabina', 'Espacio oscuro con proyecciones y velas para el momento más íntimo del recorrido.'),
        ], 'assets/images/luz_muestra.jpg', video: 'assets/videos/luz_muestra.mp4'),
      ],
    ),
    Seccion(
      overline: 'Instalaciones interactivas',
      titulo: 'Dos piezas que dan vida a las historias',
      superficie: true,
      bloques: [
        BloqueInstalaciones([
          Instalacion('assets/images/luz_obras.jpg', 'Obras vivas',
              'Inspirada en el estilo de Gregorio Vásquez de Arce y Ceballos. Con TouchDesigner y visión artificial, el visitante '
                  'navega una galería de obras con gestos de la mano: deslizar para hojear y apuntar para que la obra cobre vida.',
              [
                Item('Encuentro', 'La obra parece un dibujo antiguo, quieto.'),
                Item('Activación', 'Al acercarse aparecen micromovimientos: ojos, respiración.'),
                Item('Transformación', 'La imagen se desintegra en partículas de luz.'),
                Item('Revelación', 'Del polvo emerge una escena más profunda.'),
              ]),
          Instalacion('assets/images/luz_mapa.jpg', 'Mapa de historias',
              'Un muro con el mapa de Santa Fe y sus puntos de interés conectados. Al acercarse se enciende el punto de las '
                  'matronas y luego todo el mapa; con audífonos y botones, el visitante escucha la historia de cada rol.',
              [
                Item('Preinteracción', 'El mapa respira con un paisaje sonoro de rezos y campanas.'),
                Item('Proximidad', 'Se enciende la matrona y se iluminan las conexiones.'),
                Item('Interacción', 'Audífonos y botones para escuchar cada historia.'),
                Item('Reinicio', 'Al completar el ciclo, el mapa se apaga y se reinicia.'),
              ]),
        ]),
      ],
    ),
    Seccion(bloques: [
      BloqueReconocimiento('assets/images/luz_certificado.jpg', 'Mejor Producto: Experiencias Interactivas',
          'Muestra de Ingeniería en Diseño de Entretenimiento Digital UPB (DEX). Medellín, 25 de mayo de 2026. Elegido como el mejor proyecto del semestre.'),
    ]),
    Seccion(bloques: [
      BloqueCierre(
        logros: [
          'Reconocimiento a Mejor Producto en Experiencias Interactivas (DEX UPB 2026)',
          'Dos instalaciones interactivas: Obras vivas y Mapa de historias',
          'Propuesta presentada al museo con cronograma, subproductos y paquetes',
          // TODO: agrega tu aporte específico dentro del equipo.
        ],
        cita:
            '«Salir al territorio cambió el proyecto: escuchar a la comunidad nos llevó de mostrar objetos antiguos a contar cómo '
            'la fe se vive, se comparte y se acompaña».',
        etiquetasTitulo: 'Valores del equipo',
        etiquetas: ['Empatía', 'Creatividad', 'Respeto', 'Solidaridad', 'Responsabilidad', 'Originalidad'],
      ),
    ]),
  ],
);

const _flux = Proyecto(
  slug: 'flux',
  titulo: 'Flux',
  overline: 'Caso de estudio · Proyecto integrador · Equipo 404',
  insignia: 'Mejor Diseño UX/UI · DEX UPB 2026',
  etiquetas: ['Web app', 'EdTech', 'Simulación 3D'],
  resumen:
      'Simulador interactivo de fisiología cardiovascular para estudiantes de medicina: cambias una variable y ves en 3D qué le '
      'pasa al corazón y a las arterias. Suma biblioteca, quices, calculadora, un tutor con IA y realidad aumentada.',
  urlWeb: 'https://fluxapp.site',
  meta: [
    Meta('Rol', 'Creative Director · UI/UX'),
    Meta('Alcance', 'Web app + PWA + AR'),
    Meta('Plataforma', 'Tablet · Web · Celular'),
    Meta('Herramientas', 'Figma · Flutter · Three.js · 8th Wall · Maze'),
  ],
  portada: 'assets/images/flux_portada.jpg',
  portadaFondo: PC.night,
  tarjetaBadge: 'Proyecto integrador · Web app + AR',
  tarjetaEtiquetas: ['Web app', 'EdTech'],
  tarjetaResumen:
      'Simulador interactivo de fisiología cardiovascular para estudiantes de medicina: simulaciones 3D, casos clínicos, '
      'calculadora, quices, un tutor con IA y una tarjeta con realidad aumentada. Proyecto integrador del Equipo 404 (UPB).',
  tarjetaImagen: 'assets/images/card_flux.jpg',
  secciones: [
    Seccion(bloques: [
      BloqueReto(
        [
          Item('El problema',
              'En los primeros semestres de medicina la fisiología cardiovascular se estudia con fórmulas y libros: se memoriza '
                  'GC = FC × VS, pero no se ve qué pasa cuando una variable cambia.',
              etiqueta: 'La fisiología se memoriza, pero no se entiende'),
          Item('El objetivo',
              'Diseñar una herramienta para experimentar con la teoría: mover una variable, ver el resultado en 3D y conectarlo con lo que se ve en clase.',
              etiqueta: 'Pasar de memorizar a comprender'),
        ],
        Kpi('58 %', 'de 33 estudiantes encuestados', 'admite memorizar sin entender los mecanismos de la fisiología (UPB).'),
      ),
    ]),
    Seccion(
      overline: 'Investigación',
      titulo: 'Lo que nos dijeron los estudiantes',
      intro:
          'Observamos una clase de fisiología de 70 minutos en la UPB, encuestamos a 33 estudiantes de medicina y entrevistamos '
          'a docentes del laboratorio de simulación.',
      superficie: true,
      bloques: [
        BloqueStats([
          Item('58 %', 'memoriza sin entender los mecanismos'),
          Item('54,8 %', 'tiene dificultad para integrar conceptos'),
          Item('93,6 %', 'usaría una herramienta para cambiar variables en tiempo real'),
          Item('83,9 %', 'prefiere casos clínicos basados en parámetros'),
          Item('90,3 %', 'estudia en casa, fuera del laboratorio de simulación'),
          Item('61,3 %', 'busca videos en YouTube cuando no entiende'),
        ]),
        BloqueDestacado(
          'Insight',
          'El problema no es la falta de información sino de visualización: los estudiantes no ven la relación de causa y efecto '
              'entre presión, flujo y resistencia, así que memorizan. Necesitan experimentar con variables, en casa y desde sus propios dispositivos.',
        ),
      ],
    ),
    Seccion(
      overline: 'Usuario',
      titulo: 'Conoce a Camilo',
      superficie: true,
      bloques: [
        BloquePersona(
          iniciales: 'CP',
          nombre: 'Camilo Paz, 21',
          descripcion: 'Estudiante de medicina de 3.er semestre en la UPB, en la transición entre la fisiología teórica y la semiología.',
          cita: '«Siento que memorizo para pasar el examen, pero no entiendo qué le está pasando al corazón».',
          listas: [
            ('Motivaciones', [
              'Convertir conceptos abstractos en algo que pueda ver',
              'Conectar signos y síntomas con patologías antes de ver pacientes',
              'Ganar confianza y superar la sensación de «impostor»',
            ]),
            ('Frustraciones y miedos', [
              'Aprobar memorizando, sin comprender realmente',
              'Herramientas del laboratorio sin retroalimentación interactiva',
              'Diapositivas densas y textos largos que no retienen su atención',
              'Sentirse rezagado frente a sus compañeros',
            ]),
          ],
        ),
        BloqueTarjetas([
          Item('¿Qué piensa y siente?', 'Que cada semestre sabe menos y que el volumen de teoría no le deja entender.', color: PC.peach),
          Item('¿Qué oye?', 'Clases magistrales de 70 minutos con diapositivas cargadas de texto.', color: PC.sky),
          Item('¿Qué ve?', 'Esquemas densos proyectados que no se leen desde el fondo del salón.', color: PC.mint),
          Item('¿Qué dice y hace?', 'Toma fotos a las diapositivas para escribir encima y busca videos en YouTube.', color: PC.lilac),
        ], columnas: 4, estilo: EstiloTarjeta.punto),
      ],
    ),
    Seccion(
      overline: 'Proceso',
      titulo: 'Cómo lo abordamos',
      superficie: true,
      bloques: [
        BloqueTarjetas([
          Item('Investigación', 'Observación de clase, encuesta a 33 estudiantes y entrevistas con docentes de la UPB.', numero: '01'),
          Item('Concepto', 'Simulaciones, biblioteca, quices, calculadora y Fluxy, un tutor con IA.', numero: '02'),
          Item('Diseño y desarrollo', 'Sistema de diseño oscuro con vidrio, prototipo en Figma y web app en Flutter + Three.js.', numero: '03'),
          Item('Validación', 'Pruebas presenciales con 5 estudiantes y pruebas no moderadas en Maze.', numero: '04'),
        ], columnas: 4, estilo: EstiloTarjeta.divisor),
      ],
    ),
    Seccion(
      overline: 'Funcionalidades',
      titulo: 'Qué puedes hacer en Flux',
      bloques: [
        BloqueTarjetas([
          Item('Simulaciones en 3D', 'Flujo en arterias y gasto cardíaco: mueves presión, diámetro o frecuencia y el modelo responde en vivo.', numero: '01'),
          Item('Casos clínicos', 'Taquicardia, hipertensión, vasoconstricción o ejercicio cargan sus valores con un toque.', numero: '02'),
          Item('Calculadora hemodinámica', 'Gasto cardíaco, Fick, índice cardíaco y PAM, con validación de rangos fisiológicos.', numero: '03'),
          Item('Biblioteca y quices', 'Lecturas de fisiología cardiovascular y quices con revisión de respuestas.', numero: '04'),
          Item('Fluxy, tutor con IA', 'Un glóbulo rojo que resuelve dudas de fisiología desde cualquier pantalla.', numero: '05'),
          Item('Clases y realidad aumentada', 'Los profesores asignan contenido a sus clases y la tarjeta de Flux muestra el corazón en AR.', numero: '06'),
        ], columnas: 3, estilo: EstiloTarjeta.borde),
      ],
    ),
    Seccion(
      overline: 'La solución',
      titulo: 'Pantallas clave',
      intro: 'Un recorrido por las pantallas que más usan estudiantes y profesores.',
      superficie: true,
      bloques: [
        BloqueImagenes([
          ImagenItem('assets/images/flux_inicio.jpg', 'Inicio', 'Simulación destacada, conceptos clave y nuevas lecturas.'),
          ImagenItem('assets/images/flux_simulaciones.jpg', 'Simulaciones', 'Arterias proximales, arterias musculares y gasto cardíaco, cada una con su modelo 3D.'),
          ImagenItem('assets/images/flux_calculadora.jpg', 'Calculadora hemodinámica', 'Gasto cardíaco, índice cardíaco, volumen sistólico y PAM, con valores de referencia.'),
          ImagenItem('assets/images/flux_biblioteca.jpg', 'Biblioteca', 'Lecturas de fisiología cardiovascular por categoría, con buscador y visor de PDF.'),
          ImagenItem('assets/images/flux_quices.jpg', 'Quices', 'Quices por sistema y tema, con tiempo estimado para cada uno.'),
          ImagenItem('assets/images/flux_instalar.jpg', 'Instalar Flux', 'Pasos para instalarla como app en iPad, Android o computador, con QR.'),
        ], columnas: 2, aspecto: 2, fondo: PC.night, ajuste: BoxFit.contain),
      ],
    ),
    Seccion(bloques: [
      BloqueReconocimiento('assets/images/flux_certificado.jpg', 'Mejor Diseño UX/UI',
          'Reconocimiento entregado a 404 Design, el equipo de Flux, en la Muestra de Ingeniería en Diseño de Entretenimiento '
              'Digital UPB, en Medellín, el 10 de noviembre de 2026.'),
    ]),
    Seccion(bloques: [
      BloqueCierre(
        logros: [
          'Web app publicada en fluxapp.site, instalable como PWA en tablet',
          'Experiencia de realidad aumentada con 8th Wall en la tarjeta de presentación',
          'Pruebas con 5 estudiantes: 7 de 8 tareas con 100 % de éxito',
          'La selección de casos clínicos (60 %) se rediseñó con lo aprendido en la prueba',
        ],
        cita: '«En educación la interfaz no compite con el contenido: cada pantalla tiene que llevar al estudiante a preguntarse “¿y si cambio esto?”».',
      ),
    ]),
  ],
);

const _vr = Proyecto(
  slug: 'vr-herencia',
  titulo: 'VR Herencia',
  overline: 'Caso de estudio · Proyecto en equipo con diseño gráfico',
  etiquetas: ['Unity 6', 'Meta Quest', 'Trabajo en equipo'],
  resumen:
      '«Las manos recuerdan» es una experiencia de realidad virtual para Meta Quest sobre la memoria y la herencia. Como '
      'desarrollador en Unity llevé el arte del equipo de diseño gráfico al motor y lo convertí en interacciones, guías visuales '
      'y momentos que se pueden vivir.',
  meta: [
    Meta('Rol', 'Desarrollador Unity VR'),
    Meta('Alcance', 'Experiencia VR por actos'),
    Meta('Plataforma', 'Meta Quest'),
    Meta('Herramientas', 'Unity 6 · URP · Meta XR SDK · C# · Git'),
  ],
  portada: 'assets/images/vr_portada.jpg',
  portadaFondo: Color(0xFF2A1B12),
  tarjetaBadge: 'Desarrollo Unity VR · Trabajo en equipo',
  tarjetaEtiquetas: ['Unity 6', 'Meta Quest'],
  tarjetaResumen:
      'Experiencia de realidad virtual «Las manos recuerdan», desarrollada en Unity para Meta Quest. Yo me encargué del '
      'desarrollo: interacciones, guías visuales con partículas y la integración de todo el arte al motor, trabajando de la mano '
      'con el equipo de diseño gráfico, que creó la dirección visual y los assets del proyecto.',
  tarjetaImagen: 'assets/images/card_vr.jpg',
  secciones: [
    Seccion(bloques: [
      BloqueReto(
        [
          Item('El reto',
              'El equipo de diseño gráfico definió la dirección visual de la experiencia. El reto del desarrollo fue llevar ese arte '
                  'a Unity y hacerlo interactivo en VR, cuidando que cada acto fuera fiel a la historia y funcionara bien en Quest.',
              etiqueta: 'Del arte al motor, sin perder la intención'),
          Item('Mi objetivo',
              'Construir interacciones y guías visuales sutiles (luz, humo, brillos) que orienten al usuario dentro de la historia sin romper la inmersión.',
              etiqueta: 'Que el usuario sepa qué hacer sin instrucciones'),
        ],
        Kpi('2 áreas', 'trabajando en conjunto', 'Diseño gráfico y desarrollo en un mismo proyecto.'),
      ),
    ]),
    Seccion(
      overline: 'Proceso',
      titulo: 'Del arte a Unity',
      superficie: true,
      bloques: [
        BloqueTarjetas([
          Item('Recibir el arte', 'Assets, escenas y referencias del equipo de diseño gráfico, con el guion de la experiencia como base.', numero: '01'),
          Item('Montar en Unity', 'Integración de escenas y prefabs en Unity 6 con URP, pensados para Meta Quest.', numero: '02'),
          Item('Hacerlo interactivo', 'Agarres, snaps y puertas con Meta XR SDK, más audios y secuencias por acto.', numero: '03'),
          Item('Iterar con el equipo', 'Ajustes de posición, luz y tiempos a partir de las observaciones del equipo de diseño.', numero: '04'),
        ], columnas: 4, estilo: EstiloTarjeta.divisor),
      ],
    ),
    Seccion(
      overline: 'Lo que construí',
      titulo: 'Mi aporte como desarrollador',
      bloques: [
        BloqueTarjetas([
          Item('Brillo en la maceta', 'Al encajar el objeto en el snap, la maceta se ilumina con un resplandor verde tierra y dorado.', numero: '01'),
          Item('Humo en la olla', 'Partículas de humo que aparecen cuando el usuario se acerca a la olla.', numero: '02'),
          Item('Guía hacia la puerta', 'Luz que señala la puerta de las semillas, la acompaña al abrirse y se desvanece.', numero: '03'),
          Item('Aura de la maceta', 'Aura de luz que indica dónde colocar la semilla cuando Yta llega a la huerta.', numero: '04'),
          Item('Luz en la carta', 'Partículas sobre el cajón que le indican al usuario que debe tomar la carta.', numero: '05'),
          Item('Integración con diseño', 'Escenas, prefabs y materiales del equipo de diseño gráfico llevados a Unity.', numero: '06'),
        ], columnas: 3, estilo: EstiloTarjeta.borde),
      ],
    ),
    Seccion(
      overline: 'Dentro de Unity',
      titulo: 'Decisiones técnicas',
      intro: 'Cómo resolví las guías visuales para que funcionaran bien en Quest.',
      superficie: true,
      bloques: [
        BloqueImagenes([
          ImagenItem('assets/images/vr_particulas.jpg', 'Partículas generadas por código', 'Sistemas creados en tiempo de ejecución con un material URP aditivo, sin depender de assets extra.'),
          ImagenItem('assets/images/vr_escenas.jpg', 'Escenas listas para Quest', 'Cocina, huerta y casa del equipo de diseño gráfico llevadas a Unity con URP.'),
          ImagenItem('assets/images/vr_encender.jpg', 'Encender en el momento justo', 'Las luces reaccionan a la secuencia de audios y a los snaps del Meta Interaction SDK.'),
          ImagenItem('assets/images/vr_arte.jpg', 'Arte original intacto', 'El brillo se aplica a copias del material, así el arte del equipo de diseño no se modifica.'),
        ], columnas: 2, aspecto: 588 / 265),
      ],
    ),
    Seccion(bloques: [
      BloqueCierre(
        logros: [
          'Experiencia VR terminada para Meta Quest',
          'Guías visuales con luz y humo en los actos 5 y 7',
          'Arte del equipo de diseño gráfico integrado en Unity',
          'Código en C# ordenado y trabajado por ramas con el equipo',
        ],
        cita: '«En VR el desarrollo y el diseño no se turnan: se resuelven juntos, escena por escena».',
      ),
    ]),
  ],
);

const _safetrip = Proyecto(
  slug: 'safetrip',
  titulo: 'SafeTrip',
  overline: 'Caso de estudio · Parcial de diseño UX',
  etiquetas: ['App móvil', 'UX Research', 'Reducción de riesgos'],
  resumen:
      'Una app que acompaña en tiempo real a quienes asisten a conciertos y festivales: mapa de zonas de apoyo, alertas, botón '
      'SOS y un planificador de consumo responsable para disfrutar la música sin poner en riesgo la vida.',
  meta: [
    Meta('Rol', 'UX Researcher · UI Designer'),
    Meta('Equipo', '2 diseñadores'),
    Meta('Plataforma', 'App móvil (iOS)'),
    Meta('Herramientas', 'Figma · Encuestas'),
  ],
  portada: 'assets/images/st_portada.jpg',
  portadaFondo: Color(0xFF101010),
  tarjetaBadge: 'Parcial · Proceso UX completo',
  tarjetaEtiquetas: ['App móvil', 'UX Research'],
  tarjetaResumen:
      'App que acompaña en tiempo real a quienes van a conciertos y festivales: mapa de zonas de apoyo, alertas, botón SOS y '
      'consumo responsable. Investigación, persona, journey map y UI de alta fidelidad.',
  tarjetaImagen: 'assets/images/card_safetrip.jpg',
  secciones: [
    Seccion(bloques: [
      BloqueReto(
        [
          Item('El problema',
              'En los eventos masivos, las aglomeraciones, el consumo de sustancias y la falta de información en tiempo real hacen '
                  'que una emergencia se vuelva crítica rápido. Los asistentes dependen de sus amigos o del personal, lo que retrasa la ayuda y genera desprotección.',
              etiqueta: 'Festivales sin red de apoyo'),
          Item('El objetivo',
              'Diseñar una solución preventiva y de reacción rápida que reduzca riesgos y mejore la experiencia, integrándose al disfrute en lugar de sentirse restrictiva.',
              etiqueta: 'Acompañar sin interrumpir la fiesta'),
        ],
        Kpi('4,81', 'de 5: el botón SOS fue la función mejor valorada', 'El 81,3 % de los encuestados le dio la calificación máxima.'),
      ),
    ]),
    Seccion(
      overline: 'Investigación',
      titulo: 'Lo que nos dijeron los asistentes',
      intro:
          'Combinamos una encuesta cuantitativa con un análisis cualitativo de las respuestas. El público principal: jóvenes adultos '
          'de 18 a 34 años, sobre todo de Antioquia y Córdoba.',
      superficie: true,
      bloques: [
        BloqueStats([
          Item('90,6 %', 'va a festivales por la música y los artistas'),
          Item('46,9 %', 'teme perder el contacto con sus amigos'),
          Item('40,6 %', 'no sabe dónde están los puntos de apoyo'),
          Item('72,7 %', 'nunca había oído hablar de colectivos como Échele Cabeza'),
          Item('56,3 %', 'teme que los datos de la app no sean confiables'),
          Item('+70 %', 'considera la seguridad algo fundamental'),
        ]),
        BloqueDestacado(
          'Insight',
          'Las preocupaciones son logísticas y de autocuidado: perderse, no encontrar ayuda, sentirse mal. Y la legitimidad de la '
              'app depende de dos cosas: la precisión de sus alertas y el cuidado de la privacidad.',
        ),
      ],
    ),
    Seccion(
      overline: 'Matriz de priorización',
      titulo: '¿Qué funciones importan más?',
      intro: 'Pedimos calificar cada función de 1 a 5. El resultado definió el orden del diseño.',
      bloques: [
        BloqueBarras([
          Item('Botón SOS', 'Seguridad inmediata', numero: '4,81'),
          Item('Mapa interactivo', 'Acceso y orientación', numero: '4,69'),
          Item('Alertas en tiempo real', 'Prevención colectiva', numero: '4,44'),
          Item('Planificador de consumo', 'Prevención individual', numero: '4,19'),
        ], 'El planificador de consumo obtuvo la nota más baja, posiblemente por el estigma de registrar consumos. Por eso lo diseñamos opcional y 100 % privado.'),
      ],
    ),
    Seccion(
      overline: 'Usuario',
      titulo: 'Conoce a Sebastián',
      superficie: true,
      bloques: [
        BloquePersona(
          iniciales: 'SR',
          nombre: 'Sebastián Restrepo, 28',
          descripcion: 'Ingeniero de sistemas · Medellín. Va con frecuencia a festivales como Afterlife, Ultra y Ritvales.',
          cita: '«Necesito disfrutar la música de forma segura, sin perder a mis amigos ni quedarme sin ayuda en una emergencia».',
          listas: [
            ('Motivaciones', [
              'Ver artistas en vivo y bailar durante horas',
              'Vivir experiencias sensoriales y compartir con amigos',
              'Experimentar de forma responsable',
            ]),
            ('Frustraciones y miedos', [
              'Perderse de sus amigos en la multitud',
              'No ubicar rápido agua, descanso o primeros auxilios',
              'Sustancias adulteradas y respuesta lenta en emergencias',
              'Su privacidad en las apps',
            ]),
          ],
        ),
        BloqueTarjetas([
          Item('¿Qué piensa y siente?', 'Quiere disfrutar sin preocupaciones y sentirse tranquilo y acompañado.', color: PC.peach),
          Item('¿Qué oye?', '«Hidrátate», «no te quedes solo» y anuncios del festival que no siempre llegan a tiempo.', color: PC.sky),
          Item('¿Qué ve?', 'Aglomeraciones y poca señalización de hidratación, baños y primeros auxilios.', color: PC.mint),
          Item('¿Qué dice y hace?', 'Usa chats para ubicarse con amigos y a veces minimiza el riesgo: «no me va a pasar nada».', color: PC.lilac),
        ], columnas: 4, estilo: EstiloTarjeta.punto),
      ],
    ),
    Seccion(
      overline: 'Journey map',
      titulo: 'El festival, paso a paso',
      bloques: [
        BloqueTarjetas([
          Item('Antes', 'Descarga la app y configura alertas.', numero: '1', etiqueta: 'Expectativa'),
          Item('Llegada', 'Ubica en el mapa hidratación y zonas seguras.', numero: '2', etiqueta: 'Confianza'),
          Item('Durante', 'Recibe alertas de calor y recordatorios de hidratación.', numero: '3', etiqueta: 'Tranquilidad'),
          Item('Emergencia', 'Usa el botón SOS y comparte su ubicación.', numero: '4', etiqueta: 'Urgencia'),
          Item('Con amigos', 'Localiza a su grupo y coordina puntos de encuentro.', numero: '5', etiqueta: 'Alivio'),
          Item('Después', 'Revisa su experiencia y deja feedback.', numero: '6', etiqueta: 'Reflexión'),
        ], columnas: 3, estilo: EstiloTarjeta.numerada),
      ],
    ),
    Seccion(
      overline: 'La solución',
      titulo: 'Un acompañante digital',
      intro:
          'De la arquitectura de información a los wireframes de baja y alta fidelidad: 8 pantallas pensadas para usarse con una '
          'mano, con poca luz y mucho ruido.',
      superficie: true,
      bloques: [
        BloqueEtiquetas('Arquitectura', [
          'Bienvenida', 'Inicio de sesión', 'Home', 'Calendario', 'Historial de consumo', 'Mapa del evento', 'Botón SOS', 'Perfil',
        ]),
        BloqueImagenes([
          ImagenItem('assets/images/st_home.jpg', 'Home', 'Noticias, próximos eventos y el botón SOS siempre visible.'),
          ImagenItem('assets/images/st_mapa.jpg', 'Mapa y alertas', 'Zonas de hidratación, descanso y emergencias, con alertas del festival.'),
          ImagenItem('assets/images/st_sos.jpg', 'Botón SOS', 'Mantén presionado para pedir ayuda, comparte tu ubicación y sigue el estado.'),
          ImagenItem('assets/images/st_registro.jpg', 'Registrar consumo', 'Registro opcional y privado de tipo, tiempo y combinaciones (alcohol u otras sustancias).'),
        ], columnas: 4, aspecto: 285 / 520, fondo: PC.lilac, ajuste: BoxFit.contain),
        BloqueEstilo('Nunito Sans · Modo oscuro para entornos de poca luz · Verde para apoyo, magenta para el botón SOS', [
          ('Fondo', '#101010'),
          ('Superficie', '#1A1A1A'),
          ('Texto', '#F5F5F5'),
          ('Secundario', '#8A8A8A'),
          ('Apoyo', '#1DD1A1'),
          ('Apoyo suave', '#8DC7B7'),
          ('SOS', '#D13185'),
        ]),
      ],
    ),
    Seccion(bloques: [
      BloqueCierre(
        overlineIzq: 'Mi aporte',
        tituloIzq: 'Lo que hice en el proyecto',
        logros: [
          'Plan de investigación e investigación cuantitativa',
          'Mapa de empatía y definición de la problemática',
          'User flow y journey map',
          'Wireframes y UI de alta fidelidad con sistema de componentes',
        ],
        cita:
            '«En temas sensibles, la confianza también se diseña: la función menos valorada no lo era por inútil, sino por el '
            'estigma. La privacidad y la claridad tienen que estar desde el primer boceto».',
      ),
    ]),
  ],
);
