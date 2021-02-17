extends Node

signal add_animation_to_screen(animated_sprite)

func play_animation(animation_scene: PackedScene, on_top_of: Control, finished_callback: Callback = null):
	var on_top_of_center =  on_top_of.get_global_rect().position +  on_top_of.get_global_rect().size / 2
	
	var animated_sprite : AnimatedSprite = animation_scene.instance()
	emit_signal("add_animation_to_screen", animated_sprite)
	animated_sprite.position = on_top_of_center
	animated_sprite.play()
	animated_sprite.connect("animation_finished", self, "_on_animation_finished", [animated_sprite, finished_callback])

func _on_animation_finished(animated_sprite: AnimatedSprite, finished_callback: Callback):
	animated_sprite.queue_free()
	if finished_callback:
		finished_callback.callback()
