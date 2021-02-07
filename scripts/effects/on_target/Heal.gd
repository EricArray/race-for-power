class_name Heal
extends OnTarget

var heal: int

func _init(heal: int):
	self.heal = heal

func build_description() -> String:
	return "heal %s damage from" % heal

func on_target(target: EntityInBoard):
	target.life += heal
	game.update_entity(target)
