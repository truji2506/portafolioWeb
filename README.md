# Portafolio · José Trujillo

Web del portafolio hecha en **Flutter** y publicada en **Firebase Hosting**, con la misma estructura que el proyecto *Asmodeo*. El diseño sale del archivo de Figma **Portafolio**: usa los mismos tokens de color, la tipografía Nunito, los radios y los espaciados del sistema de diseño, y es responsive para desktop, tablet y celular.

## Estructura

```
lib/
  main.dart               Inicializa Firebase, define las URLs y las rutas
  firebase_options.dart   Lo genera `flutterfire configure` (por ahora es un archivo temporal)
  app/
    theme.dart            Tokens: colores (PC), tipografía (PT), radios (PR), layout (PL), sombras (PS)
    data.dart             TODO el contenido: textos del home, enlaces y los 4 casos de estudio
    shell.dart            Barra superior, menú móvil, footer y rutas
    screens/home.dart     Home: hero, casos, sobre mí, experiencia, habilidades, contacto
    screens/caso.dart     Plantilla de caso de estudio (portada, secciones, siguiente proyecto)
    widgets/common.dart   Componentes del sistema: Button, Tag, tarjetas, grilla responsive…
    widgets/bloques.dart  Bloques de los casos: reto + KPI, tarjetas, estadísticas, persona, barras…
assets/images/            Imágenes exportadas desde Figma (página «Assets web») y optimizadas para web
assets/videos/            Video del montaje en la muestra DEX (caso de Luz)
web/                      index.html, manifest e íconos
firebase.json             Hosting: publica build/web y redirige todo a index.html
```

Rutas de la web:

| URL | Página |
|---|---|
| `/` | Home |
| `/proyectos/luz-memorias-eternidad` | Luz, Memorias y Eternidad |
| `/proyectos/flux` | Flux |
| `/proyectos/vr-herencia` | VR Herencia |
| `/proyectos/safetrip` | SafeTrip |

## Paso a paso

### 1. Exportar las imágenes del Figma
1. En el archivo **Portafolio**, abre la página **Assets web**.
2. Selecciona el frame **Assets web — vista**.
3. Presiona `Ctrl + Shift + E` y exporta. Cada imagen ya tiene su nombre de archivo y su formato configurados: JPG 2x, y PNG para `retrato` y `logo_crediexcel`.
4. Copia todos los archivos exportados a `assets/images/`.

> Si falta una imagen, la web no se rompe: en su lugar muestra un bloque de color.

### 2. Completar el proyecto Flutter
```bash
cd portafolio_web
flutter create . --platforms web --project-name portafolio_jose   # crea solo los archivos que faltan, no toca lib/
flutter pub get
```

### 3. Conectar Firebase (igual que en Asmodeo)
```bash
firebase login
# el proyecto ya existe: portafoliojosetrujillo
firebase use --add                                  # elige el proyecto (actualiza .firebaserc)
flutterfire configure --platforms=web               # reemplaza lib/firebase_options.dart
```

### 4. Probar en local
```bash
flutter run -d chrome
```

### 5. Publicar
```bash
flutter build web --release
firebase deploy --only hosting
```
La web queda en `https://<tu-proyecto>.web.app`. Si tienes un dominio propio, conéctalo en Firebase → Hosting → *Agregar dominio personalizado*.

## Pendientes
- **Enlaces** (`lib/app/data.dart` → `Enlaces`): CV, LinkedIn, Behance y Dribbble están vacíos. Los botones y enlaces sin URL no aparecen en la web.
- **Tu aporte en Luz** (`data.dart`, busca `TODO`): falta la línea con tu aporte específico dentro del equipo.
- **Video**: el caso de Luz reproduce `assets/videos/luz_muestra.mp4` (46 s con lo mejor de la muestra DEX, sin sonido y en bucle) con `video_player`. Para cambiarlo, reemplaza ese archivo.

## Editar contenido
Todo el texto está en `lib/app/data.dart`. Para agregar un caso de estudio, crea un nuevo `Proyecto` con sus `Seccion` y `Bloque`, y súmalo a la lista `proyectos`. El home y la cadena de «Siguiente proyecto» se actualizan solos.
