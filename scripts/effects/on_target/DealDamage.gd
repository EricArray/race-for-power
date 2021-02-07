class_name DealDamage
extends OnTarget

var damage: int

func _init(damage: int):
	self.damage = damage

func build_description() -> String:
	return "deal %s damage to target entity" % damage

func on_target(target: EntityInBoard):
	target.life -= damage
	game.update_entity(target)
