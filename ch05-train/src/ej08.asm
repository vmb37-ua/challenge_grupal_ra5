;;==============================================================
;; Challenge 5 · Ejercicio 08 · sys_render_update: copiar la OAM sombra a la OAM
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej08" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ08 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_render_update` está en src/sys/sys_render.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej08::`.
;;
;; QUÉ HAY QUE HACER
;;   Espera al VBLANK y copia los primeros `SHADOW_OAM_SIZE` bytes de la `shadow_oam` a la OAM.
;;   Esta rutina no sabe nada de entidades: solo copia.
;;   Además marca el ritmo del juego: cada fotograma espera aquí (por la espera a VBLANK)
;;
;; PASOS
;;   1. `call wait_vblank` (ya hecha).
;;   2. `HL` = `shadow_oam`, `DE` = `OAM_START`, `B` = `SHADOW_OAM_SIZE`.
;;   3. Salta a `memcpy8`: su `ret` vuelve a quien te llamó.
;;
;; PISTAS
;;   - Son 32 bytes: caben de sobra en un VBLANK.
;;   - Sin esperar al VBLANK, la copia puede perderse o dar sprites rotos, sobre todo en consola real.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 08", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shows the sprites: waits for VBLANK and copies the first SHADOW_OAM_SIZE bytes of
;; the shadow OAM (the sprites of the entities) to the OAM, which is at OAM_START ($FE00).
;; The OAM can only be written during VBLANK (and with the screen off).
;; This routine knows nothing about entities: it is a plain copy.
;; ❌ May modify A, B, DE, HL
;; ⚠️ Use wait_vblank and memcpy8
ej08::   ;; = `sys_render_update`, que está en src/sys/sys_render.asm
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej08 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> La OAM sombra tiene 00, 01, 02 ... 9F (160 bytes).
;; [CPU]
;; [MEM] FE00 (32 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   FE00  00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   FE10  10 11 12 13 14 15 16 17|18 19 1A 1B 1C 1D 1E 1F|
;;  Solo se copian los primeros SHADOW_OAM_SIZE = 32 bytes.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> La OAM sombra tiene 80, 81 ... (160 bytes). Antes, la OAM FE00-FE3F se llena con 77.
;; [CPU]
;; [MEM] FE00 (64 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   FE00  80 81 82 83 84 85 86 87|88 89 8A 8B 8C 8D 8E 8F|
;;   FE10  90 91 92 93 94 95 96 97|98 99 9A 9B 9C 9D 9E 9F|
;;   FE20  77 77 77 77 77 77 77 77|77 77 77 77 77 77 77 77|
;;   FE30  77 77 77 77 77 77 77 77|77 77 77 77 77 77 77 77|
;;  FE00-FE1F: 80 ... 9F (copiados). FE20-FE3F: siguen en 77 (no se copian).
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ08 = 1): __ (SÍ / NO / NO LO SÉ)
