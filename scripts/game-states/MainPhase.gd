class_name MainPhase
extends GameState

func turn_phase():
	return TurnPhase.MAIN_PHASE

func can_go_to_next_phase() -> bool:
	return true

func can_play_cards_in_hand() -> bool:
	return true
