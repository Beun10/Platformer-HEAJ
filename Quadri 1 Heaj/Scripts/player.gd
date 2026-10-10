extends RigidBody2D

@export var speed:float
@export var jump_strength:float
var can_climb:bool
var start_position:Vector2
@onready var area_2d: Area2D = $Area2D
var dead:bool

func _ready() -> void:
	lock_rotation = true
	start_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	can_climb = false
	for body in area_2d.get_overlapping_bodies():
		if body.get_groups().has("Surface"):
			can_climb = true
	if (linear_velocity.y == 0 || can_climb) && not dead:
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
		if Input.is_action_pressed("move_left"):
			velocity.x = -speed
		if Input.is_action_just_pressed("jump"):
			apply_impulse(Vector2(0, -jump_strength))
	
	apply_force(velocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
	can_climb = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	for group in area.get_groups():
		if group.contains("Killzone"):
			linear_velocity = Vector2.ZERO
			gravity_scale = 0
			position = start_position
			dead = true

func _on_area_2d_area_exited(area: Area2D) -> void:
		for group in area.get_groups():
			if group.contains("Killzone"):
				await get_tree().create_timer(0.01).timeout
				gravity_scale = 1
				dead = false
