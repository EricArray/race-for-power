extends PanelContainer

onready var entities_container := $HBoxContainer/VBoxContainer/EntitiesContainer
onready var set_traps_container := $HBoxContainer/VBoxContainer2/TrapsContainer

export(Players.PlayerId) var player_id: int

const COLOR_CAN_ATTACK := Color("#00ff1e")
const COLOR_CAN_NOT_ATTACK := Color("#FFFFFF")

var EntityView = preload("res://scenes/EntityView.tscn")
var TrapView = preload("res://scenes/TrapView.tscn")

func _ready():
	game.connect("set_state", self, "_on_Game_set_state")
	_on_Game_set_state()
	
	game.entities_controller.connect("entities_updated", self, "_on_Game_set_entities")
	_on_Game_set_entities()

	game.entities_controller.connect("add_entity", self, "_on_Game_add_entity")
	game.entities_controller.connect("remove_entity", self, "_on_Game_remove_entity")

	game.traps_controller.connect("traps_updated", self, "_on_Game_set_traps")
	_on_Game_set_traps()

func _on_Game_set_state():
	var can_attack = game.state().can_attack() and game.turn_player_id == player_id
	self_modulate = COLOR_CAN_ATTACK if can_attack else COLOR_CAN_NOT_ATTACK
	
func _on_Game_set_entities():
	for child in entities_container.get_children():
		entities_container.remove_child(child)
		child.queue_free()

	for entity in game.entities_controller.entities_controlled_by_player(player_id):
		add_entity_view_child(entity)

func _on_Game_add_entity(entity):
	if entity.controller_player_id == player_id:
		add_entity_view_child(entity)
	
func _on_Game_remove_entity(entity):
	for child in entities_container.get_children():
		if child.entity == entity:
			entities_container.remove_child(child)
			child.queue_free()

func add_entity_view_child(entity):
	var entity_view = EntityView.instance()
	entity_view.entity = entity
	entity_view.connect("mouse_entered", zoom_controller, "zoom_card", [entity_view, entity.def])
	entity_view.connect("mouse_exited", zoom_controller, "hide_zoom_card")
	entities_container.add_child(entity_view)
	
	entity.control = entity_view
	
func _on_Game_set_traps():
	for child in set_traps_container.get_children():
		set_traps_container.remove_child(child)
		child.queue_free()

	for trap in game.traps_controller.traps_controlled_by_player(player_id):
		var trap_view = TrapView.instance()
#		trap_view.trap = trap
		trap_view.connect("mouse_entered", zoom_controller, "zoom_card", [trap_view, trap.card.def])
		trap_view.connect("mouse_exited", zoom_controller, "hide_zoom_card")
		set_traps_container.add_child(trap_view)
