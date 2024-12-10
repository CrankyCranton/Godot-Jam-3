extends CharacterBody2D

@export var speed:float
@export var accel:float

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").limit_length()

	velocity.x = move_toward(velocity.x,input_direction.x * speed,accel)
	velocity.y = move_toward(velocity.y,input_direction.y * speed,accel)

	move_and_slide()
