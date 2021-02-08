class_name TrapsController
extends Reference

signal traps_updated()

var traps: Array = []

func reset():
	traps = []
	emit_signal("traps_updated")
	
func create_trap(controller_player_id: int, card: Card):
	traps.push_back(Trap.new(controller_player_id, card))
	emit_signal("traps_updated")

func traps_controlled_by_player(player_id: int):
	var r := []
	for trap in traps:
		if trap.controller_player_id == player_id:
			r.append(trap)
	return r

func check_trigger_traps(player_id: int, target: EntityInBoard, callback: Callback) -> bool:
	for trap in traps_controlled_by_player(player_id):
		if game.player(player_id).can_play(trap.card.def) and game.player(player_id).try_spend_power(trap.card.def.power_cost):
			traps.erase(trap)
			emit_signal("traps_updated")
			
			trap.trigger_on(target, callback)
			
			game.discard_card(player_id, trap.card)
			
			return true
	return false
		
