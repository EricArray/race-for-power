class_name Trap
extends Reference

var controller_player_id: int
var card: Card

func _init(controller_player_id: int, card: Card):
	self.controller_player_id = controller_player_id
	self.card = card
	
func trigger_on(target: EntityInBoard, callback: Callback):
	card.def.resolve_on_play_with_target(controller_player_id, target, callback)
