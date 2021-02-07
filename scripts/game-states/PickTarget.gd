class_name PickTarget
extends GameState

var callback_target: Object
var callback_method: String
var callback_binds: Array

func _init(callback_target: Object, callback_method: String, callback_binds: Array = []):
	self.callback_target = callback_target
	self.callback_method = callback_method
	self.callback_binds = callback_binds

func can_pick_target() -> bool:
	return true

func on_target_picked(target: EntityInBoard):
	var args = [target] + callback_binds
	callback_target.callv(callback_method, args)
