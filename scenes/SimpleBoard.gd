extends Control

onready var button_next_phase := $TurnPhase/VBoxContainer/NextPhase
onready var label_turn_phase := $TurnPhase/VBoxContainer/TurnPhase
onready var log_scroll := $Log/ScrollContainer
onready var log_container := $Log/ScrollContainer/VBoxContainer

enum Players {
	P1,
	P2,
}

func _ready():
	game.connect("set_state", self, "_on_Game_set_state")
	_on_Game_set_state()

	game.connect("create_animation", self, "_on_Game_create_animation")

	console.connect("log_message", self, "_on_Game_log_message")
	log_scroll.get_v_scrollbar().connect("changed", self, "_on_LogScroll_changed")

func _on_Game_set_state():
	match game.turn_phase:
		TurnPhase.MAIN_PHASE:
			label_turn_phase.text = "Main phase"
		TurnPhase.ATTACK_PHASE:
			label_turn_phase.text = "Attack phase"
		TurnPhase.RECOVER_PHASE:
			label_turn_phase.text = "Recover phase"

	button_next_phase.disabled = not game.state.can_go_to_next_phase()

func _on_NextPhase_pressed():
	game.go_to_next_phase()

func _on_Game_log_message(message: String):
	var new_label := Label.new()
	new_label.autowrap = true
	new_label.text = message
	log_container.add_child(new_label)

var lock_scroll_changed := false

func _on_LogScroll_changed():
	if lock_scroll_changed:
		return
	lock_scroll_changed = true
	log_scroll.scroll_vertical = 999999
	lock_scroll_changed = false

func _on_Game_create_animation(animation: AnimatedSprite):
	add_child(animation)
	animation.play()
