extends CharacterBody2D

@export var speed:float
@export var accel:float

@onready var camera:Camera2D = $Camera2D

var grenade_load:PackedScene = preload("res://player/explosive/explosive.tscn")

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").limit_length()

	velocity.x = move_toward(velocity.x,input_direction.x * speed,accel)
	velocity.y = move_toward(velocity.y,input_direction.y * speed,accel)

	move_and_slide()

	if Input.is_action_just_pressed("Grenade"):
		var grenade:RigidBody2D = grenade_load.instantiate()
		grenade.position = global_position

		var forward_force:int = 500
		get_tree().root.call_deferred("add_child",grenade)
		grenade.apply_central_impulse(input_direction * forward_force)


func camera_shake():
	$Camera2D.apply_shake()
