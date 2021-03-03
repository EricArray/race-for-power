class_name Target
extends InstantEffect

var animation_scene := preload("res://scenes/animations/Fire.tscn")
var on_target: OnTarget

func _init(on_target: OnTarget):
	self.on_target = on_target

func build_description() -> String:
	return on_target.build_description() + " target entity"

func resolve(player_id: int):
	game.push_state(PickTarget.new(Callback.new(self, "_on_target_picked", [player_id])))

func _on_target_picked(target: EntityInBoard, player_id: int):
	game.pop_state()
	resolve_with_target(player_id, target)

func resolve_with_target(player_id, target: EntityInBoard, callback: Callback = null):
	animations_controller.play_animation(
		animation_scene,
		target.control,
		Callback.new(self, "_on_animation_finished", [target, callback])
	)
	
func _on_animation_finished(target: EntityInBoard, callback: Callback):
	on_target.on_target(target)
	if callback:
		callback.callback()
