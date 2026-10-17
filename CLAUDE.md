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

## Sprites
- Carpeta `sprites/`, nombres `<grupo>_<elemento>_<n>.png` (ej. `spx_abeto_0.png`, `newspx_roca_3.png`, `wsrc_hacha_0.png`). Los grupos coinciden con las variables de `game.js`.
- Cada entrada de `SPX`/`NEWSPX` es `[ruta, ancho, alto, escala]`; los árboles de `NA` llevan `[ruta, ancho, alto]` (p. ej. roble 205×360).
- El arte se genera con Pixellab.ai. Si se cambia un sprite, mantener su tamaño en píxeles o actualizar las medidas en `game.js`.

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
