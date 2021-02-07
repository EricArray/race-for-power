class_name GameState
extends Resource

func turn_phase():
	return null

func can_go_to_next_phase() -> bool:
	return false

func can_play_cards_in_hand() -> bool:
	return false

func can_attack() -> bool:
	return false

func can_pick_target() -> bool:
	return false

func on_target_picked(target: EntityInBoard):
	pass

func is_power_phase() -> bool:
	return false

func is_recover() -> bool:
	return false
