class_name InstantEffect
extends Resource

func build_description() -> String:
	return "<INVALID INSTANT EFFECT>"

func resolve():
	print("<INVALID INSTANT EFFECT>")

func resolve_with_target(target: EntityInBoard):
	resolve()
