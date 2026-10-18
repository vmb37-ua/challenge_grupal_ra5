;;==============================================================
;; Challenge 5 · Ejercicio 02 · man_entity_for_each: llamar a una rutina por cada entidad
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej02" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ02 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `man_entity_for_each` está en src/man/man_entity.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej02::`.
;;
;; QUÉ HAY QUE HACER
;;   Recorre las entidades; para cada una viva, llama a la dirección `HL` (`"call hl"`). Al llamar a `HL`, `DE` = dirección de la entidad viva.
;;
;;   Así, `HL` será la dirección del `sys_xxx_one` de cualquier sistema. Este mismo bucle se reutiliza para que todos los sistemas procesen todas las entidades vivas una a una.
;;
;; PASOS
;;   1. Guarda con `push` lo que la rutina puede cambiar: `BC` (tu contador), `DE` (la entidad) y `HL` (la rutina).
;;   2. Llama con `call call_hl`. `DE` ya apunta a la entidad.
;;   3. Restaura con `pop`, en orden inverso.
;;   4. En `.skip`: suma `SIZEOF_ENTITY` a `E` (el array está alineado), resta 1 a `B` y repite mientras no sea 0. Al final, `ret`.
;;
;; PISTAS
;;   - La rutina llamada (dirección en `HL`) podría modificar cualquier registro.
;;   - Cada `push` necesita su `pop`. Si falta uno, la pila se descuadra.
;;   - Para inspeccionar: pon `ld b, b` (BGB se detiene) y mira los registros.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 02", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calls a routine once for every entity that is alive.
;; 📥 INPUT: HL: address of the routine to call
;;           The routine receives DE = the entity, and it may modify
;;           every register: for_each looks after its own state.
;; ❌ May modify A, BC, DE, HL
;; ⚠️ Use "call call_hl" to call the routine whose address is in HL
ej02::   ;; = `man_entity_for_each`, que está en src/man/man_entity.asm
    ld   de, entity_array       ;; \ DE = first entity
    ld   b, MAX_ENTITIES        ;; / B = entities left

.next
    ld   a, [de]                ;; \ A = entity.CMP
    bit  CMP_ALIVE_BIT, a       ;; | Is it alive?
    jr   z, .skip               ;; / No (it is free): skip it

    ;; ◉◉YOUR CODE◉◉
.skip                           ;; .skip is required by line 57
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED



;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej02 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidades 0, 2 y 5 vivas (solo CMP = 81). HL = tst_cb_log: apunta en tst_log el byte bajo de cada entidad y destruye todos los registros.
;; [CPU]
;; [MEM] tst_log (17 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C800  00 10 28 00 00 00 00 00|00 00 00 00 00 00 00 00|
;;   C810  03 .. .. .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;;  tst_log: byte bajo de cada entidad llamada, en orden. El último byte (C810) es tst_n: cuántas veces se llamó.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Las 8 entidades vivas. La rutina llamada destruye BC, DE y HL en cada llamada: for_each debe seguir bien.
;; [CPU]
;; [MEM] tst_log (17 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C800  00 08 10 18 20 28 30 38|00 00 00 00 00 00 00 00|
;;   C810  08 .. .. .. .. .. .. ..|.. .. .. .. .. .. .. ..|
;;  Se llama 8 veces. Si falta algún push/pop, se llama a otras direcciones o se cuelga.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ02 = 1): __ (SÍ / NO / NO LO SÉ)
