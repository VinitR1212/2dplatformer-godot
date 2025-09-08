@tool
extends Control

@export var world_index: int = 1
@export var level_select_packed: PackedScene = load("res://scenes/level_select.tscn")
@onready var level_select_scene: LevelSelect = level_select_packed.instantiate()

func _ready() -> void:
	$Label.text = "World " + str(world_index)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Label.text = "World " + str(world_index)
