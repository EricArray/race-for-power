extends Node

signal log_message(message)

func log(message: String):
	print(message)
	emit_signal("log_message", message)
