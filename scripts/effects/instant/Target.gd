class_name Target
extends InstantEffect

var on_target: OnTarget

func _init(on_target: OnTarget):
	self.on_target = on_target

func build_description() -> String:
	return on_target.build_description() + " target entity"

func resolve(player_id: int):
	game.set_state(PickTarget.new(Callback.new(self, "_on_target_picked", [player_id])))

func _on_target_picked(target: EntityInBoard, player_id: int):
	resolve_with_target(player_id, target)

func resolve_with_target(player_id, target: EntityInBoard, callback: Callback = null):
	var animation := load("res://scenes/Fire.tscn")
	var a : AnimatedSprite = animation.instance()
	a.connect("animation_finished", self, "_on_animation_finished", [a, target, callback])
	game.emit_signal("create_animation", a)
	
func _on_animation_finished(animation: AnimatedSprite, target: EntityInBoard, callback: Callback):
	animation.queue_free()
	on_target.on_target(target)
	if callback:
		callback.callback()
	game.set_state(MainPhase.new())
