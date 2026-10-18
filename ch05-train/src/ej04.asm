;;==============================================================
;; Challenge 5 · Ejercicio 04 · sys_shot_spawn: crear el disparo (solo puede haber uno)
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej04" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ04 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_shot_spawn` está en src/sys/sys_shot.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej04::`.
;;
;; QUÉ HAY QUE HACER
;;   Crea EL disparo llamando a `man_entity_create` y sitúalo en `(D, E) = (Y, X)`. Solo puede haber un disparo: si ya existe o no hay entidades libres, no hace nada y devuelve `NZ`. Si lo crea, anota su dirección en `shot_entity` y devuelve `Z`.
;;
;; PASOS
;;   1. Carga `ShotTemplate` en `HL` y llama a `man_entity_create`.
;;   2. Comprueba si se ha creado. Vuelve si no.
;;   3. Guarda `HL` (dirección de la entidad) en `shot_entity`: primero `L`, luego `H`.
;;   4. Escribe los bytes `(E_Y, E_X)` de la entidad con `(D, E)`.
;;   5. Devuelve `Z`.
;;
;; PISTAS
;;   - `man_entity_create` conserva `DE` (no lo modifica).
;;   - `ShotTemplate` tiene todos los datos de un disparo. Solo hay que ajustar la posición inicial `(Y, X)`.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 04", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Creates THE shot at a position. There can only be ONE shot: if it already
;; exists, or there is no free entity, it does nothing.
;; The entity is created from ShotTemplate data, and then Y and X are changed.
;; The system stores the address of the entity in shot_entity
;; Where the shot appears (D, E) = (Y, X) is a rule of the game: shot_spawn decides it.
;; 📥 INPUT:   D = Y, E = X
;; ⫷▬ RETURNS: Z, the shot has been created
;;             NZ, it has not (there was one, or there is no free entity)
;; ❌ May modify A, BC, HL. Does NOT modify DE
;; ⚠️ Use man_entity_create
ej04::   ;; = `sys_shot_spawn`, que está en src/sys/sys_shot.asm
    ld   a, [shot_entity + 1]   ;; \ A = high byte of shot_entity
    or   a                      ;; | 0 means there is no shot
    ret  nz                     ;; / There is one already: NZ
    
    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej04 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Solo la nave. shot_entity = 0000. D = 100 (Y), E = 50 (X).
;; [CPU]
;;    flag Z: 1   ← Z = disparo creado · NZ = no
;;    de = 6432
;; [MEM] shot_entity (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|.. .. .. .. .. .. 08 C0|
;; [MEM] entity_array (16 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  97 90 54 4B 00 00 00 01|87 64 32 4C 00 FC 00 02|
;;  shot_entity = dirección de la entidad 1 (C000 + 8, byte bajo primero). La entidad 1 se crea con ShotTemplate (con PHYSICS y VY = FC, que trae la plantilla), Y = 100 (64) y X = 50 (32).
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> La entidad 1 es un disparo y shot_entity apunta a ella. D = 100, E = 50.
;; [CPU]
;;    flag Z: 0   ← Z = disparo creado · NZ = no
;;    de = 6432
;; [MEM] shot_entity (2 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. .. .. .. ..|.. .. .. .. .. .. 08 C0|
;; [MEM] entity_array (24 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C000  97 90 54 4B 00 00 00 01|87 14 1E 4C 00 FC 00 02|
;;   C010  00 00 00 00 00 00 00 00|.. .. .. .. .. .. .. ..|
;;  No se crea otro: la entidad 2 sigue libre y el disparo no cambia.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ04 = 1): __ (SÍ / NO / NO LO SÉ)
