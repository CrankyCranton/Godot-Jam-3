# If hits gas can, gas can explodes with
# gas_can_explosion.radius = radius * 2 - distance_to(gas_can)
class_name Explosion extends Area2D


@export var radius := 32.0
@export var density := 2.0
@export var max_smoke := 2.0
#@export var smoke_spawns := 2

var hit: Array[Node2D] = []

@onready var fire: GPUParticles2D = %Fire
@onready var holy_smoke: GPUParticles2D = %"HolySmoke!"
@onready var shape: CollisionShape2D = $Shape
@onready var line_of_fire: RayCast2D = $LineOfFire


func _ready() -> void:
	explode()


func _physics_process(_delta: float) -> void:
	ray_scan()


func explode() -> void:
	var avg_speed: float = lerpf(fire.process_material.initial_velocity_min,
			fire.process_material.initial_velocity_max, 0.5)
	var lifetime := radius / avg_speed

	fire.lifetime = lifetime
	fire.amount = roundi(radius * density)
	#fire.process_material.sub_emitter_frequency = smoke_spawns / lifetime
	holy_smoke.amount = roundi(fire.amount * max_smoke)#fire.process_material.sub_emitter_frequency * lifetime
	fire.emitting = true

	await create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE
			).tween_property(shape.shape, ^"radius", radius, fire.lifetime).finished
	shape.set_deferred(&"disabled", true)
	await get_tree().create_timer(holy_smoke.lifetime, false).timeout
	queue_free()


func ray_scan() -> void:
	for body in get_overlapping_bodies():
		#if body is TileMapLayer or body in hit:
			#return

		line_of_fire.target_position = line_of_fire.to_local(body.global_position)
		line_of_fire.force_raycast_update()
		if line_of_fire.get_collider() == body:
			hit.append(body)
			if body is Wall or body is Target:
				body.explode()
			elif body is Player:# or body is Alien:
				body.die()
