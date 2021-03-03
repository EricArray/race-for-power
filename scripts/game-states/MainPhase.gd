class_name MainPhase
extends GameState

func name() -> String:
	return "Main phase"

func can_go_to_next_phase() -> bool:
	return true

func can_play_cards_in_hand() -> bool:
	return true
