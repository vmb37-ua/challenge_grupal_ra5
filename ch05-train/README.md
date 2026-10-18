# Challenge 5 · Entrenamiento

## Qué tocar

- `src/ej01.asm` … `src/ej12.asm`: tu código. Uno por ejercicio.
- `src/main.asm`: solo las líneas `DEF` de arriba (`TEST` y `EJ01` … `EJ12`).
- `src/chcode/`: no tocar (pruebas y código del proyecto).
- El resto de `src/` es el juego. Lo ya hecho está en binario (`src/bin/`); sus **contratos** están en los comentarios.

## Cómo funciona

Cada ejercicio vive en su sitio (por ejemplo, `sys_physics_one` en `src/sys/sys_physics.asm`), pero allí solo hay un salto. Tu código va en `src/ej03.asm`, bajo `ej03a::`.

- **Completar**: escribe lo que falta donde dice `<<YOUR CODE>>`.
- **Corregir**: escribe el código ya corregido.

## Prueba un ejercicio (P1 y P2)

1. En `main.asm`: `DEF TEST EQUS "test_ej05"`. Ejecuta `make`.
2. Abre `game.gb` en BGB y pulsa F9. Cada parada en un `ld b, b` es un caso (P1, P2).
3. Compara CPU y MEM con el RESULTADO ESPERADO del final de `ej05.asm`. F9 pasa al siguiente.

Las pruebas usan las rutinas del proyecto para todo lo demás.

## Prueba el juego

1. En `main.asm`: `DEF TEST EQUS "game"`.
2. Pon a `1` los `EJ01` … `EJ12` que quieras probar. Con `0` se usa la rutina del proyecto.
3. `make` y abre `game.gb` en BGB.

## BGB

- Activa *Options* (F11) → *Exceptions* → **break on ld b,b (40h)**.
- Símbolos: la primera vez, `ln -s obj/game.sym` en la carpeta del proyecto.

## Los ejercicios

| Ej. | Rutinas | Etiquetas |
| :-: | --- | --- |
| 1 | `man_entity_alloc` | `ej01` |
| 2 | `man_entity_for_each` | `ej02` |
| 3 | `sys_physics_one`, `sys_physics_update` | `ej03a`, `ej03b` |
| 4 | `sys_shot_spawn` | `ej04` |
| 5 | `sys_shot_update` | `ej05` |
| 6 | `sys_prerender_one` | `ej06` |
| 7 | `sys_prerender_update` | `ej07` |
| 8 | `sys_render_update` | `ej08` |
| 9 | `sys_collision_overlaps` | `ej09` |
| 10 | `sys_collision_one` | `ej10` |
| 11 | `scene_menu_update`, `scene_gameover_update` | `ej11a`, `ej11b` |
| 12 | `scene_game_update`, `game_handle_collisions` | `ej12a`, `ej12b` |

## Si un ejercicio no ensambla

Renómbralo a `ejXX.asm.no` y prueba el resto. Con `EJXX = 0` el juego no lo usa.

## Entrega

`make cleanall` antes de comprimir: no entregues `obj/`, `game.gb`, `game.sym` ni `game.sav`.
