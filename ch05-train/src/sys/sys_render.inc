;;==============================================================
;; Challenge 5 · Render: la OAM sombra
;; ❌ No lo modifiques
;;==============================================================
IF !DEF(RENDER_INC)
DEF RENDER_INC = 1

INCLUDE "man/man_entity.inc"

DEF SHADOW_OAM_SIZE = MAX_ENTITIES * 4    ;; 32 bytes: 4 per entity

ENDC
