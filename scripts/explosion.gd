extends Node2D


@onready var fire: GPUParticles2D = $Fire
@onready var holy_smoke: GPUParticles2D = $"HolySmoke!"

@export var radius := 64.0
@export var density := 1.0


func _ready() -> void:
	var avg_speed: float = lerpf(fire.process_material.initial_velocity_min,
			fire.process_material.initial_velocity_max, 0.5)
	fire.lifetime = radius / avg_speed
	fire.amount = roundi(radius * density)
	holy_smoke.amount = fire.amount
	fire.emitting = true
