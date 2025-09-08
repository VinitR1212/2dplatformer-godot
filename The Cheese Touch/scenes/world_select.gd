extends Control

@onready var worlds: Array = [$WorldIcon1, $WorldIcon2, $WorldIcon3, $WorldIcon4, $WorldIcon5]
var current_world: int = 0

func _ready() -> void:
	$PlayerIcon.global_position = worlds[current_world].global_position

func _input(event):
	if event.is_action_pressed("move_left") and current_world > 0:
		current_world -= 1
		$PlayerIcon.global_position = worlds[current_world].global_position
		
	if event.is_action_pressed("move_right") and current_world < worlds.size() - 1:
		current_world += 1
		$PlayerIcon.global_position = worlds[current_world].global_position
		
	if event.is_action_pressed("start"):
		if worlds[current_world].level_select_scene:
			worlds[current_world].level_select_scene.parent_world_select = self
			get_tree().get_root().add_child(worlds[current_world].level_select_scene)
			get_tree().current_scene = worlds[current_world].level_select_scene
			get_tree().get_root().remove_child(self)
	
