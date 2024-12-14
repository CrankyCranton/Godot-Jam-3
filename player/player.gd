class_name Player extends CharacterBody2D


@export var speed:float
@export var accel:float
@export var throw_force := 128.0
@export var throw_torque := 18000.0

@onready var hand:Marker2D = %Hand
@onready var camera:Camera2D = $Camera2D
@onready var dash_timer:Timer = $DashTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get(&"parameters/playback")
@onready var anim_dir:Vector2 = Vector2():
	set(value):
		anim_dir = value
		animation_tree.set(&"parameters/Idle/blend_position", anim_dir)
		animation_tree.set(&"parameters/Punch/blend_position", anim_dir)
		animation_tree.set(&"parameters/Run/blend_position", anim_dir)
		animation_tree.set(&"parameters/Throw/blend_position", anim_dir)
#@onready var gun:Node2D = $Gun

var number_of_bombs:int = 2
var can_dash:bool = true
var grenade_load:PackedScene = preload("res://player/explosive/explosive.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"throw"):
		throw()


func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down").limit_length()
	if input_direction != Vector2():
		anim_dir = input_direction
	if not playback.get_current_node() in [&"Punch", &"Throw"]:
		pass#playback.travel(&"Run" if input_direction != Vector2() else &"Idle")
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


func throw() -> void:
	if hand.get_child_count() <= 0:
		playback.travel(&"Punch")
	else:
		playback.travel(&"Throw")
		var item := hand.get_child(0)
		item.reparent.call_deferred(get_parent())
		item.throw(anim_dir.normalized() * throw_force, randf_range(-throw_torque, throw_torque))


func _on_dash_timer_timeout() -> void:
	accel = 10
	can_dash = false
	await get_tree().create_timer(0.3).timeout
	can_dash = true

func remove_task(indx:int):
	$CanvasLayer/Task_list.remove_task(indx)


func _on_pickip_scanner_body_entered(body: Node2D) -> void:
	if hand.get_child_count() > 0:
		return
	if body is Grenade:
		if body.thrown:
			return

	body.collect()
	body.reparent.call_deferred(hand, false)
	body.position = Vector2()
