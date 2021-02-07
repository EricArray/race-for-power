class_name EveryEntity
extends InstantEffect

var on_target: OnTarget

func _init(on_target: OnTarget):
	self.on_target = on_target

func build_description() -> String:
	return on_target.build_description() + " every entity"

func resolve():
	for entity in game.entities_in_board.duplicate():
		on_target.on_target(entity)
