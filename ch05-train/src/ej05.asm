;;==============================================================
;; Challenge 5 · Ejercicio 05 · sys_shot_update: comprobar que el disparo sigue ahí
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej05" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ05 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_shot_update` está en src/sys/sys_shot.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej05::`.
;;
;; QUÉ HAY QUE HACER
;;   `sys_shot_update` comprueba que EL disparo sigue ahí. Si ya no está, lo olvida: pone `shot_entity` a 0.
;;
;;   `sys_physics` mueve el disparo y lo elimina si escapa de la pantalla, `sys_collision` detecta si impacta y lo destruye. `sys_shot_update` comprueba si ha sido destruido, para dejar de seguirlo.
;;
;;   El disparo sigue ahí si:
;;   1. Su entidad está viva (`ALIVE`)
;;   2. y es `KIND_SHOT`
;;
;;   La entidad podría haberse liberado (no `ALIVE`), y podría haber otra entidad nueva (no sería `KIND_SHOT`).
;;
;; PASOS
;;   1. El código dado carga en `HL` el puntero `*(shot_entity)` y sale si no hay disparo.
;;   2. ¿Está viva su entidad? `bit CMP_ALIVE_BIT, [hl]`. Si no, olvídalo.
;;   3. ¿Es aún un disparo? Apunta `HL` a `KIND` (suma `E_KIND` a `L`) y compara con `KIND_SHOT`. Si lo es, `ret`.
;;   4. Olvidarlo: pon a 0 los dos bytes de `shot_entity` y `ret`.
;;
;; PISTAS
;;   - Un puntero de 16 bits (`shot_entity`) se guarda con el byte bajo primero (*little-endian*).
;;   - Puedes usar `bit n, r` para comprobar bits.
;;   - `cp KIND_SHOT` deja `Z` si es igual: `ret z`.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 05", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks that THE shot is still there, and if not, forgets it (shot_entity = 0).
;; sys_physics moves the shot and frees it when it leaves the screen, like any
;; other entity: this system does not move anything. The shot is still there only if
;; its entity is alive AND it is still a shot (KIND_SHOT): its slot may have been
;; freed, or taken by another entity (an asteroid, for example).
;; If there is no shot, it does nothing.
;; ❌ May modify A, HL
ej05::   ;; = `sys_shot_update`, que está en src/sys/sys_shot.asm
    ld   a, [shot_entity]       ;; \ HL = *(shot_entity)
    ld   l, a                   ;; |
    ld   a, [shot_entity + 1]   ;; |
    ld   h, a                   ;; / = the shot

    or   a                      ;; \ Is there a shot?
    ret  z                      ;; / No: nothing to do

    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej05 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Disparo en la entidad 1: Y = 100, X = 60. Llamamos a sys_shot_update (ej05).
;; [CPU]
;; [MEM] shot_entity (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|.. .. .. .. .. .. 08 C0|
;; [MEM] entity_array + 8 (8 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  .. .. .. .. .. .. .. ..|87 64 3C 4C 00 FC 00 02|
;;  La entidad 1 está viva y es un disparo: no cambia nada, ni shot_entity ni la entidad. Mover el disparo es cosa de la física.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> shot_entity apunta a la entidad 1. Llamamos DOS veces a sys_shot_update (ej05): primero con la entidad 1 libre (CMP = 00) y después con un asteroide en su sitio. Tras cada llamada, shot_entity debe valer 0000.
;; [CPU]
;; [MEM] shot_entity (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|.. .. .. .. .. .. 00 00|
;; [MEM] tst_log (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C800  00 00 .. .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;; [MEM] entity_array + 8 (8 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  .. .. .. .. .. .. .. ..|87 64 3C 4D 00 00 00 04|
;;  tst_log: shot_entity tras la primera llamada (0000). Tras la segunda también vale 0000 (shot_entity). El asteroide que ocupa la entidad 1 no se toca.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ05 = 1): __ (SÍ / NO / NO LO SÉ)
