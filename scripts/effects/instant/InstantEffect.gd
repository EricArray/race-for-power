class_name InstantEffect
extends Reference

func build_description() -> String:
	return "<INVALID INSTANT EFFECT>"

func resolve(player_id: int):
	print("<INVALID INSTANT EFFECT>")

func resolve_with_target(player_id: int, target: EntityInBoard, callback: Callback = null):
	resolve(player_id)
