class_name Grenade extends RigidBody2D


var thrown := false

@onready var glow: PointLight2D = $Glow


func collect() -> void:
	glow.hide()
