// Fondo de partículas naranjas del hero (three.js).
// Flutter crea un <div> (HtmlElementView 'fondo-particulas') y llama a
// window.iniciarParticulas(div). Al pasar el mouse, las partículas se barren
// en la dirección del movimiento y luego vuelven solas a su lugar.
import * as THREE from 'https://cdn.jsdelivr.net/npm/three@0.170.0/build/three.module.min.js';

const NARANJA = new THREE.Vector3(0xE8 / 255, 0x62 / 255, 0x0F / 255); // #E8620F (accent)
const NARANJA_VIVO = new THREE.Vector3(1.0, 0x8A / 255, 0x3D / 255);  // brillo al barrer
const reducirMovimiento = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

const vertex = /* glsl */ `
  attribute float aEnergia;
  uniform float uPx;
  uniform float uTam;
  uniform vec2 uMitad;
  varying float vE;
  varying float vBorde;
  void main() {
    vE = aEnergia;
    vec2 n = position.xy / uMitad;
    // Se desvanece arriba y abajo para fundirse con las secciones vecinas.
    vBorde = smoothstep(1.0, 0.7, abs(n.y)) * smoothstep(1.0, 0.92, abs(n.x));
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    gl_PointSize = (uTam + aEnergia * uTam * 1.4) * uPx;
  }
`;

const fragment = /* glsl */ `
  uniform vec3 uColor;
  uniform vec3 uVivo;
  varying float vE;
  varying float vBorde;
  void main() {
    float d = length(gl_PointCoord - 0.5);
    if (d > 0.5) discard;
    float a = smoothstep(0.5, 0.15, d);
    vec3 col = mix(uColor, uVivo, vE);
    gl_FragColor = vec4(col, a * (0.26 + vE * 0.74) * vBorde);
  }
`;

function crear(el) {
  if (!el || el.__particulas) return;
  const estado = { vivo: true };
  el.__particulas = estado;

  const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true, powerPreference: 'low-power' });
  renderer.setClearColor(0x000000, 0);
  const dpr = Math.min(window.devicePixelRatio || 1, 2);
  renderer.setPixelRatio(dpr);
  Object.assign(renderer.domElement.style, { width: '100%', height: '100%', display: 'block', pointerEvents: 'none' });
  el.appendChild(renderer.domElement);

  const escena = new THREE.Scene();
  const camara = new THREE.OrthographicCamera(-1, 1, 1, -1, -10, 10);
  const material = new THREE.ShaderMaterial({
    vertexShader: vertex,
    fragmentShader: fragment,
    transparent: true,
    depthWrite: false,
    uniforms: {
      uPx: { value: dpr },
      uTam: { value: 3.0 },
      uMitad: { value: new THREE.Vector2(1, 1) },
      uColor: { value: NARANJA },
      uVivo: { value: NARANJA_VIVO },
    },
  });

  let puntos = null, geo = null;
  let n = 0, casa, pos, vel, energia, semilla;
  let w = 0, h = 0;

  function construir() {
    const r = el.getBoundingClientRect();
    if (r.width < 2 || r.height < 2) return false;
    w = r.width; h = r.height;
    renderer.setSize(w, h, false);
    camara.left = -w / 2; camara.right = w / 2; camara.top = h / 2; camara.bottom = -h / 2;
    camara.updateProjectionMatrix();
    material.uniforms.uMitad.value.set(w / 2, h / 2);
    material.uniforms.uTam.value = w < 720 ? 2.4 : 3.0;

    const paso = w < 720 ? 24 : 19;
    const cols = Math.ceil(w / paso) + 1, filas = Math.ceil(h / paso) + 1;
    n = cols * filas;
    casa = new Float32Array(n * 2);
    pos = new Float32Array(n * 3);
    vel = new Float32Array(n * 2);
    energia = new Float32Array(n);
    semilla = new Float32Array(n);
    let i = 0;
    for (let f = 0; f < filas; f++) {
      for (let c = 0; c < cols; c++, i++) {
        const x = -w / 2 + c * paso + (Math.random() - 0.5) * paso * 0.7;
        const y = -h / 2 + f * paso + (Math.random() - 0.5) * paso * 0.7;
        casa[i * 2] = x; casa[i * 2 + 1] = y;
        pos[i * 3] = x; pos[i * 3 + 1] = y; pos[i * 3 + 2] = 0;
        semilla[i] = Math.random() * Math.PI * 2;
      }
    }
    if (puntos) { escena.remove(puntos); geo.dispose(); }
    geo = new THREE.BufferGeometry();
    geo.setAttribute('position', new THREE.BufferAttribute(pos, 3).setUsage(THREE.DynamicDrawUsage));
    geo.setAttribute('aEnergia', new THREE.BufferAttribute(energia, 1).setUsage(THREE.DynamicDrawUsage));
    puntos = new THREE.Points(geo, material);
    puntos.frustumCulled = false;
    escena.add(puntos);
    renderer.render(escena, camara);
    return true;
  }

  // ── Mouse: Flutter manda la posición local (x, y desde la esquina superior
  // izquierda del hero) con particulasMover; no se escuchan eventos del DOM.
  const mouse = { x: 0, y: 0, vx: 0, vy: 0, activo: false, previo: false };
  estado.mover = (lx, ly) => {
    const x = lx - w / 2, y = -(ly - h / 2);
    if (mouse.previo) {
      mouse.vx += ((x - mouse.x) - mouse.vx) * 0.5;
      mouse.vy += ((y - mouse.y) - mouse.vy) * 0.5;
    }
    mouse.x = x; mouse.y = y; mouse.activo = true; mouse.previo = true;
    arrancar();
  };
  estado.salir = () => { mouse.activo = false; mouse.previo = false; };

  // ── Animación ────────────────────────────────────────────────────────────
  const RADIO = 150, R2 = RADIO * RADIO;
  let t = 0, raf = 0, espera = 0, desconectado = 0, quieto = 0;

  // Visibilidad medida directamente: al cargar, Flutter crea el div antes de
  // ponerlo en pantalla y un IntersectionObserver lo daba por oculto.
  function enPantalla() {
    const r = el.getBoundingClientRect();
    return r.width > 0 && r.height > 0 && r.bottom > 0 && r.right > 0 &&
      r.top < window.innerHeight && r.left < window.innerWidth;
  }
  // Fuera de pantalla no anima; revisa cada 300 ms si volvió.
  function esperar() {
    if (espera || !estado.vivo) return;
    espera = setTimeout(() => { espera = 0; if (enPantalla()) arrancar(); else esperar(); }, 300);
  }

  function cuadro() {
    raf = 0;
    if (!estado.vivo) return;
    if (!el.isConnected) {
      if (++desconectado > 120) return destruir();
      raf = requestAnimationFrame(cuadro);
      return;
    }
    desconectado = 0;
    if (document.hidden) return;
    if (!enPantalla()) { esperar(); return; }
    if (!n && !construir()) { raf = requestAnimationFrame(cuadro); return; }

    t += 0.016;
    const mx = mouse.x, my = mouse.y, mvx = mouse.vx, mvy = mouse.vy;
    const activo = mouse.activo;
    const deriva = reducirMovimiento ? 0 : 2.5;
    let movimiento = 0;

    for (let i = 0; i < n; i++) {
      const i2 = i * 2, i3 = i * 3;
      const hx = casa[i2], hy = casa[i2 + 1], s = semilla[i];
      // Destino: su casa con una ondulación suave para que el fondo respire.
      const tx = hx + Math.sin(hy * 0.012 + t * 0.6 + s) * deriva;
      const ty = hy + Math.cos(hx * 0.010 + t * 0.5 + s) * deriva;
      let px = pos[i3], py = pos[i3 + 1];
      let vx = vel[i2], vy = vel[i2 + 1];

      if (activo) {
        const dx = px - mx, dy = py - my, d2 = dx * dx + dy * dy;
        if (d2 < R2) {
          const d = Math.sqrt(d2) || 1;
          const f = (1 - d / RADIO) ** 2;
          // Empuje radial + arrastre en la dirección del mouse = barrido.
          vx += (dx / d) * f * 2.2 + mvx * f * 0.55;
          vy += (dy / d) * f * 2.2 + mvy * f * 0.55;
        }
      }
      vx += (tx - px) * 0.035;
      vy += (ty - py) * 0.035;
      vx *= 0.88; vy *= 0.88;
      px += vx; py += vy;
      pos[i3] = px; pos[i3 + 1] = py;
      vel[i2] = vx; vel[i2 + 1] = vy;

      const ox = px - tx, oy = py - ty;
      const desp = Math.sqrt(ox * ox + oy * oy);
      const meta = Math.min(1, desp / 32);
      energia[i] += (meta - energia[i]) * 0.18;
      movimiento += Math.abs(vx) + Math.abs(vy);
    }
    mouse.vx *= 0.9; mouse.vy *= 0.9;

    geo.attributes.position.needsUpdate = true;
    geo.attributes.aEnergia.needsUpdate = true;
    renderer.render(escena, camara);

    // Con "reducir movimiento" se detiene en cuanto todo vuelve a su sitio.
    if (reducirMovimiento && !activo && movimiento / n < 0.01) { if (++quieto > 30) return; } else quieto = 0;
    raf = requestAnimationFrame(cuadro);
  }
  function arrancar() { if (!raf && estado.vivo && !document.hidden) { quieto = 0; raf = requestAnimationFrame(cuadro); } }

  const ro = new ResizeObserver(() => { n = 0; if (construir()) arrancar(); });
  ro.observe(el);
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) { if (raf) { cancelAnimationFrame(raf); raf = 0; } } else arrancar();
  });

  function destruir() {
    estado.vivo = false;
    if (raf) cancelAnimationFrame(raf);
    ro.disconnect(); clearTimeout(espera);
    if (geo) geo.dispose();
    material.dispose();
    renderer.dispose();
    renderer.forceContextLoss();
    renderer.domElement.remove();
    delete el.__particulas;
  }

  arrancar();
}

// Atiende los divs que Flutter pidió antes de que cargara este módulo.
window.iniciarParticulas = crear;
window.particulasMover = (el, x, y) => {
  if (!el) return;
  if (!el.__particulas) crear(el); // por si se destruyó mientras estaba fuera del DOM
  el.__particulas.mover?.(x, y);
};
window.particulasSalir = (el) => { el?.__particulas?.salir?.(); };
(window.__particulas || []).splice(0).forEach(crear);
