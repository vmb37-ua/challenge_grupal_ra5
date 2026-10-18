;;==============================================================
;; Challenge 5 · Escena: el juego
;; Su init y su update. El update solo decide el ORDEN de los sistemas (sys/).
;;==============================================================
INCLUDE "engine/hardware.inc"
INCLUDE "gfx/gfx.inc"
INCLUDE "man/man_entity.inc"
INCLUDE "ui/hud.inc"
INCLUDE "scn/scn_game.inc"

SECTION "Scene: game", ROM0

;; Each scene: DW init, update    (see scene_change)
scene_game::     DW scene_game_init, scene_game_update

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game scene: empty field, the HUD, the systems at their start, and the ship.
;; Each module initializes ITS OWN state (xxx_init): the scene does not touch it.
;; The screen is off.
scene_game_init::
   INCBIN "bin/scene_game_init.bin"       ;; Rutina dada, en binario (31 bytes)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 12 (a): `scene_game_update`
;; La implementas TÚ, en src/ej12.asm (etiqueta `ej12a::`). Aquí solo hay un salto:
;; el resto del proyecto llama a `scene_game_update` y no necesita saber dónde está tu código.
scene_game_update::
   jp   go_ej12a             ;; Salta al ejercicio 12 (ver main.asm)
   ds   33, $00              ;; Relleno: las demás rutinas conservan su dirección
