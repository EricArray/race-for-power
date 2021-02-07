class_name Target
extends InstantEffect

var on_target: OnTarget

func _init(on_target: OnTarget):
	self.on_target = on_target

func build_description() -> String:
	return on_target.build_description() + " target entity"

func resolve():
	game.set_state(PickTarget.new(self, "_on_target_picked"))

func _on_target_picked(target: EntityInBoard):
	on_target.on_target(target)
	game.set_state(MainPhase.new())
