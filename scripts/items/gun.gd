class_name Gun extends Area2D


@export var ammo := 3

@onready var barrel: Marker2D = $Barrel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fire_at_random() -> void:
	for i in ammo:
		await get_tree().create_timer(randf_range(0.0, 3.0)).timeout
		fire()


func fire() -> void:
	if ammo <= 0:
		return
#region Create laser beam
	const LASER_BEAM := preload("res://scenes/laser_beam.tscn")
	var laser_beam: LaserBeam = LASER_BEAM.instantiate()
	laser_beam.global_transform = barrel.global_transform
	add_sibling.call_deferred(laser_beam)
#endregion

	ammo -= 1
	if ammo <= 0:
		animation_player.play(&"delete")
