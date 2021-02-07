class_name AttackPhase
extends GameState

func turn_phase():
	return TurnPhase.ATTACK_PHASE

func can_go_to_next_phase() -> bool:
	return true

func can_attack() -> bool:
	return true
