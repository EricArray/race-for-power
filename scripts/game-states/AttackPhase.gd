class_name AttackPhase
extends GameState

func name() -> String:
	return "Attack phase"

func can_go_to_next_phase() -> bool:
	return true

func can_attack() -> bool:
	return true
