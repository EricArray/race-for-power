class_name BeginPhase
extends GameState

func name() -> String:
	return "Begin phase"

func on_start():
	game.go_to_next_phase()
