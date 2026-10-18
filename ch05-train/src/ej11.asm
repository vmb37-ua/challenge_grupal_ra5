;;==============================================================
;; Challenge 5 · Ejercicio 11 · scene_menu_update / scene_gameover_update: cambiar de escena con START
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej11" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ11 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `scene_menu_update` está en src/scn/scn_menu.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej11a::`.
;;   `scene_gameover_update` está en src/scn/scn_gameover.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej11b::`.
;;
;; QUÉ HAY QUE HACER
;;   - `scene_menu_update`: si se acaba de pulsar START, cambia a `scene_game`.
;;   - `scene_gameover_update`: si se acaba de pulsar START, vuelve a `scene_menu`.
;;
;;   Si no se ha pulsado START, no hacen nada.
;;
;; PASOS
;;   1. `A` = `input_pressed`: los botones pulsados en ESTE fotograma, no los que siguen pulsados.
;;   2. Mira el bit de START (`and BTN_START`). Si no está: `ret z`.
;;   3. `HL` = escena destino y salta a `scene_change`.
;;
;; PISTAS
;;   - `input_held`: botones pulsados ahora. `input_pressed`: botones recién pulsados (flanco de pulsación).
;;   - Con `input_held`, al tocar START saltarían menú, juego y Game Over. Por eso usamos el flanco.
;;   - `scene_change` apaga la pantalla, prepara la escena y la enciende. Salta con `jp`.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 11a", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu scene, every frame: if START has just been pressed, go to
;; the game scene (scene_game). If not, do nothing.
;; ⚠️ Use input_pressed (the "edge") and scene_change
ej11a::   ;; = `scene_menu_update`, que está en src/scn/scn_menu.asm
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

SECTION "Ejercicio 11b", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game over scene, every frame: if START has just been pressed, go to
;; the menu scene (scene_menu). If not, do nothing.
;; Each scene only updates its own things: this one does not touch the game.
ej11b::   ;; = `scene_gameover_update`, que está en src/scn/scn_gameover.asm
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej11 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Escena actual = menú. Se acaba de pulsar START. Llamamos a la actualización del menú (ej11a).
;; [CPU]
;; [MEM] scene_current (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|AF 0C .. .. .. .. .. ..|
;;  scene_current = dirección de scene_game (0CAF, byte bajo primero). La pantalla se apaga y enciende durante el cambio.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Escena actual = Game Over. Se acaba de pulsar START. Llamamos a la actualización de Game Over (ej11b).
;; [CPU]
;; [MEM] scene_current (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|9E 0D .. .. .. .. .. ..|
;;  scene_current = dirección de scene_menu (0D9E).
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ11 = 1): __ (SÍ / NO / NO LO SÉ)
