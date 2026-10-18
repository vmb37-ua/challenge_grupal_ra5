;;==============================================================
;; Challenge 5 · Ejercicio 12 · scene_game_update / game_handle_collisions: el orden del juego
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej12" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ12 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `scene_game_update` está en src/scn/scn_game.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej12a::`.
;;   `game_handle_collisions` está en src/scn/scn_game_rules.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej12b::`.
;;
;; QUÉ HAY QUE HACER
;;   - `scene_game_update`: un fotograma del juego. Llama en ORDEN a los sistemas: *check* de fin del juego + colisiones (justo tras renderizar) y después actualizar todo, paso a paso.
;;   - `game_handle_collisions`: las reglas de colisión. Lanza 3 veces el sistema de colisiones, para cada tipo de colisión:
;;   1. Disparo contra enemigos
;;   2. Nave contra enemigos
;;   3. Nave contra bonus
;;
;; PASOS
;;   1. `scene_game_update`: `is_ship_gone` y el cambio a Game Over ya están dados. Escribe las llamadas, en este orden: `game_handle_collisions`, `sys_input_update`, `game_handle_shooting`, `sys_spawn_update`, `sys_physics_update`, `sys_shot_update`, `sys_selfdestroy_update` y, al final, `sys_prerender_update`.
;;   2. `game_handle_collisions`: con disparo (`sys_shot_get`; `Z` = no hay), `B = KIND_ENEMY` y `sys_collision_update`. Si choca: `game_enemy_hit`. Sin disparo: salta a `.ship`.
;;   3. Las pasadas de la nave contra asteroides y monedas ya están dadas.
;;
;; PISTAS
;;   - `sys_collision_update` devuelve en `A` cuántas colisiones hubo y `Z` si ninguna: `call nz, rutina` solo llama si hubo.
;;   - `is_ship_gone` va primero: ninguna entidad ha podido ocupar aún el hueco de la nave.
;;   - Colisiones después de renderizar: el contacto se ve en pantalla antes de reaccionar.
;;   - `sys_shot_update` va después de la física: ella mueve el disparo y puede liberarlo al salir de la pantalla.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 12a", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game scene, every frame. First, the collisions; then, everything moves.
;; This way the collisions are checked with the positions that have just
;; been DRAWN, so the player sees the shot touch the asteroid (or the
;; asteroid touch the ship) before anything happens.
;;
;;  0. If the ship is gone (is_ship_gone: Z), it has finished exploding:
;;     go to the game over scene (scene_gameover).
;;     (This must be the first thing: nothing can have taken that slot yet.)
;;  1. game_handle_collisions: all the collisions of the game and what they cause.
;;  2. sys_input_update (sets VX from the D-pad), game_handle_shooting (A shoots),
;;     sys_spawn_update, sys_physics_update (it moves EVERYTHING: the ship, the
;;     asteroids and the shot), sys_shot_update (the physics may have freed the
;;     shot: it forgets it) and sys_selfdestroy_update.
;;  3. sys_prerender_update: prepares the sprites of how everything has ended
;;     up. The main loop copies them to the OAM in VBLANK.
ej12a::   ;; = `scene_game_update`, que está en src/scn/scn_game.asm
    call is_ship_gone            ;; Z if the ship has gone
    jp   z, .game_over

    ;; ◉◉YOUR CODE◉◉

.game_over
    ld   hl, scene_gameover
    jp   scene_change

SECTION "Ejercicio 12b", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; All the collisions of the game, and what they cause. The system
;; (sys_collision_update) only checks ONE probe against all the entities:
;; the rules of the game say who is the probe, who it collides with and what happens.
;;  1. The shot (if there is one, sys_shot_get) against the asteroids (KIND_ENEMY).
;;     If it hits any, call game_enemy_hit.
;;  2. The ship (SHIP_ENTITY) against the asteroids. If it hits any:
;;     call game_ship_destroyed. The ship becomes an explosion and the
;;     game goes on until the explosion disappears.
;;  3. The ship against the bonus items (KIND_BONUS).
;;     If it catches any, call game_bonus_taken.
;; ⚠️ sys_collision_update returns Z (none) / NZ (at least one)
;; ❌ May modify A, BC, DE, HL
ej12b::   ;; = `game_handle_collisions`, que está en src/scn/scn_game_rules.asm

    ;; ◉◉YOUR CODE◉◉

.ship
    ld   hl, SHIP_ENTITY        ;; \ HL = the ship (the probe)
    ld   b, KIND_ENEMY          ;; | B = it collides with asteroids
    call sys_collision_update   ;; | A = how many it has hit
    call nz, game_ship_destroyed ;; / Some: the ship becomes an explosion

    ld   hl, SHIP_ENTITY        ;; \ HL = the ship (the probe)
    ld   b, KIND_BONUS          ;; | B = it collides with bonus items
    call sys_collision_update   ;; | A = how many it has caught
    call nz, game_bonus_taken   ;; / Some: points

    ret

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej12 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> La nave, un disparo (Y=60, X=100) y un asteroide encima (Y=62, X=100). Sin pulsar nada. spawn_timer = 100 (no sale otro).
;; [CPU]
;; [MEM] score (3 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  00 00 01 .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;; [MEM] shot_entity (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|.. .. .. .. .. .. 00 00|
;; [MEM] entity_array (64 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  97 90 54 4B 00 00 00 01|00 3C 64 4C 00 FC 00 02|
;;   C010  89 3C 64 50 00 00 00 0B|00 00 00 00 00 00 00 00|
;;   C020  00 00 00 00 00 00 00 00|00 00 00 00 00 00 00 00|
;;   C030  00 00 00 00 00 00 00 00|00 00 00 00 00 00 00 00|
;;  Colisiones primero: el disparo destruye el asteroide (marcador 001), aparece una explosión y el disparo desaparece.
;;  Después se mueve todo lo demás. La explosión (CMP = 88) usa KIND como cuenta atrás.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> La nave y un disparo en la entidad 1 (Y = 2, X = 100). Sin pulsar nada. spawn_timer = 100 (no sale ningún asteroide).
;; [CPU]
;; [MEM] shot_entity (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|.. .. .. .. .. .. 00 00|
;; [MEM] entity_array (16 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  97 90 54 4B 00 00 00 01|00 FE 64 4C 00 FC 00 02|
;;  La física mueve el disparo: 2 - 4 = FE (sale por arriba) y lo libera (CMP = 00). Después sys_shot_update lo olvida: shot_entity = 0000.
;;  Si sys_shot_update va antes de la física, shot_entity seguiría apuntando a una entidad libre.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; ==========================================================
;; === FIXES
;;  Tipo: Cant. => Tramos
;;  *  N:    __ => __     (1 fix = -1 tramo)
;;  *  E:    __ => __     (1 fix = -1 tramo)
;;  *  S:    __ => __     (2 fix = -1 tramo. En grupos de 2 solo)
;;  *  F:    __ => __     (2 fix = -1 tramo. En grupos de 2 solo)
;;      TOTAL:     __ tramos
;;
;; EXPLICACIONES ADICIONALES DE FIXES (si es necesario)
;;  *
;;
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ12 = 1): __ (SÍ / NO / NO LO SÉ)
