class_name PickTarget
extends GameState

var callback: Callback

func _init(callback: Callback):
	self.callback = callback

func can_pick_target() -> bool:
	return true

func on_target_picked(target: EntityInBoard):
	callback.callback([target])
