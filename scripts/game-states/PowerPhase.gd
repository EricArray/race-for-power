class_name PowerPhase
extends GameState

func turn_phase():
	return TurnPhase.POWER_PHASE

func is_power_phase() -> bool:
	return true
