;;==============================================================
;; Challenge 5 · Ejercicio 06 · sys_prerender_one: preparar el sprite de una entidad
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej06" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ06 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_prerender_one` está en src/sys/sys_prerender.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej06::`.
;;
;; QUÉ HAY QUE HACER
;;   Si la entidad en `DE` tiene `CMP_SPRITE`, copia los 4 bytes del sprite a `shadow_cursor`, la dirección del siguiente hueco en la Shadow OAM. Después, avanza +4 `shadow_cursor`, quedando listo para copiar el siguiente.
;;   Si no tiene `CMP_SPRITE`, no hace nada.
;;   El Sprite son los 4 bytes `Y, X, TILE, ATTR` de la entidad:
;;               E_SPRITE = E_Y = 1
;;                      ┃          Entity
;;               ┏━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;;               ┃ 0    1   2    3      4            7  ┃
;;   WRAM0  ... | CMP | Y | X | TILE | ATTR | ... | KIND | ...
;;                 ┃   ┗━━━━━━━━━━━━━━━━━━━┛
;;                 ┃          Sprite
;;                DE (address of the first byte of the Entity)
;;
;; PASOS
;;   1. Filtro: sin `CMP_SPRITE`, `ret`.
;;   2. `HL` = origen: `ld hl, E_SPRITE` y `add hl, de`.
;;   3. `DE` = destino: el valor de `shadow_cursor` (2 bytes, bajo y alto).
;;   4. `B` = 4 y `call memcpy8`. Al volver, `DE` está 4 bytes más allá.
;;   5. Guarda `DE` en `shadow_cursor` y `ret`.
;;
;; PISTAS
;;   - `memcpy8`: `HL` origen, `DE` destino, `B` bytes.
;;   - Calcula `HL` ANTES de cargar el cursor en `DE`: necesitas `DE` (la entidad) para el origen.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 06", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prepares ONE entity to be drawn: copies its sprite (Y, X, TILE, ATTR:
;; 4 bytes, in the same order as the OAM) to the shadow OAM, to the place
;; that shadow_cursor says, and moves the cursor 4 bytes on.
;; If the entity does not have CMP_SPRITE, it does nothing.
;; 📥 INPUT: DE: entity
;; ❌ May modify A, B, DE, HL
;; ⚠️ Use memcpy8
ej06::   ;; = `sys_prerender_one`, que está en src/sys/sys_prerender.asm
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej06 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidad 0 (la nave, con SPRITE). shadow_cursor = shadow_oam + 8. La OAM sombra está llena de EE.
;; [CPU]
;; [MEM] shadow_oam (16 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C040  EE EE EE EE EE EE EE EE|90 54 4B 00 EE EE EE EE|
;; [MEM] shadow_cursor (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0F0  4C C0 .. .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;;  Los 4 bytes (Y, X, TILE, ATTR) de la nave se copian en shadow_oam + 8, y el cursor avanza 4 (shadow_oam + 12 = C040 + 12).
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidad con PHYSICS pero SIN SPRITE. shadow_cursor = shadow_oam + 8. La OAM sombra, llena de EE.
;; [CPU]
;; [MEM] shadow_oam (16 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C040  EE EE EE EE EE EE EE EE|EE EE EE EE EE EE EE EE|
;; [MEM] shadow_cursor (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0F0  48 C0 .. .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;;  No se copia nada y el cursor no se mueve.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ06 = 1): __ (SÍ / NO / NO LO SÉ)
