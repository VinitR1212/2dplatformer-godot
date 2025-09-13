extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export_category("Run")
@export var max_speed: float = 180.0
@export var accel_ground: float = 2200.0
@export var decel_ground: float = 2600.0
@export var accel_air: float = 1400.0
@export var decel_air: float = 1600.0

@export_category("Jump")
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_speed: float = 360.0
@export var jump_cut_multiplier: float = 3.0
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@export_category("Misc")
@export var stop_on_ceiling: bool = true

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0

func _ready() -> void:
	jump_cut_multiplier = max(1.0, jump_cut_multiplier)
	coyote_time = max(0.0, coyote_time)
	jump_buffer_time = max(0.0, jump_buffer_time)

func _physics_process(delta: float) -> void:
	_process_timers(delta)
	_handle_input_buffering()
	_apply_horizontal(delta)
	_apply_vertical(delta)
	_move_and_resolve()

func _process_timers(delta: float) -> void:

	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		_coyote_timer = max(0.0, _coyote_timer - delta)

	if _jump_buffer_timer > 0.0:
		_jump_buffer_timer = max(0.0, _jump_buffer_timer - delta)

func _handle_input_buffering() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time

	var can_jump_now := is_on_floor() or (_coyote_timer > 0.0)
	if _jump_buffer_timer > 0.0 and can_jump_now:
		_do_jump()
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0

func _do_jump() -> void:
	velocity.y = -jump_speed

func _apply_horizontal(delta: float) -> void:
	var input_dir := Input.get_axis("move_left", "move_right")
	
	if input_dir > 0:
		animated_sprite.flip_h = false
	if input_dir < 0:
		animated_sprite.flip_h = true
	if is_on_floor():
		if input_dir == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walking")
	else:
		animated_sprite.play("jump")
	var target := input_dir * max_speed

	var on_ground := is_on_floor()
	var is_accelerating := absf(target) > 0.0
	var a := (
		accel_ground if on_ground else accel_air
	) if is_accelerating else (
		decel_ground if on_ground else decel_air
	)

	velocity.x = move_toward(velocity.x, target, a * delta)

func _apply_vertical(delta: float) -> void:
	velocity.y += gravity * delta

	if velocity.y < 0.0 and not Input.is_action_pressed("jump"):
		velocity.y += gravity * (jump_cut_multiplier - 1.0) * delta

	if stop_on_ceiling and is_on_ceiling() and velocity.y < 0.0:
		velocity.y = 0.0

func _move_and_resolve() -> void:
	move_and_slide()
