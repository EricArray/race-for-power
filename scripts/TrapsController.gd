extends Node

signal traps_updated()

var traps: Array = []

func reset():
	traps = []
	emit_signal("traps_updated")
	
func create_trap(card: Card):
	traps.push_back(Trap.new(card))
	emit_signal("traps_updated")

func check_trigger_traps(player_state: PlayerState, target: EntityInBoard) -> bool:
	for trap in traps:
		if player_state.try_spend_power(trap.card.def.power_cost):
			traps.erase(trap)
			emit_signal("traps_updated")
			
			trap.trigger_on(target)
			
			cards_controller.discard_card(trap.card)
			
			return true
	return false
		
