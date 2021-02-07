class_name InstantEffect
extends Reference

func build_description() -> String:
	return "<INVALID INSTANT EFFECT>"

func resolve():
	print("<INVALID INSTANT EFFECT>")

func resolve_with_target(target: EntityInBoard, callback: Dictionary = {}):
	resolve()
