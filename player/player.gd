class_name Player extends CharacterBody2D


signal died

@export var speed:float
@export var accel:float
@export var throw_force := 128.0
@export var throw_torque := 18000.0

@onready var hand:Marker2D = %Hand
@onready var camera:Camera2D = $Camera2D
@onready var dash_timer:Timer = $DashTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var bomb_count:Label = $CanvasLayer/bomb_count
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get(&"parameters/playback")
@onready var anim_dir:Vector2 = Vector2():
	set(value):
		anim_dir = value
		animation_tree.set(&"parameters/Idle/blend_position", anim_dir)
		animation_tree.set(&"parameters/Punch/blend_position", anim_dir)
		animation_tree.set(&"parameters/Run/blend_position", anim_dir)
		animation_tree.set(&"parameters/Throw/blend_position", anim_dir)
#@onready var gun:Node2D = $Gun

var can_animate := true
var number_of_bombs:int = 2
var can_dash:bool = true
var grenade_load:PackedScene = preload("res://scenes/grenade.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"throw"):
		throw()


func _physics_process(delta: float) -> void:
	bomb_count.text = str(number_of_bombs)
	var input_direction = Input.get_vector("left","right","up","down").limit_length()
	if input_direction != Vector2():
		anim_dir = input_direction
	if can_animate:
		playback.travel(&"Run" if input_direction != Vector2() else &"Idle")
	velocity.x = move_toward(velocity.x,input_direction.x * speed,accel)
	velocity.y = move_toward(velocity.y,input_direction.y * speed,accel)

	move_and_slide()
	#gun.look_at(get_global_mouse_position())


	if Input.is_action_just_pressed("Grenade") and number_of_bombs > 0:
		number_of_bombs -= 1
		var grenade:Grenade = grenade_load.instantiate()
		grenade.position = global_position

		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - grenade.position).normalized()

		get_tree().root.call_deferred("add_child", grenade)
		grenade.throw(direction*throw_force,throw_torque)

		#var grenade:RigidBody2D = grenade_load.instantiate()

		#var forward_force:int = 500
		#get_tree().root.call_deferred("add_child",grenade)
		#grenade.apply_central_impulse(input_direction * forward_force)

	if Input.is_action_just_pressed("dash") and can_dash == true:
		dash_timer.start()
		velocity = input_direction * 300


func camera_shake():
	$Camera2D.apply_shake()


func die() -> void:
	died.emit()


func throw() -> void:
	can_animate = false
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
	await get_tree().create_timer(0.5).timeout
	can_dash = true

func remove_task(indx:int):
	$CanvasLayer/Task_list.remove_task(indx)


func _on_pickip_scanner_body_entered(body: Node2D) -> void:
#	if hand.get_child_count() > 0:
		#return
	#if body is Grenade:
		#if body.thrown:
			#return

	#body.collect()
	#body.reparent.call_deferred(hand, false)
	#body.position = Vector2()
	pass


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("punch") or anim_name.begins_with("throw"):
		can_animate = true


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Guard:
		body._die()
