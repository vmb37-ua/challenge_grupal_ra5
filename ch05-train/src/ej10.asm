;;==============================================================
;; Challenge 5 · Ejercicio 10 · sys_collision_one: ¿choca esta entidad con la sonda?
;;==============================================================
;;
;; CÓMO TRABAJAR
;;  1. Copia tu código del papel TAL CUAL en cada `<<YOUR CODE>>`. El resto ya está escrito.
;;  2. Cada cambio posterior, con su comentario:  ;; FIX <tipo><nº>: <motivo>   (N, E, S, F)
;;       N: no existe · E: errónea · S: sintaxis · F: falta algo
;;  3. Prueba: en main.asm, DEF TEST EQUS "test_ej10" y make. BGB para en cada `ld b, b` (P1, P2).
;;     Compara CPU y MEM con el RESULTADO ESPERADO del final de este fichero.
;;  4. Juego: DEF TEST EQUS "game" y DEF EJ10 = 1.
;;  5. Rellena la autoevaluación.
;;
;; DÓNDE ESTÁ
;;   `sys_collision_one` está en src/sys/sys_collision.asm. Allí solo hay un salto: tu código va AQUÍ, en `ej10::`.
;;
;; QUÉ HAY QUE HACER
;;   Comprueba colisión de la entidad candidata (en `DE`) contra la entidad sonda (en `collision_probe`).
;;   La candidata (`DE`) debe cumplir tres condiciones:
;;   - tener `COLLIDER`
;;   - su `KIND` está en `collision_mask`
;;   - se solapa con la sonda (`sys_collision_overlaps`)
;;
;;   Si choca, se libera (`man_entity_free`) y `collision_hits` suma 1.
;;
;;   Sistema de colisiones: `sys_collision_update` selecciona una entidad (`collision_probe`) y establece con qué puede colisionar (`collision_mask`). Después, usa `man_entity_for_each` para que llame a `sys_collision_one` una vez por cada entidad viva.
;;   Así llega la ejecución a ti, con una entidad en `DE` para comprobar con la sonda.
;;
;; PASOS
;;   1. Filtro: sin `COLLIDER`, `ret`. (El filtro por `KIND` y máscara ya está dado.)
;;   2. `HL` = puntero guardado en `collision_probe`.
;;   3. Llama a `sys_collision_overlaps` (`DE` = candidata, `HL` = sonda). Protege `DE` con `push` y `pop`: la rutina lo modifica.
;;   4. Sin solape (`NC`): `ret nc`. Con solape: `inc [hl]` sobre `collision_hits` y salta a `man_entity_free` (`DE` = candidata).
;;
;; PISTAS
;;   - La máscara permite chocar con varios tipos a la vez: cada tipo es un bit de `KIND`.
;;   - La nave y el disparo no se confunden: sus `KIND` no están en la máscara de los asteroides.
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "engine/text.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "sys/sys_render.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Ejercicio 10", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Checks ONE entity (the candidate) against the probe, which is in
;; collision_probe. If the candidate has the COLLIDER component, its
;; KIND is one of the kinds in collision_mask, and it overlaps the probe,
;; then it is freed and collision_hits is incremented.
;; 📥 INPUT: DE: candidate entity
;; ❌ May modify A, DE, HL
ej10::   ;; = `sys_collision_one`, que está en src/sys/sys_collision.asm
    ;; <<YOUR CODE>>
    ld   hl, E_KIND             ;; \ HL = &candidate.KIND
    add  hl, de                 ;; |
    ld   a, [collision_mask]    ;; | A = collision_mask & candidate.KIND:
    and  [hl]                   ;; | is it a kind the probe collides with?
    ret  z                      ;; / No: ignore it

    ;; ◉◉YOUR CODE◉◉
    ret ;; ◀━REMOVE RET IF NEEDED

;; ==========================================================
;;  ENSAMBLA: ____  (SÍ / NO)
;; === CASOS DE PRUEBA   (test_ej10 en main.asm)
;;  * Comprobar que CPU y MEM coinciden con el valor esperado
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 1: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Sonda = la nave (entidad 0, Y=144, X=84). Máscara = KIND_ENEMY. Candidata: asteroide en (Y=140, X=88), entidad 3.
;; [CPU]
;; [MEM] collision_probe (4 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. 00 C0 04 01|.. .. .. .. .. .. .. ..|
;; [MEM] entity_array + 24 (8 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C010  .. .. .. .. .. .. .. ..|00 8C 58 4D 00 00 00 04|
;;  collision_probe, collision_mask y collision_hits van seguidos (C0A4: probe, C0A6: máscara, C0A7: hits).
;;  collision_hits = 01 y la candidata queda libre (CMP = 00).
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; * CASO 2: ____  (OK / Falla)
;;
;;        >>>>> RESULTADO ESPERADO (Comprobar) <<<<<
;; [PREVIO]> Igual, pero la candidata es una moneda (KIND_BONUS) y la máscara solo tiene KIND_ENEMY.
;; [CPU]
;; [MEM] collision_probe (4 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C0E0  .. .. .. .. 00 C0 04 00|.. .. .. .. .. .. .. ..|
;; [MEM] entity_array + 24 (8 bytes)
;;         00 01 02 03 04 05 06 07|08 09 0A 0B 0C 0D 0E 0F|
;;   C010  .. .. .. .. .. .. .. ..|87 8C 58 4F 00 00 00 08|
;;  Se ignora aunque se solapen: collision_hits = 00 y la candidata sigue viva.
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
;; EL JUEGO FUNCIONA CON MI EJERCICIO (DEF EJ10 = 1): __ (SÍ / NO / NO LO SÉ)
