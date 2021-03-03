class_name GameState
extends Reference

func name() -> String:
	return "<INVALID GAME STATE>"

func can_go_to_next_phase() -> bool:
	return false

func can_play_cards_in_hand() -> bool:
	return false

func can_attack() -> bool:
	return false

func can_activate() -> bool:
	return false

func can_pick_target() -> bool:
	return false

func on_target_picked(target: EntityInBoard):
	pass

func on_start():
	pass
