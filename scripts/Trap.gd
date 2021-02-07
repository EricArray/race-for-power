class_name Trap
extends Reference

var card: Card

func _init(card: Card):
	self.card = card
	
func trigger_on(target: EntityInBoard, callback: Dictionary):
	card.def.resolve_on_play_with_target(target, callback)
