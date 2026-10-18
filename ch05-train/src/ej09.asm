;;==============================================================
;; Challenge 5 · Ejercicio 09 · sys_collision_overlaps: ¿se solapan dos entidades?
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej09" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ09 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_collision_overlaps` está en src/sys/sys_collision.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej09::`.
;;
;; QUÉ HAY QUE HACER
;;   Comprueba si dos entidades se solapan: `DE` = entidad 1, `HL` = entidad 2.
;;   Ocurre si en LOS DOS ejes (X e Y), la distancia entre ellas es menor que `HIT_SIZE` (ancho de colisión):
;;   - `|Y1 - Y2| < HIT_SIZE`
;;   - `|X1 - X2| < HIT_SIZE`
;;
;;   Devuelve en el carry: `C` = se solapan, `NC` = no.
;;
;;   `|U - V|` es el valor absoluto: la distancia sin signo. Tras `sub`, si hay Carry la resta es negativa y se corrige con el complemento a 2 (`cpl` + `inc a`).
;;
;; PASOS
;;   1. El cálculo de `|dY|` ya está dado. Termina el eje Y: `cp HIT_SIZE`. Sin carry (distancia mayor o igual): `ret nc`.
;;   2. Repite con la `X`: `inc de` / `inc hl`, resta y valor absoluto.
;;   3. Termina con `cp HIT_SIZE` y `ret`: el carry es la respuesta.
;;
;; PISTAS
;;   - Es el cálculo del Challenge 4 (`cpl` + `inc`), ahora en dos ejes.
;;   - Si el primer eje falla, no hace falta mirar el segundo.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 09", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Do two entities overlap? They do if, in BOTH axes, the distance
;; between their positions is less than HIT_SIZE: |Y1 - Y2| < HIT_SIZE
;; and |X1 - X2| < HIT_SIZE.
;; 📥 INPUT:   DE: entity 1,  HL: entity 2
;; ⫷▬ RETURNS (in the carry, as in Challenge 4):
;;    C,  they overlap
;;    NC, they do not
;; ❌ May modify A, DE, HL
ej09::   ;; = `sys_collision_overlaps`, que está en src/sys/sys_collision.asm
    inc  de                     ;; \ DE -> Y1
    inc  hl                     ;; / HL -> Y2

    ld   a, [de]                ;; \ A = Y1 - Y2
    sub  [hl]                   ;; /

    jr   nc, .y_positive        ;; \ Positive: it is already |dY|
    cpl                         ;; | Negative: |dY| = -dY
    inc  a                      ;; / (cpl + inc: two's complement)

.y_positive

    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej09 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidad 1 en (Y=50, X=50) y entidad 2 en (Y=53, X=47). DE = entidad 1, HL = entidad 2. HIT_SIZE = 7.
;; [CPU]
;;    flag C: 1   ← C = se solapan · NC = no
;;  |dY| = 3 < 7 y |dX| = 3 < 7: se solapan.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidad 1 en (Y=50, X=50) y entidad 2 en (Y=50, X=57). DE = entidad 1, HL = entidad 2.
;; [CPU]
;;    flag C: 0   ← C = se solapan · NC = no
;;  |dY| = 0 pero |dX| = 7: no es menor que HIT_SIZE (7). No se solapan.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ09 = 1): __ (SÍ / NO / NO LO SÉ)
