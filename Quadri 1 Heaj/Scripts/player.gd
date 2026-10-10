extends RigidBody2D

@export var speed:float
@export var jump_strength:float
var can_climb:bool

func _ready() -> void:
	lock_rotation = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if linear_velocity.y == 0 || can_climb:
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
		if Input.is_action_pressed("move_left"):
			velocity.x = -speed
		if Input.is_action_just_pressed("jump"):
			apply_impulse(Vector2(0, -jump_strength))

	apply_force(velocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
	can_climb = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	can_climb = false
