extends Node

signal log_message(message)

func log(message: String):
	emit_signal("log_message", message)
