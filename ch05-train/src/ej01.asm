;;==============================================================
;; Challenge 5 · Ejercicio 01 · man_entity_alloc: reservar una entidad (corregir el código)
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Escribe aquí el código CORREGIDO del papel.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej01" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ01 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `man_entity_alloc` está en src/man/man_entity.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej01::`.
;;
;; QUÉ HAY QUE HACER
;;   Reserva una entidad libre y devuelve `Z` con `HL` apuntando a ella. Si el array está lleno, devuelve `NZ`.
;;   Tiene errores de todo tipo. Encuéntralos y corrígelos.
;;
;; PISTAS
;;   - Lee el contrato: qué recibe, qué devuelve, qué puede modificar.
;;   - Sigue el código con un caso: entidad 0 viva y entidad 1 libre.
;;   - Revisa cada instrucción: ¿existe?, ¿hace lo que debe?
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 01", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Looks for a free entity and reserves it.
;; 📥 INPUT:   A: components the new entity will have (CMP_SPRITE, ...)
;; ⫷▬ RETURNS: Z,  HL = address of the entity, and [HL] = A | CMP_ALIVE
;;             NZ, there is no free entity
;; ❌ May modify A, BC, HL. Must NOT modify DE
;; ⚠️ It does not change the other fields: the caller fills them in
ej01::   ;; = `man_entity_alloc`, que está en src/man/man_entity.asm
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED
    
;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej01 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidades 0 y 1 vivas, la 2 libre. A=SPRITE | PHYSICS, DE=1234 (no cambia).
;; [CPU]
;;    flag Z: 1   ← Z = hay hueco · NZ = lleno
;;    hl = C010
;;    de = 1234
;; [MEM] entity_array (24 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  97 90 54 4B 00 00 00 01|87 28 3C 4D 00 00 00 04|
;;   C010  83 00 00 00 00 00 00 00|.. .. .. .. .. .. .. ..|
;;  La entidad 2 queda reservada: CMP = A | ALIVE = 83. Los demás bytes de la entidad no se tocan.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Las 8 entidades están vivas. A = SPRITE, DE = 1234.
;; [CPU]
;;    flag Z: 0   ← Z = hay hueco · NZ = lleno
;;    de = 1234
;; [MEM] entity_array (64 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  80 00 00 00 00 00 00 00|80 00 00 00 00 00 00 00|
;;   C010  80 00 00 00 00 00 00 00|80 00 00 00 00 00 00 00|
;;   C020  80 00 00 00 00 00 00 00|80 00 00 00 00 00 00 00|
;;   C030  80 00 00 00 00 00 00 00|80 00 00 00 00 00 00 00|
;;  No se modifica ninguna entidad.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ01 = 1): __ (SÍ / NO / NO LO SÉ)
