# ASHFALL — guía del proyecto para Claude

Juego de supervivencia **2D isométrico en pixel art**, para móvil (y navegador de escritorio).
Estilo visual e interacción de Last Day on Earth + mundo, progreso y físicas de Valheim.
**Sin motor de juego** (ni Unity, Unreal ni Godot): todo es HTML + Canvas 2D + JavaScript puro.
El usuario es principiante: explica los pasos con claridad y comprueba que todo funciona antes de darlo por hecho.
Los textos del juego y la interfaz están en **español**.

## Cómo ejecutarlo
Hay que abrirlo con un servidor local (con doble clic en `index.html` el navegador bloquea el análisis de sprites en canvas).
- Windows: doble clic en `iniciar-servidor.bat` → abre http://localhost:8000/
- Alternativa: `python -m http.server 8000` en esta carpeta.

## Estructura de carpetas
- `index.html` — solo la estructura (canvas `#cv`, HUD, menús, pantalla de título).
- `css/style.css` — estilos de HUD y menús.
- `js/game.js` — todo el juego, dentro de una función autoejecutable `(()=>{ 'use strict'; ... })()`.
- `sprites/` — todos los PNG (antes estaban incrustados en base64). **Nunca volver a incrustar imágenes en el código.**
- `CLAUDE.md` — este archivo.

## Mapa de `js/game.js` (los números de línea se desplazan: busca por el título de sección)
`DATOS` (recetas, armas `WEAP`, bloques `BT`, comidas, densidades de bioma) · `ESTADO` (variables globales, sprites `NA`/`SPX`/`NEWSPX`/`WSRC`, entrada `IN`) · `MUNDO` (`genWorld`, ruido `fbm`, relieve) · `CONSTRUCCIÓN Y ESTABILIDAD` · `INVENTARIO Y CRAFTEO` · `JUGADOR Y COMBATE` · `ENEMIGOS` · `ACTUALIZACIÓN` (`update(dt)`) · `EFECTOS` (sangre, partículas) · `DIBUJO` (`drawRes`, `drawBlock`, `drawPlayer`, sombras, hojas) · `HUD Y UI` · `ENTRADA` (táctil + teclado/ratón) · `GUARDADO` · `BUCLE`.

## Constantes clave
- Mundo: `N=140` casillas por lado, centro `CX,CY`. Ciclo día/noche `DAYLEN=420` s.
- Proyección isométrica: `HW=40`, `HH=20` (media anchura y altura de casilla), `HZ=40` (píxeles por unidad de elevación). Zoom `ZOOMS=[.8,1,1.3]`.
- Construcción: bloque `SB=1.5`, altura de pared `WH=1.6`, grosor `TH=.34`.
- Guardado: `localStorage`, clave `ashfall_v2`.
- Biomas: Claros, Bosque Oscuro, Pantano, Montaña. Jefe: Guardián de Raíces.

## Sprites (organizados en carpetas)
Todos los sprites están en `sprites/`, agrupados por tipo y, cuando aplica, por bioma o material. Los nombres de archivo no cambian: solo se mueven.
- `player/` — `sin_armadura/` (hoja de carrera, `spr_0.png`), `ataques/` (`pun_0.png`), `comer/` (`eat_0.png`). Las armaduras irán en `player/armaduras/<tipo>/`.
- `armas/` — `basicas/` (espada, garrote, hacha, lanza, martillo, pico), `cobre/` (lanza de cobre), `escudos/`. Nuevos materiales: `armas/<material>/`.
- `animales/` — `jabali/`, `lobo/`. Nuevos animales: `animales/<nombre>/`.
- `arboles/` — `claros/`, `bosque_oscuro/`, `pantano/`, `otros/abedul/`.
- `recursos/` — `arbustos/`, `ramas/`, `troncos/`, `rocas/`, `piedras/`, `tocones/claros/` y `tocones/bosque_oscuro/`.
- `construccion/` — `paredes/madera/`, `suelos/madera/`, `puertas/madera/` (hoja y marco), `ventanas/madera/`. Nuevos materiales: `<tipo>/piedra/`, etc.
- `construibles/` — `estaciones/banco_de_trabajo/`.
- `jefes/` — `guardian_de_raices/`.
- `efectos/` — `sangre/` (manchas permanentes).
- `terrenos/` — `claros/`, `bosque_oscuro/`, `pantano/` (texturas del suelo).

Las rutas están escritas a mano en `js/game.js` (por ejemplo `"sprites/arboles/claros/spx_pradera_0.png"`). **Al mover o renombrar un sprite hay que actualizar también esa ruta en el código**, o el juego dejará de mostrarlo.
Cada entrada de `SPX`/`NEWSPX`/`NA` lleva `[ruta, ancho, alto, escala]`; los árboles de `NA` llevan `[ruta, ancho, alto]`.
El arte se genera con Pixellab.ai. Si se cambia un sprite, mantener su tamaño en píxeles o actualizar las medidas en `game.js`.
Nunca volver a incrustar imágenes en base64 dentro del código.

## Texturas del terreno
- `sprites/terrenos/claros/texs_0.jpeg` (480×480) = hierba del bioma **Claros**; `sprites/terrenos/bosque_oscuro/texs_1.jpeg` (512×512) = **Bosque Oscuro**; `sprites/terrenos/pantano/img_pantanot_0.jpeg` (512×512) = **Pantano**. Se cargan en `TEXS` (línea `const TEXS=[...]`); `TW` regula cuánto se repite cada una.
- Deben ser **sin costuras** (se repiten en mosaico) y dibujadas **vistas desde arriba**: el juego las deforma él mismo a la proyección isométrica.
- No incluir sombreado de altura: el juego genera solo 5 variantes de brillo según el relieve (`GR`).
- Otros terrenos (montaña, arena, nieve, agua…) usan colores planos (`TILECOL`) y no tienen textura; añadir uno nuevo requiere tocar `game.js`.
- Para cambiar una textura: reemplazar el archivo manteniendo el nombre y la extensión, recargar con Ctrl+F5 y comprobar el resultado.

## Reglas de diseño (decididas por el usuario)
- Personaje tipo **gladiador**, siempre a la misma velocidad: solo animación de **correr en 8 direcciones** (sin caminar). Inicia en taparrabos; la armadura es un segundo aspecto.
- Fauna: jabalíes, ciervos, lobos (IA con manadas, arqueros, voladores y acuáticos previstos). Árboles: abetos, pinos, abedules. Terrenos: hierba, tierra, arena, nieve, fango, agua de lagos.
- Comida con buffs de vida/estamina (máx. 3 activas). Crafteo avanzado solo en estaciones físicas (banco, forja, ahumador). Construcción modular con estabilidad física; paredes transparentes al caminar detrás. Combate con timing, parry y esquiva. Armas visibles en la mano. Sangre y charcos permanentes. Pantalla completa al iniciar.
- Controles: táctiles (joystick + botones) y teclado/ratón. Móvil primero.

## Normas de trabajo
1. Antes de cambiar nada, lee la sección correspondiente de `game.js` y respeta el estilo existente (código compacto, español en textos).
2. Cambios pequeños y comprobables. Tras cada cambio, abrir el juego y verificar que carga sin errores en la consola.
3. Si hay varias sesiones trabajando a la vez, cada una toca **una sección distinta** de `game.js` y avisa si necesita tocar datos compartidos (`DATOS`, `ESTADO`).
4. Guardar versión con Git cuando algo funcione: `git add .` → `git commit -m "..."` → `git push`.
5. Pendiente de mejora: dividir `game.js` en módulos por sistema (mundo, combate, construcción, enemigos, dibujo, interfaz) para trabajar en paralelo con menos conflictos.
