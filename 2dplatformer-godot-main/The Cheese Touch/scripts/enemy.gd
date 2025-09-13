extends Node2D

const SPEED = 30

var direction = 1

@onready var rcr: RayCast2D = $RCR
@onready var rcl: RayCast2D = $RCL
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta: float) -> void:
	if rcr.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if rcl.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
