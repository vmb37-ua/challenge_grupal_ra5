;;==============================================================
;; Challenge 5 · Ejercicio 03 · sys_physics_one / sys_physics_update: mover y soltar lo que sale (corregir el código)
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Escribe aquí el código CORREGIDO del papel.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej03" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ03 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_physics_one` está en src/sys/sys_physics.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej03a::`.
;;   `sys_physics_update` está en src/sys/sys_physics.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej03b::`.
;;
;; QUÉ HAY QUE HACER
;;   Este código mueve UNA entidad (`Y += VY`, `X += VX`) y decide qué pasa en los bordes.
;;   Con `INPUT` salta a `sys_physics_limit_x`. Sin `INPUT`, se libera al salir de la pantalla.
;;   `sys_physics_update` lo aplica a todas las entidades.
;;   Tiene errores de todo tipo. Encuéntralos y corrígelos.
;;
;; PISTAS
;;   - Una velocidad negativa va en complemento a 2: `VX = -1` es `$FF`. Sumarla resta 1.
;;   - Una `X` que baja de 0 pasa a 255: `cp ENTITY_OUT_X` es sin signo.
;;   - `cp` deja el carry a 1 si `A` es menor.
;;   - Sigue el código con una entidad concreta y anota los registros.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 03a", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Moves ONE entity: Y += VY, X += VX. Then, what happens at the edges depends on it:
;;  - The entities with INPUT (the ship) are controlled by the player: they
;;    cannot leave. Their limits are done by sys_physics_limit_x (given): jump to it.
;;  - The others are freed if they leave the screen (Y >= ENTITY_OUT_Y or
;;    X >= ENTITY_OUT_X). Note: a coordinate that goes below 0 wraps to 255.
;; Only works on entities with the PHYSICS component.
;; (A semi-generic system: ideally every entity would have its own limits
;;  and its own policy, but that is too much for this level.)
;; 📥 INPUT: DE: entity
;; ❌ May modify A, BC, DE, HL
ej03a::   ;; = `sys_physics_one`, que está en src/sys/sys_physics.asm
    ;; ⁕⁕YOUR CODE⁕⁕
    ret ;; ◀━REMOVE RET IF NEEDED


SECTION "Ejercicio 03b", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Moves ALL the entities that have PHYSICS.
;; ❌ May modify A, BC, DE, HL
ej03b::   ;; = `sys_physics_update`, que está en src/sys/sys_physics.asm
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej03 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidad 1: asteroide en Y=50, X=80, VY=2, VX=-1 (FF). DE = entidad 1.
;; [CPU]
;; [MEM] entity_array + 8 (8 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  .. .. .. .. .. .. .. ..|87 34 4F 4D 00 02 FF 04|
;;  Y = 50 + 2 = 34 (52 en decimal) y X = 80 - 1 = 4F. Sigue viva.
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Entidad 1: asteroide en Y=50, X=0, VY=1, VX=-1 (FF). DE = entidad 1.
;; [CPU]
;; [MEM] entity_array + 8 (8 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  .. .. .. .. .. .. .. ..|00 33 FF 4D 00 01 FF 04|
;;  X pasa de 0 a FF (255): es >= ENTITY_OUT_X y se libera (CMP = 00).
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ03 = 1): __ (SÍ / NO / NO LO SÉ)
