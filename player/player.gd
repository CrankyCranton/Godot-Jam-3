extends CharacterBody2D

@export var speed:float
@export var accel:float

@onready var camera:Camera2D = $Camera2D
@onready var dash_timer:Timer = $DashTimer
#@onready var gun:Node2D = $Gun

var number_of_bombs:int = 2

var can_dash:bool = true

var grenade_load:PackedScene = preload("res://player/explosive/explosive.tscn")

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").limit_length()

	velocity.x = move_toward(velocity.x,input_direction.x * speed,accel)
	velocity.y = move_toward(velocity.y,input_direction.y * speed,accel)

	move_and_slide()
	#gun.look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("Grenade") and number_of_bombs > 0:
		var grenade: RigidBody2D = grenade_load.instantiate()
		grenade.position = global_position

		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - grenade.position).normalized()

		var forward_force: int = 400
		get_tree().root.call_deferred("add_child", grenade)
		grenade.apply_central_impulse(direction * forward_force)
		number_of_bombs - 0

		#var grenade:RigidBody2D = grenade_load.instantiate()
		grenade.position = global_position

		#var forward_force:int = 500
		#get_tree().root.call_deferred("add_child",grenade)
		#grenade.apply_central_impulse(input_direction * forward_force)

	if Input.is_action_just_pressed("dash") and can_dash == true:
		dash_timer.start()
		velocity = input_direction * 300

func camera_shake():
	$Camera2D.apply_shake()


func _on_dash_timer_timeout() -> void:
	accel = 10
	can_dash = false
	await get_tree().create_timer(0.3).timeout
	can_dash = true

func remove_task(indx:int):
	$CanvasLayer/Task_list.remove_task(2)
