class_name Gun extends Sprite2D


@onready var barrel: Marker2D = $Barrel


func fire() -> void:
	const LASER_BEAM := preload("res://scenes/laser_beam.tscn")
	var laser_beam: LaserBeam = LASER_BEAM.instantiate()
	laser_beam.global_transform = barrel.global_transform
	call_deferred(&"add_sibling", laser_beam)
