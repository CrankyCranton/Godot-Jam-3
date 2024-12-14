class_name Grenade extends RigidBody2D


@export var radius := 32.0

var thrown := false

@onready var glow: PointLight2D = $Glow
@onready var fuse: Timer = $Fuse


func collect() -> void:
	freeze = true
	glow.hide()


func throw(velocity: Vector2, torque: float) -> void:
	fuse.start()
	freeze = false
	apply_central_impulse(velocity)
	apply_torque_impulse(torque)
	thrown = true


func _on_fuse_timeout() -> void:
	const EXPLOSION := preload("res://scenes/explosion.tscn")
	var explosion: Explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position
	print(global_position)
	explosion.radius = radius
	add_sibling.call_deferred(explosion)
	await explosion.ready
	queue_free()
