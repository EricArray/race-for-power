class_name Exhaust
extends OnTarget

func build_description() -> String:
	return "exhaust"

func on_target(target: EntityInBoard):
	game.entities_controller.exhaust(target)
