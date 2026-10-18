SECTION "Test ej12", ROM0

;;--------------------------------------------------------------
;; Ejercicio 12 · scene_game_update, game_handle_collisions
;;--------------------------------------------------------------
test_ej12::
   ;; CASO 1 · un fotograma con un impacto
   call tst_reset
   tst_ent 0, CMP_ALIVE | CMP_SPRITE | CMP_PHYSICS | CMP_COLLIDER | CMP_INPUT, SHIP_Y, SHIP_X_START, TILE_SHIP, 0, 0, 0, KIND_SHIP
   tst_ent 1, CMP_ALIVE | CMP_SPRITE | CMP_PHYSICS | CMP_COLLIDER, 60, 100, TILE_SHOT, 0, -SHOT_SPEED, 0, KIND_SHOT
   tst_set16 shot_entity, entity_array + 1 * SIZEOF_ENTITY
   tst_ent 2, CMP_ALIVE | CMP_SPRITE | CMP_PHYSICS | CMP_COLLIDER, 62, 100, TILE_ASTEROID_A, 0, 0, 0, KIND_ENEMY
   tst_set8 spawn_timer, 100
   call ej12a
   ld   b, b       ;; ✔ Compara con el RESULTADO ESPERADO de ej12.asm

   ;; CASO 2 · el disparo sale por arriba
   call tst_reset
   tst_ent 0, CMP_ALIVE | CMP_SPRITE | CMP_PHYSICS | CMP_COLLIDER | CMP_INPUT, SHIP_Y, SHIP_X_START, TILE_SHIP, 0, 0, 0, KIND_SHIP
   tst_ent 1, CMP_ALIVE | CMP_SPRITE | CMP_PHYSICS | CMP_COLLIDER, 2, 100, TILE_SHOT, 0, -SHOT_SPEED, 0, KIND_SHOT
   tst_set16 shot_entity, entity_array + 1 * SIZEOF_ENTITY
   tst_set8 spawn_timer, 100
   call ej12a
   ld   b, b       ;; ✔ Compara con el RESULTADO ESPERADO de ej12.asm

   ret
