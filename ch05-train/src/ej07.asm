;;==============================================================
;; Challenge 5 · Ejercicio 07 · sys_prerender_update: preparar toda la OAM sombra
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej07" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ07 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_prerender_update` está en src/sys/sys_prerender.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej07::`.
;;
;; QUÉ HAY QUE HACER
;;   Prepara la `shadow_oam`:
;;   1. La llena de 0's (`SHADOW_OAM_SIZE` bytes). Los sprites quedan con `X=0`, fuera de pantalla.
;;   2. Pone `shadow_cursor` a la dirección de inicio `shadow_oam`
;;   3. Lanza `man_entity_for_each` para que copie las entidades vivas con sprite, usando `sys_prerender_one`
;;
;; PASOS
;;   1. Vacía la OAM sombra: `HL` = `shadow_oam`, `A` = 0, `B` = `SHADOW_OAM_SIZE`, `call memset8`.
;;   2. Pon `shadow_cursor` = dirección de `shadow_oam` (`LOW` y `HIGH`).
;;   3. Carga `sys_prerender_one` en `HL` y salta a `man_entity_for_each`.
;;
;; PISTAS
;;   - `LOW(etiqueta)` y `HIGH(etiqueta)` dan el byte bajo y el alto de una dirección.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 07", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prepares the whole shadow OAM (in RAM, so no hurry and no need for VBLANK):
;;  1. Fills it with zeros (Y = 0: every sprite hidden), so that
;;     the entities that no longer exist do not leave sprites behind.
;;  2. Puts shadow_cursor at the start of the shadow OAM.
;;  3. Prepares every entity with sys_prerender_one.
;; ❌ May modify A, BC, DE, HL
;; ⚠️ Use memset8 (clear) and man_entity_for_each
ej07::   ;; = `sys_prerender_update`, que está en src/sys/sys_prerender.asm
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej07 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidades 0 (nave) y 2 (asteroide) con SPRITE. La OAM sombra, llena de EE.
;; [CPU]
;; [MEM] shadow_oam (32 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C040  90 54 4B 00 3C 46 4E 00|00 00 00 00 00 00 00 00|
;;   C050  00 00 00 00 00 00 00 00|00 00 00 00 00 00 00 00|
;; [MEM] shadow_cursor (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0F0  48 C0 .. .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;;  Los 2 sprites ocupan los 8 primeros bytes; el resto (24 bytes) queda a 00. shadow_cursor = shadow_oam + 8.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Ninguna entidad viva. La OAM sombra, llena de EE.
;; [CPU]
;; [MEM] shadow_oam (32 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C040  00 00 00 00 00 00 00 00|00 00 00 00 00 00 00 00|
;;   C050  00 00 00 00 00 00 00 00|00 00 00 00 00 00 00 00|
;; [MEM] shadow_cursor (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0F0  40 C0 .. .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;;  Se vacía todo (32 bytes a 00) y shadow_cursor = shadow_oam.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ07 = 1): __ (SÍ / NO / NO LO SÉ)
