class_name EntitiesController
extends Reference

signal entities_updated()
signal entity_updated(entity)

var entities: Array = []

func reset():
	entities = []
	emit_signal("entities_updated")

func entities_controlled_by_player(player_id: int):
	var r := []
	for entity in entities:
		if entity.controller_player_id == player_id:
			r.append(entity)
	return r

func recover_all_entities_controlled_by_player(player_id: int):
	for entity in entities_controlled_by_player(player_id):
		entity.exhausted = false
		update_entity(entity)

func create_entity(controller_player_id: int, card_def: CardDef): 
	entities.push_back(EntityInBoard.new(controller_player_id, card_def))
	emit_signal("entities_updated")
	
	console.log(card_def.card_name + " created")

	if card_def.static_effect:
		card_def.static_effect.apply(controller_player_id)

	if card_def.on_play:
		card_def.resolve_on_play(controller_player_id)

func update_entity(entity: EntityInBoard):
	if entity.life <= 0:
		destroy_entity(entity)
	else:
		emit_signal("entity_updated", entity)

func destroy_entity(entity: EntityInBoard):
	entities.erase(entity)
	emit_signal("entities_updated")
	
	console.log(entity.def.card_name + " destroyed")
	
	if entity.def.static_effect:
		entity.def.static_effect.undo(entity.controller_player_id)
	
	if entity.def.on_destroyed:
		entity.def.resolve_on_destroyed(entity.controller_player_id)

func exhaust(entity: EntityInBoard):
	entity.exhausted = true
	update_entity(entity)

func damage(entity: EntityInBoard, damage_amount: int):
	entity.life -= damage_amount
	update_entity(entity)

func heal(entity: EntityInBoard, heal_amount: int):
	entity.life += heal_amount
	update_entity(entity)
